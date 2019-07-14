//
//  UIFontUtils.swift
//  AnalogClock
//
//  Created by Andrii on 7/14/19.
//  Copyright © 2019 Andrii. All rights reserved.
//

import UIKit

extension UIFont {
    func sizeOf(string: String) -> CGSize {
        return NSString(string: string).boundingRect(with: CGSize(width: Double.greatestFiniteMagnitude, height: Double.greatestFiniteMagnitude),
                                                     options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                     attributes: [NSAttributedString.Key.font: self],
                                                             context: nil).size
    }
}
