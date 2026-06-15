//
//  BBcodeExt.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 5/24/26.
//

import Foundation
import UIKit

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
