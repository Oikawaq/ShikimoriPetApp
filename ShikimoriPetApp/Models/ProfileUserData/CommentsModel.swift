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
    var replyTo: String?

    enum CodingKeys: String, CodingKey {
        case id, userId, body, htmlBody, user
    }
}

struct UserCommentModel: Decodable{
    let id: Int
    let nickname: String
    let image: ImagesSize?
}
