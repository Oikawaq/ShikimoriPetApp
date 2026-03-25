//
//  StringExt.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/28/26.
//

import Foundation

extension String {
    func htmlStripped() -> String {
        // Регулярное выражение ищет всё, что внутри [ ]
        let pattern = "\\[.*?\\]"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return self
        }
        
        let range = NSRange(location: 0, length: self.utf16.count)
        // Заменяем найденные теги на пустую строку
        var cleanString = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "")
        
        // Дополнительно чистим переносы строк, если они приходят как \r\n
        cleanString = cleanString.replacingOccurrences(of: "\r", with: "")
        
        return cleanString.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
