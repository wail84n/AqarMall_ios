//
//  printAdvRecord.swift
//  AqarMall
//
//  Created by Macbookpro on 6/28/19.
//  Copyright © 2019 Macbookpro. All rights reserved.
//

import UIKit

struct printAdvRecord {
    var imageBG_image : String? = ""
    var imageBG_x : CGFloat? = 0
    var imageBG_y : CGFloat? = 0
    var imageBG_width : CGFloat? = 0
    var imageBG_height : CGFloat? = 0
    
    var title_fontSize : CGFloat? = 0
    var titleColor : UIColor? = .clear
    var title_x : CGFloat? = 0
    var title_y : CGFloat? = 0
    var title_width : CGFloat? = 0
    var title_height : CGFloat? = 0
    
    var text_fontSize : CGFloat? = 0
    var textColor : UIColor? = .clear
    var text_x : CGFloat? = 0
    var text_y : CGFloat? = 0
    var text_width : CGFloat? = 0
    var text_height : CGFloat? = 0
    
    var phone_fontSize : CGFloat? = 0
    var phoneColor : UIColor? = .clear
    var phone_x : CGFloat? = 0
    var phone_y : CGFloat? = 0
    var phone_width : CGFloat? = 0
    var phone_height : CGFloat? = 0
    
    var dictionary32: [String: Any]? = [:]
    
    init() {
    
    }
    
    public init?(object: AnyObject?) {
        guard
            let _object = object,
            let _imageBG_image = _object["imageBG_image"] as? String,
            let _imageBG_x = _object["imageBG_x"] as? CGFloat,
            let _imageBG_y = _object["imageBG_y"] as? CGFloat,
            let _imageBG_width = _object["imageBG_width"] as? CGFloat,
            let _imageBG_height = _object["imageBG_height"] as? CGFloat,
            let _title_fontSize = _object["title_fontSize"] as? CGFloat,
            let _titleColor = _object["titleColor"] as? String,
            let _title_x = _object["title_x"] as? CGFloat,
            let _title_y = _object["title_y"] as? CGFloat,
            let _title_width = _object["title_width"] as? CGFloat,
            let _title_height = _object["title_height"] as? CGFloat,
            let _text_fontSize = _object["text_fontSize"] as? CGFloat,
            let _textColor = _object["textColor"] as? String,
            let _text_x = _object["text_x"] as? CGFloat,
            let _text_y = _object["text_y"] as? CGFloat,
            let _text_width = _object["text_width"] as? CGFloat,
            let _text_height = _object["text_height"] as? CGFloat,
            let _phone_fontSize = _object["phone_fontSize"] as? CGFloat,
            let _phoneColor = _object["phoneColor"] as? String,
            let _phone_x = _object["phone_x"] as? CGFloat,
            let _phone_y = _object["phone_y"] as? CGFloat,
            let _phone_width = _object["phone_width"] as? CGFloat,
            let _phone_height = _object["phone_height"] as? CGFloat
            else{
                return nil
        }
        self.imageBG_image = _imageBG_image
        self.imageBG_x = _imageBG_x
        self.imageBG_y = _imageBG_y
        self.imageBG_width = _imageBG_width
        self.imageBG_height = _imageBG_height

        self.title_fontSize = _title_fontSize
        self.titleColor = _titleColor.color
        self.title_x = _title_x
        self.title_y = _title_y
        self.title_width = _title_width
        self.title_height = _title_height
        
        self.text_fontSize = _text_fontSize
        self.textColor = _textColor.color
        self.text_x = _text_x
        self.text_y = _text_y
        self.text_width = _text_width
        self.text_height = _text_height
        
        self.phone_fontSize = _phone_fontSize
        self.phoneColor = _phoneColor.color
        self.phone_x = _phone_x
        self.phone_y = _phone_y
        self.phone_width = _phone_width
        self.phone_height = _phone_height
    }
    
    var dictionary: [String: Any] {
        return ["imageBG_image": imageBG_image ?? "",
                "imageBG_x": imageBG_x ?? 0,
                "imageBG_y": imageBG_y ?? 0,
                "imageBG_width": imageBG_width ?? 0,
                "imageBG_height": imageBG_height ?? 0,
                "title_fontSize": title_fontSize ?? 0,
                "titleColor": titleColor?.toHexString() ?? "",
                "title_x": title_x ?? 0,
                "title_y": title_y ?? 0,
                "title_width": title_width ?? 0,
                "title_height": title_height ?? 0,
                
                "phone_fontSize": phone_fontSize ?? 0,
                "phoneColor": phoneColor?.toHexString() ?? "",
                "phone_x": phone_x ?? 0,
                "phone_y": phone_y ?? 0,
                "phone_width": phone_width ?? 0,
                "phone_height": phone_height ?? 0,
                
                "text_fontSize": text_fontSize ?? 0,
                "textColor": textColor?.toHexString() ?? "",
                "text_x": text_x ?? 0,
                "text_y": text_y ?? 0,
                "text_width": text_width ?? 0,
                "text_height": text_height ?? 0]
    }
    
    var nsDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
}


extension UIColor {
    //Convert RGBA String to UIColor object
    //"rgbaString" must be separated by space "0.5 0.6 0.7 1.0" 50% of Red 60% of Green 70% of Blue Alpha 100%
    public convenience init?(rgbaString : String){
        self.init(ciColor: CIColor(string: rgbaString))
    }
    
    //Convert UIColor to RGBA String
    func toRGBAString()-> String {
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return "\(r) \(g) \(b) \(a)"
        
    }
    //return UIColor from Hexadecimal Color string
    public convenience init?(hexaDecimalString: String) {
        
        let r, g, b, a: CGFloat
        
        if hexaDecimalString.hasPrefix("#") {
            let start = hexaDecimalString.index(hexaDecimalString.startIndex, offsetBy: 1)
            let hexColor = hexaDecimalString.substring(from: start)
            
            if hexColor.characters.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    // Convert UIColor to Hexadecimal String
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xff),
            Int(g * 0xff),
            Int(b * 0xff)
        )
    }
}

extension String
{
    var color: UIColor {
        let hex = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return UIColor.clear
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
}
