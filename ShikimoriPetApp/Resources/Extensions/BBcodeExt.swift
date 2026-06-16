//
//  BBcodeExt.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/24/26.
//

import Foundation
import UIKit

enum CommentSegment {
    case text(String)
    case spoiler(title: String, body: String)
    case youtube(videoId: String)
    case image(url: String)
}

extension String {
    // Extracts YouTube video ID from youtu.be or youtube.com URLs
    private func youtubeVideoId(from urlString: String) -> String? {
        // youtu.be/VIDEO_ID
        if let range = urlString.range(of: "youtu\\.be/([a-zA-Z0-9_-]+)", options: .regularExpression),
           let idRange = urlString.range(of: "[a-zA-Z0-9_-]+$", options: .regularExpression, range: range) {
            return String(urlString[idRange])
        }
        // youtube.com/watch?v=VIDEO_ID
        if let range = urlString.range(of: "[?&]v=([a-zA-Z0-9_-]+)", options: .regularExpression) {
            let sub = String(urlString[range]).dropFirst(3) // drop "?v=" or "&v="
            let id = String(sub.prefix(while: { $0.isLetter || $0.isNumber || $0 == "_" || $0 == "-" }))
            return id.isEmpty ? nil : id
        }
        return nil
    }

    func parseCommentSegments() -> [CommentSegment] {
        // Groups: 1,2=spoiler | 3=[youtube] | 4=[url=] href | 5=[url] text | 6=[img=URL]
        let pattern = "\\[spoiler=([^\\]]*)\\](.*?)\\[/spoiler\\]"
            + "|\\[youtube\\]([a-zA-Z0-9_-]+)\\[/youtube\\]"
            + "|\\[url=([^\\]]+)\\](.*?)\\[/url\\]"
            + "|\\[img=([^\\]]+)\\]"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators) else {
            return [.text(self)]
        }
        var segments: [CommentSegment] = []
        let nsString = self as NSString
        let fullRange = NSRange(location: 0, length: nsString.length)
        let matches = regex.matches(in: self, range: fullRange)
        var cursor = 0
        for match in matches {
            let matchRange = match.range
            if matchRange.location > cursor {
                let textRange = NSRange(location: cursor, length: matchRange.location - cursor)
                let text = nsString.substring(with: textRange).trimmingCharacters(in: .newlines)
                if !text.isEmpty { segments.append(.text(text)) }
            }
            if match.range(at: 6).location != NSNotFound {
                // [img=URL]
                let url = nsString.substring(with: match.range(at: 6))
                segments.append(.image(url: url))
            } else if match.range(at: 3).location != NSNotFound {
                // [youtube]VIDEO_ID[/youtube]
                let videoId = nsString.substring(with: match.range(at: 3))
                segments.append(.youtube(videoId: videoId))
            } else if match.range(at: 4).location != NSNotFound {
                // [url=HREF]text[/url]
                let href = nsString.substring(with: match.range(at: 4))
                let text = match.range(at: 5).location != NSNotFound
                    ? nsString.substring(with: match.range(at: 5))
                    : href
                if let videoId = youtubeVideoId(from: href) {
                    segments.append(.youtube(videoId: videoId))
                } else {
                    segments.append(.text(text))
                }
            } else {
                // spoiler
                let title = match.range(at: 1).location != NSNotFound
                    ? nsString.substring(with: match.range(at: 1))
                    : "Спойлер"
                let body = match.range(at: 2).location != NSNotFound
                    ? nsString.substring(with: match.range(at: 2))
                    : ""
                segments.append(.spoiler(title: title.isEmpty ? "Спойлер" : title, body: body))
            }
            cursor = matchRange.location + matchRange.length
        }
        if cursor < nsString.length {
            let remaining = nsString.substring(from: cursor).trimmingCharacters(in: .newlines)
            if !remaining.isEmpty { segments.append(.text(remaining)) }
        }
        if segments.isEmpty { segments.append(.text(self)) }
        return segments
    }
}

extension String{

    func parseBBCode() -> String {
           var result = self
           let characterPattern = "\\[character=\\d+\\](.+?)\\[/character\\]"
           result = result.replacingOccurrences(
               of: characterPattern,
               with: "$1",
               options: .regularExpression
           )
           let urlPattern = "\\[url=[^\\]]+\\](.+?)\\[/url\\]"
           result = result.replacingOccurrences(
               of: urlPattern,
               with: "$1",
               options: .regularExpression
           )
           return result
       }
    func parseDescriptionBBCode() -> NSAttributedString {
            let attributed = NSMutableAttributedString(string: self)
            
            let pattern = "\\[character=(\\d+)\\](.+?)\\[/character\\]"
            guard let regex = try? NSRegularExpression(pattern: pattern) else {
                return attributed
            }
            
            let range = NSRange(self.startIndex..., in: self)
            // Получаем все совпадения и обрабатываем в обратном порядке
            let matches = regex.matches(in: self, range: range).reversed()
            
            for match in matches {
                guard let idRange = Range(match.range(at: 1), in: self),
                      let nameRange = Range(match.range(at: 2), in: self) else { continue }
                
                let id = String(self[idRange])
                let name = String(self[nameRange])
                
                attributed.replaceCharacters(in: match.range, with: name)
                attributed.addAttribute(
                    .link,
                    value: "character://\(id)",
                    range: NSRange(location: match.range.location, length: name.count)
                )
            }
            
            return attributed
        }
    
}
