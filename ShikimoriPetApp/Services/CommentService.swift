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
    func filter(unique: [CommentsModel])-> [CommentsModel]{
        return unique.map{ comment in
            var modified = comment
            if comment.htmlBody.contains("img src") || comment.body.contains("image="){
                if let range = modified.body.range(of: "(?<=image=)[0-9]+", options: .regularExpression){
                    let imageId = String(modified.body[range])
                    modified.filter(replacing: "[image=\(imageId)]", imageFilter: true)
                }
                
                let pattern = #"(?<=src=")[^"]+"#
                if let range = comment.htmlBody.range(of: pattern, options: .regularExpression){
                    let url = String(comment.htmlBody[range])
                    let changedUrl = url.replacingOccurrences(of: "thumbnail", with: "original")
                    modified.image = changedUrl
                }
            }
            if let range = modified.body.range(of: "(?<=comment=)[0-9]+", options: .regularExpression){
                let commentId = Int(modified.body[range])
                if let replyComment = unique.first(where: {$0.id == commentId}){
                    modified.replyTo = "@\(replyComment.user.nickname)"
                }
                modified.filter(replacing: "\\[comment=[0-9]+;[0-9]+\\]")
                modified.body = "\(modified.replyTo ?? "")\(modified.body)"
            }
            if comment.body.contains("replies="){
                modified.filter(replacing: "\\[replies=[0-9]+,[0-9]+\\]")
                modified.filter(replacing: "\\[replies=[0-9]+\\]")
               
            }
            return modified
        }
    }
}
