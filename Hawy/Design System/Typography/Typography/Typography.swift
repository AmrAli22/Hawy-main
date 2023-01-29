//
//  Typography.swift
//  NomadStoryTask
//
//  Created by Ahmed on 6/17/22.
//

import Foundation
import UIKit

extension DesignSystem {
    
    enum Typography {
        
        case headline
        case bigButton
        
        private var fontDescriptor: CustomFontDiscriptor {
            
            switch self {
            
            case .headline:
                return CustomFontDiscriptor(font: .almaraiBold, size: 20, style: .headline)
            case .bigButton:
                return CustomFontDiscriptor(font: .poppinsMedium, size: 17, style: .callout)
                
            }
            
        }
        var font: UIFont {
            
            guard let font = UIFont(name: fontDescriptor.font.name, size: fontDescriptor.size) else {
                return UIFont.preferredFont(forTextStyle: fontDescriptor.style)
            }
            
            let fontMetrics = UIFontMetrics(forTextStyle: fontDescriptor.style)
            return fontMetrics.scaledFont(for: font)
            
        }
        
    }
    
}
