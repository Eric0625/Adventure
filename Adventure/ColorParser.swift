//
//  ColorParser.swift
//  Adventure
//
//  Created by 苑青 on 16/5/20.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation
import UIKit

struct ColorParser {
    struct ColorAttribute{
        let range:NSRange
        let color:UIColor
    }
    
    fileprivate(set) var attributes = [ColorAttribute]()
    
    fileprivate mutating func addAttribute(_ colorString:String, range:NSRange) {
        attributes.append(ColorParser.ColorAttribute(range: range, color: KColors.toUIColor(input: colorString)!))
    }
    
    fileprivate func findStartPos(_ str:String, startFindPos: Int) -> Int {
        let startPattern = "^.*?(<color (\\w+)>)"
        let res = str.regMatch(startPattern, range: NSMakeRange(startFindPos, str.length - startFindPos))
        if res.count > 0 {
            return res[0].rangeAt(1).location
        }
        else {return Int.max}
    }
    
    fileprivate func findEndPos(_ str:String, startFindPos: Int) -> Int {
        let startPattern = "^.*?(</color>)"
        let res = str.regMatch(startPattern, range: NSMakeRange(startFindPos, str.length - startFindPos))
        if res.count > 0 {
            return res[0].rangeAt(1).location
        }
        else {return Int.max}
    }
    
    mutating func parseColor(_ str: String, from: Int) {
        if from >= str.length {return}
        let startPattern = "^.*?<color (\\w+)>{1}"
        let res = str.regMatch(startPattern, range: NSMakeRange(from, str.length - from))
        var colorStart = 0
        if res.count > 0 {
            colorStart += 1
            //第一个color
            let checkResult = res[0]
            let color = str[checkResult.rangeAt(1).toRange()!]
            let start = checkResult.range.location + checkResult.range.length
            //寻找<color>或</color>
            var startPos = start
            var endPos = start
            repeat{
                let newStartPos = findStartPos(str, startFindPos: startPos)
                endPos = findEndPos(str, startFindPos: startPos)
                if(endPos == Int.max) {return}
                if newStartPos < endPos {
                    colorStart += 1
                } else { colorStart -= 1 }
                startPos = min(endPos, newStartPos) &+ 7
                if startPos >= str.length { break }
            }while(colorStart > 0)
            if(endPos == Int.max) { return }
            addAttribute(color, range: NSMakeRange(start, endPos - start))
            parseColor(str, from: start)
        }
    }
}
