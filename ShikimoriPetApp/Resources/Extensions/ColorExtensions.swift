//
//  ColorExtensions.swift
//  ShikimoriPetApp
//
//  Created by Иван Илькив on 2/5/26.
//

import UIKit

extension UIColor {

    static let grayDef = UIColor(red: 0.08, green: 0.08, blue: 0.08, alpha: 1)
    static let chalkWhite = UIColor(hex: "#F2F3EF")
    static let basalt = UIColor(hex: "#2B3038")
    static let skeletonColor = UIColor(ciColor: CIColor(color: UIColor.gray.withAlphaComponent(0.4)))
    convenience init(hex: String) {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            if hexSanitized.hasPrefix("#") {
                hexSanitized.remove(at: hexSanitized.startIndex)
            }
            
            var rgb: UInt64 = 0
            Scanner(string: hexSanitized).scanHexInt64(&rgb)
            
            let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(rgb & 0x0000FF) / 255.0
            
            self.init(red: r, green: g, blue: b, alpha: 1.0)
        }
    static let background = UIColor{trait in
        return trait.userInterfaceStyle == .dark ? .black : UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
    }
    static let bubbleBackground = UIColor { trait in
            return trait.userInterfaceStyle == .dark ? UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1.0) : .white
        }

        static let mainText = UIColor { trait in
            return trait.userInterfaceStyle == .dark ? .white : .black
        }
}
