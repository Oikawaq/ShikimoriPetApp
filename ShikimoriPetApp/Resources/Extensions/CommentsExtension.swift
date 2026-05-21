//
//  CommentsExtension.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/18/26.
//


import Foundation

extension CommentsModel{
    mutating func filter(replacing: String,imageFilter: Bool = false){
        if imageFilter{
            self.body = self.body.replacingOccurrences(of: replacing, with: "")
        }else{
            self.body = self.body.replacingOccurrences(of: replacing, with: "",options: .regularExpression)
        }
        
        self.body = self.body.trimmingCharacters(in: .whitespacesAndNewlines)
      
    }
}
