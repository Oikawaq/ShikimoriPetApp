//
//  CommentService.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/18/26.
//

import Foundation
import Combine

final class CommentService{
    static let shared = CommentService()
    var page: Int = 1

    func loadComments(id: Int,page: Int,type: CommentableType)-> AnyPublisher<[CommentsModel],NetworkError>{
        NetworkManager.shared.request(endpoint: .comments(id: id, page: page, commentableType: type), method: .get)
    }
    func findTopicId(id: Int)-> AnyPublisher<[TopicsModel], NetworkError>{
        NetworkManager.shared.request(endpoint: .findTopicId(linkedId: id), method: .get)
    }

    func sendComment(body: String, commentableId: Int, commentableType: CommentableType, replyToId: Int? = nil) -> AnyPublisher<CommentsModel, NetworkError> {
        var comment: [String: Any] = [
            "body": body,
            "commentable_id": commentableId,
            "commentable_type": commentableType.apiPath
        ]
        if let replyToId {
            comment["reply_message_id"] = replyToId
        }
        return NetworkManager.shared.request(endpoint: .postComment, method: .post, body: ["comment": comment])
    }

    func filter(unique: [CommentsModel]) -> [CommentsModel] {
        return unique.map { comment in
            var modified = comment
            var body = comment.body

            // 1. Replace smiley shortcodes (:-P, :hypno:) with [img=URL] inline
            body = injectSmileys(into: body, from: comment.htmlBody)

            // 2. Inject real image URLs in place of [image=N] tags (preserves BBCode structure)
            body = injectImages(into: body, from: comment.htmlBody)

            // 3. Handle reply reference [comment=N;M] → extract replyTo nickname
            if let range = body.range(of: "(?<=comment=)[0-9]+", options: .regularExpression) {
                let commentId = Int(body[range])
                if let replyComment = unique.first(where: { $0.id == commentId }) {
                    modified.replyTo = "@\(replyComment.user.nickname)"
                } else if let nickname = extractReplyNickname(commentId: commentId ?? 0, from: comment.htmlBody) {
                    modified.replyTo = "@\(nickname)"
                }
                body = body.replacingOccurrences(of: "\\[comment=[^\\]]+\\]", with: "", options: .regularExpression)
                body = "\(modified.replyTo ?? "")\(body)"
            }

            // 4. Strip all remaining BBCode junk
            body = cleanBBCode(body)

            // 5. Inject [youtube] tags after cleanup so they are never stripped by cleanBBCode
            body = injectYoutube(into: body, from: comment.htmlBody)

            modified.body = body.trimmingCharacters(in: .whitespacesAndNewlines)
            return modified
        }
    }

    // MARK: - Private helpers

