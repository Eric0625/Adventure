//
//  KColors.swift
//  Adventure
//
//  Created by 苑青 on 16/4/24.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

struct KColors {
    static let Red = "<color red>"
    static let  GRN = "<color green>"
    static let  HIG = "<color hiGreen>"
    static let  CYN = "<color cyan>"
    static let  nor = "<color green>"
    static let  NOR = "</color>"
    static let  HIY = "<color hiYellow>"
    static let  HIR = "<color hiRed>"
    static let  HIW = "<color hiWhite>"
    static let  White = "<color white>"
    static let  Purple = "<color purple>"
    static let  ChatMsg = "<color chatColor>"
    static let  HIC = "<color hiCyan>"
    static let  BLU = "<color blue>"
    static let  HIB = "<color hiBlue>"
    static let  YEL = "<color yellow>"
    static let  HIP = "<color hiPurple>"
    static let  PINK = "<color pink>"
    static let colorDictionary = [
        "red": UIColor(r: 132, g: 0, b: 2),
        "green": UIColor(r: 0, g: 119, b: 4),
        "hiGreen": UIColor(r: 3, g: 202, b: 46),
        "cyan": UIColor(r: 0, g: 255, b: 255),
        "hiYellow": UIColor(r: 255, g: 255, b: 20),
        "hiRed": UIColor(r: 255, g: 0, b: 8),
        "hiWhite": UIColor(r: 255, g: 255, b: 255),
        "white": UIColor(r: 243, g: 243, b: 243),
        "purple": UIColor(r: 120, g: 0, b: 116),
        "chatColor": UIColor(r: 106, g: 125, b: 142),
        "hiCyan": UIColor(r: 0, g: 171, b: 160),
        "blue": UIColor(r: 0, g: 0, b: 198),
        "hiBlue": UIColor(r: 0, g: 0, b: 239),
        "yellow": UIColor(r: 117, g: 117, b: 6),
        "hiPurple": UIColor(r: 255, g: 0, b: 254),
        "pink": UIColor(r: 255, g: 182, b: 196)
    ]
    
    static func red(str: String) -> NSAttributedString {
        return str.color(colorDictionary["red"]!)
    }
    
    static func green(str: String) -> NSAttributedString {
        return str.color(UIColor(r: 0, g: 119, b: 4))
    }
    
    static func hiGreen(str: String) -> NSAttributedString {
        return str.color(UIColor(r: 3, g: 202, b: 46))
    }
    
    static func cyan(str: String) -> NSAttributedString {
        return str.color(UIColor(r: 0, g: 255, b: 255))
    }
    
    static func normal(str: String) -> NSAttributedString {
        return KColors.green(str)
    }
    
    static func hiYellow(str: String) -> NSAttributedString {
        return str.color(UIColor(r: 255, g: 255, b: 20))
    }
 
    static func hiRed(str: String) -> NSAttributedString {
        return str.color(UIColor(r: 255, g: 0, b: 8))
    }
    
    static func hiWhite(str: String) -> NSAttributedString {
        return str.color(UIColor(r: 255, g: 255, b: 255))
    }
    
    static func white(str: String) -> NSAttributedString {
        return str.color(UIColor(r: 243, g: 243, b: 243))
    }
    
    static func purple(str: String) -> NSAttributedString {
        return str.color(UIColor(r: 120, g: 0, b: 116))
    }
    
    static func chatColor(str: String) -> NSAttributedString {
        return str.color(UIColor(r: 106, g: 125, b: 142))
    }
    
    static func hiCyan(str: String) -> NSAttributedString {
        return str.color(UIColor(r: 0, g: 171, b: 160))
    }
    
    static func blue(str: String) -> NSAttributedString {
        return str.color(UIColor(r: 0, g: 0, b: 198))
    }
    
    static func hiBlue(str: String) -> NSAttributedString {
        return str.color(UIColor(r: 0, g: 0, b: 239))
    }
    
    static func yellow(str: String) -> NSAttributedString {
        return str.color(UIColor(r: 117, g: 117, b: 6))
    }
    
    static func hiPurple(str: String) -> NSAttributedString {
        return str.color(UIColor(r: 255, g: 0, b: 254))
    }
    
    static func pink(str: String) -> NSAttributedString {
        return str.color(UIColor(r: 255, g: 182, b: 196))
    }
    
}