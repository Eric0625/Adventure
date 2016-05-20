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
    
    private(set) var attributes = [ColorAttribute]()
    
    private mutating func addAttribute(color:String, range:NSRange) {
        attributes.append(ColorParser.ColorAttribute(range: range, color: KColors.colorDictionary[color]!))
    }
    
    private func findStartPos(str:String, startFindPos: Int) -> Int {
        let startPattern = "^.*?(<color (\\w+)>)"
        let res = str.regMatch(startPattern, range: NSMakeRange(startFindPos, str.length - startFindPos))
        if res.count > 0 {
            return res[0].rangeAtIndex(1).location
        }
        else {return Int.max}
    }
    
    private func findEndPos(str:String, startFindPos: Int) -> Int {
        let startPattern = "^.*?(</color>)"
        let res = str.regMatch(startPattern, range: NSMakeRange(startFindPos, str.length - startFindPos))
        if res.count > 0 {
            return res[0].rangeAtIndex(1).location
        }
        else {return Int.max}
    }
    
    mutating func parseColor(str: String, from: Int) {
        if from >= str.length {return}
        let startPattern = "^.*?<color (\\w+)>{1}"
        //let endPattern = "^(.*?)</color>"
        let res = str.regMatch(startPattern, range: NSMakeRange(from, str.length - from))
        var colorStart = 0
        if res.count > 0 {
            colorStart += 1
            //第一个color
            let checkResult = res[0]
            let color = str[checkResult.rangeAtIndex(1).toRange()!]
            //print("color is \(color)")
            let start = checkResult.range.location + checkResult.range.length
            //寻找<color>或</color>
            var startPos = start
            var endPos = start
            repeat{
                let newStartPos = findStartPos(str, startFindPos: startPos)
                endPos = findEndPos(str, startFindPos: startPos)
                if(endPos == Int.max) {return}
                //print(newStartPos, endPos)
                if newStartPos < endPos {
                    colorStart += 1
                } else { colorStart -= 1 }
                startPos = min(endPos, newStartPos) &+ 7
                //print(startPos)
                if startPos >= str.length { break }
            }while(colorStart > 0)
            if(endPos == Int.max) { return }
            addAttribute(color, range: NSMakeRange(start, endPos - start))
            //print( str[(endPos + 8)..<str.length])
            parseColor(str, from: start)
        }
    }
}
