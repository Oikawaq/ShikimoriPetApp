//
//  CommentsModel.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/8/26.
//

import Foundation

struct CommentsModel: Decodable {
    let id: Int
    let userId: Int
    var body: String
    var htmlBody: String
    let user: UserCommentModel
    var image: String?
    var replyTo: String?
}

struct UserCommentModel: Decodable{
    let id: Int
    let nickname: String
    let image: ImagesSize?
}
