import Foundation
import UIKit

extension String {
    /// EZSE: Cut string from integerIndex to the end
    public subscript(integerIndex: Int) -> Character {
        let index = startIndex.advancedBy(integerIndex)
        return self[index]
    }
    
    /// EZSE: Cut string from range
    public subscript(integerRange: Range<Int>) -> String {
        let start = startIndex.advancedBy(integerRange.startIndex)
        let end = startIndex.advancedBy(integerRange.endIndex)
        let range = start..<end
        return self[range]
    }
    
    public func regMatch(patter:String, range: NSRange) -> [NSTextCheckingResult] {
        do{
            let regex = try NSRegularExpression(pattern: patter, options: .DotMatchesLineSeparators)
            return regex.matchesInString(self, options: .ReportCompletion, range: range)
        }
        catch{
            print(error)
        }
        fatalError()
    }
    
    /// EZSE: Character count
    public var length: Int {
        return self.characters.count
    }

}
struct colorInfomation {
    struct colorAttribute{
        let range:Range<Int>
        let color:String
    }
    private(set) var attributes = [colorAttribute]()
    
    private mutating func addAttribute(color:String, range:Range<Int>) {
        
        attributes.append(colorInfomation.colorAttribute(range: range, color: color))
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
                print(newStartPos, endPos)
                if newStartPos < endPos {
                    colorStart += 1
                } else { colorStart -= 1 }
                startPos = min(endPos, newStartPos) &+ 5
                //print(startPos)
                if startPos >= str.length { break }
            }while(colorStart > 0)
            if(endPos == Int.max) { return }
            addAttribute(color, range: start..<endPos)
            //print( str[(endPos + 8)..<str.length])
            parseColor(str, from: start)
        }
    }
}

var info = colorInfomation()

let s = "vvv<color yure>yuecolor</color>normal color<color red>red color<color rtty>rtt<color green>a green color</color> color</color>red <color blue>a blue color</color>end of red</color>ff<color white>white color</color>endf"
let p = "10:34 PM 你挥拳攻击李白的右肩。\n李白一闪，躲开了你的攻击\r\r\n<color white>你一击不中，露出了破绽！\n</color>李白用判官笔往你的左脚刺去\n结果「噗」地一声刺入了你的左脚寸许！\n<color hiYellow>（你动作似乎开始有点不太灵光，但是仍然有条不紊。）\n</color>\n"
print(p)
let test = p
info.parseColor(test, from: 0)
for r in info.attributes {
    print("color is \(r.color)." + " content is: " + test[r.range])
}