    /// Replaces [image=N] placeholders with [img=URL] using image URLs extracted from htmlBody in order.
    private func injectImages(into body: String, from html: String) -> String {
        guard body.contains("[image=") || html.contains("<img") else { return body }
        let urls = extractImageUrls(from: html)
        guard !urls.isEmpty else {
            // No URLs found — just strip the tags
            return body.replacingOccurrences(of: "\\[image=[0-9]+\\]", with: "", options: .regularExpression)
        }
        var result = body
        var urlIndex = 0
        let pattern = "\\[image=[0-9]+\\]"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return result }
        let ns = result as NSString
        var offset = 0
        for match in regex.matches(in: result, range: NSRange(location: 0, length: ns.length)) {
            let adjusted = NSRange(location: match.range.location + offset, length: match.range.length)
            let replacement: String
            if urlIndex < urls.count {
                replacement = "[img=\(urls[urlIndex])]"
                urlIndex += 1
            } else {
                replacement = ""
            }
            result = (result as NSString).replacingCharacters(in: adjusted, with: replacement)
            offset += replacement.count - match.range.length
        }
        // Append any leftover image URLs not referenced in body
        while urlIndex < urls.count {
            result += "\n[img=\(urls[urlIndex])]"
            urlIndex += 1
        }
        return result
    }

    /// Replaces smiley shortcodes (:-P, :hypno:, etc.) with [img=URL] inline using htmlBody alt→src mapping.
    private func injectSmileys(into body: String, from html: String) -> String {
        guard html.contains("smiley") else { return body }
        let pattern = #"<img[^>]+class="[^"]*smiley[^"]*"[^>]*>"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else { return body }
        let ns = html as NSString
        var result = body
        var processed = Set<String>()
        for match in regex.matches(in: html, range: NSRange(location: 0, length: ns.length)) {
            let tag = ns.substring(with: match.range)
            guard let altRange = tag.range(of: #"(?<=alt=")[^"]+"#, options: .regularExpression),
                  let srcRange = tag.range(of: #"(?<=src=")[^"]+"#, options: .regularExpression) else { continue }
            let alt = String(tag[altRange])
            var src = String(tag[srcRange])
            guard !processed.contains(alt) else { continue }
            processed.insert(alt)
            if src.hasPrefix("//") { src = "https:" + src }
            else if src.hasPrefix("/") { src = "https://shikimori.one" + src }
            let escaped = NSRegularExpression.escapedPattern(for: alt)
            result = result.replacingOccurrences(of: escaped, with: "[img=\(src)]", options: .regularExpression)
        }
        return result
    }

    /// Extracts all non-youtube image src URLs from htmlBody, converting relative to absolute.
    private func extractImageUrls(from html: String) -> [String] {
        guard html.contains("<img") else { return [] }
        let pattern = #"<img[^>]+src="([^"]+)"[^>]*>"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        let ns = html as NSString
        return regex.matches(in: html, range: NSRange(location: 0, length: ns.length)).compactMap { match in
            guard match.numberOfRanges > 1, match.range(at: 1).location != NSNotFound else { return nil }
            let fullTag = ns.substring(with: match.range)
            if fullTag.contains("smiley") { return nil } // handled inline by injectSmileys
            var url = ns.substring(with: match.range(at: 1))
            if url.contains("ytimg.com") || url.contains("youtube.com") { return nil }
            if url.hasPrefix("//") { url = "https:" + url }
            else if url.hasPrefix("/") { url = "https://shikimori.one" + url }
            url = url.replacingOccurrences(of: "/thumbnail/", with: "/original/")
            url = url.replacingOccurrences(of: "/preview/", with: "/original/")
            url = url.replacingOccurrences(of: "/x96/", with: "/original/")
            url = url.replacingOccurrences(of: "/x48/", with: "/original/")
            return url
        }
    }

    /// Extracts the nickname of the replied-to user from htmlBody using the comment link.
    /// Shikimori renders [comment=N] as <a href="/comments/N" ...>nickname</a> in htmlBody.
    private func extractReplyNickname(commentId: Int, from html: String) -> String? {
        guard commentId > 0 else { return nil }
        // Shikimori renders: <a href="https://shikimori.io/comments/N" ...><s>@</s><span>NICKNAME</span></a>
        let pattern = "<a[^>]+href=\"https://shikimori\\.[a-z]+/comments/\(commentId)\"[^>]*>[^<]*<s>[^<]*</s>[^<]*<span>([^<]+)</span>"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let ns = html as NSString
        guard let match = regex.firstMatch(in: html, range: NSRange(location: 0, length: ns.length)),
              match.range(at: 1).location != NSNotFound else { return nil }
        let nickname = ns.substring(with: match.range(at: 1)).trimmingCharacters(in: .whitespaces)
        return nickname.isEmpty ? nil : nickname
    }

    /// Converts YouTube URLs in body to [youtube]ID[/youtube] tags in-place, preserving text order.
    /// Falls back to appending if the video from htmlBody has no matching URL in body.
    private func injectYoutube(into body: String, from html: String) -> String {
        var result = body

        // Step 1: Replace [url=YOUTUBE_URL]text[/url] with [youtube]ID[/youtube] in-place
        let urlTagPattern = "\\[url=([^\\]]+)\\][^\\[]*\\[/url\\]"
        if let regex = try? NSRegularExpression(pattern: urlTagPattern, options: .caseInsensitive) {
            let ns = result as NSString
            var offset = 0
            for match in regex.matches(in: result, range: NSRange(location: 0, length: ns.length)) {
                guard match.range(at: 1).location != NSNotFound else { continue }
                let href = ns.substring(with: match.range(at: 1))
                guard let videoId = youtubeId(from: href) else { continue }
                let adjusted = NSRange(location: match.range.location + offset, length: match.range.length)
                let replacement = "[youtube]\(videoId)[/youtube]"
                result = (result as NSString).replacingCharacters(in: adjusted, with: replacement)
                offset += replacement.count - match.range.length
            }
        }

        // Step 2: Replace plain https://youtu.be/ID URLs in-place
        let plainPattern = "https://youtu\\.be/([a-zA-Z0-9_-]+)[^\\s\\]]*"
        if let regex = try? NSRegularExpression(pattern: plainPattern) {
            let ns = result as NSString
            var offset = 0
            for match in regex.matches(in: result, range: NSRange(location: 0, length: ns.length)) {
                guard match.range(at: 1).location != NSNotFound else { continue }
                let videoId = ns.substring(with: match.range(at: 1))
                let adjusted = NSRange(location: match.range.location + offset, length: match.range.length)
                let replacement = "[youtube]\(videoId)[/youtube]"
                result = (result as NSString).replacingCharacters(in: adjusted, with: replacement)
                offset += replacement.count - match.range.length
            }
        }

        // Step 3: For videos in htmlBody not yet referenced in body, append at end
        guard html.contains("b-video") && html.contains("youtube") else { return result }
        let htmlPattern = #"<div class="b-video[^"]*">[^<]*<a[^>]*href="https://youtu\.be/([a-zA-Z0-9_-]+)"[^>]*>.*?</div>"#
        guard let htmlRegex = try? NSRegularExpression(pattern: htmlPattern, options: .dotMatchesLineSeparators) else { return result }
        let htmlNs = html as NSString
        for match in htmlRegex.matches(in: html, range: NSRange(location: 0, length: htmlNs.length)) {
            guard match.range(at: 1).location != NSNotFound else { continue }
            let videoId = htmlNs.substring(with: match.range(at: 1))
            if !result.contains("[youtube]\(videoId)[/youtube]") {
                result += "\n[youtube]\(videoId)[/youtube]"
            }
        }
        return result
    }

    private func youtubeId(from url: String) -> String? {
        let ns = url as NSString
        if let m = try? NSRegularExpression(pattern: "youtu\\.be/([a-zA-Z0-9_-]+)").firstMatch(in: url, range: NSRange(location: 0, length: ns.length)),
           m.range(at: 1).location != NSNotFound {
            return ns.substring(with: m.range(at: 1))
        }
        if let m = try? NSRegularExpression(pattern: "[?&]v=([a-zA-Z0-9_-]+)").firstMatch(in: url, range: NSRange(location: 0, length: ns.length)),
           m.range(at: 1).location != NSNotFound {
            return ns.substring(with: m.range(at: 1))
        }
        return nil
    }

    /// Strips all BBCode tags we don't render, preserving inner text where appropriate.
    private func cleanBBCode(_ input: String) -> String {
        var s = input

        // Self-closing / no-content tags — remove entirely
        let stripEntirely = [
            "\\[replies=[^\\]]*\\]",
            "\\[comment=[^\\]]*\\]",
            "\\[image=[0-9]+\\]",       // any leftover unreplaced image tags
        ]
        for pattern in stripEntirely {
            s = s.replacingOccurrences(of: pattern, with: "", options: .regularExpression)
        }

        // Paired tags — keep inner content, strip tags
        // Using [\\s\\S]*? instead of .*? to match across newlines
        let keepContent: [(String, String)] = [
            ("b", "b"), ("i", "i"), ("s", "s"), ("u", "u"),
            ("em", "em"), ("strong", "strong"),
            ("center", "center"), ("right", "right"), ("left", "left"),
        ]
        for (open, close) in keepContent {
            s = s.replacingOccurrences(of: "\\[\(open)\\]([\\s\\S]*?)\\[/\(close)\\]", with: "$1", options: [.regularExpression, .caseInsensitive])
        }

        // Parametric paired tags — keep inner content
        let keepContentParam = ["size", "color", "font"]
        for tag in keepContentParam {
            s = s.replacingOccurrences(of: "\\[\(tag)=[^\\]]*\\]([\\s\\S]*?)\\[/\(tag)\\]", with: "$1", options: [.regularExpression, .caseInsensitive])
        }

        // [character=N]name[/character] → name
        s = s.replacingOccurrences(of: "\\[character=[0-9]+\\]([\\s\\S]*?)\\[/character\\]", with: "$1", options: .regularExpression)

        // [quote]...[/quote] and [quote=author]...[/quote] — keep content
        s = s.replacingOccurrences(of: "\\[quote[^\\]]*\\]([\\s\\S]*?)\\[/quote\\]", with: "$1", options: [.regularExpression, .caseInsensitive])

        // [offtopic]...[/offtopic] — keep content
        s = s.replacingOccurrences(of: "\\[offtopic\\]([\\s\\S]*?)\\[/offtopic\\]", with: "$1", options: [.regularExpression, .caseInsensitive])

        // Any remaining unknown [tag] or [/tag] — strip, but preserve tags parseCommentSegments needs
        // (youtube, img=, spoiler, url= must survive to be parsed as segments)
        s = s.replacingOccurrences(
            of: "\\[(?!/?youtube\\]|img=|/?spoiler|/?url[=\\]])/?[a-zA-Z][^\\]]{0,40}\\]",
            with: "",
            options: .regularExpression
        )

        // Collapse excess blank lines
        while s.contains("\n\n\n") {
            s = s.replacingOccurrences(of: "\n\n\n", with: "\n\n")
        }

        return s
    }
}
