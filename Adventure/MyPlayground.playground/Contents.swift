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
            let regex = try NSRegularExpression(pattern: patter, options: .CaseInsensitive)
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

struct colorAttribute{
    let range:Range<Int>
    let color:String
}
var attributes = [colorAttribute]()

private func addAttribute(color:String, range:Range<Int>) {
    
    attributes.append(colorAttribute(range: range, color: color))
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

private func check(str: String, from: Int) {
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
            //print(newStartPos, endPos)
            if newStartPos < endPos {
                colorStart += 1
            } else { colorStart -= 1 }
            startPos = min(endPos, newStartPos) + 7
        }while(colorStart > 0)
        addAttribute(color, range: start..<endPos)
        //print( str[(endPos + 8)..<str.length])
        check(str, from: start)
    }
}
let s = "vvv<color yure>yuecolor</color>normal color<color red>red color<color rtty>rtt<color green>a green color</color> color</color>red <color blue>a blue color</color>end of red</color>ff<color white>white color</color>endf"
let p = "fdfs<color red>fd</color>dsfsvvv<color yure>yuecolor</color>"
let test = s
check(test, from: 0)
for r in attributes {
    print("color is \(r.color)." + " content is: " + test[r.range])
}
//print(message)
//private func check(str: String) {
//    // 使用正则表达式一定要加try语句
//    do {
//        // - 1、创建规则
//        //let pattern = "[1-9][0-9]{4,14}"
//        let pattern = "<color (\\w+)>(.*?)</color>"
//        // - 2、创建正则表达式对象)
//        // - 3、开始匹配
//        let res = str.regMatch(pattern, range: NSMakeRange(0, str.characters.count))
////        // 输出结
////        for checkingRes in res {
////            let color = str[checkingRes.rangeAtIndex(1).toRange()!]
////            print("color is \(color)")
////            //let tailPattern = "^(.*?)(</color>){1}"
////            let colorPattern = "<color \\w+>"
////            let colorRes = str.regMatch(colorPattern, range: checkingRes.rangeAtIndex(2))
////            if colorRes.count > 0 {
////                print(colorRes.count, str[colorRes[0].range.toRange()!])
////                let tailPattern = "(.*?</color>){\(1 + colorRes.count)}"
////                let start = checkingRes.rangeAtIndex(2).location
////                let range = NSMakeRange(start, str.characters.count - start)
////                print("rescan: " + str[range.toRange()!])
////                let tailRes = str.regMatch(tailPattern, range: range)
////                if tailRes.count > 0 {
////                    let subStr = str[tailRes[0].range.toRange()!]
////                    print("content is:\n\t \(subStr)")
////                    //获取子字符串中的颜色
////                    check(subStr)
////                }
////            } else {
////                print("content is:\n\t " + str[checkingRes.rangeAtIndex(2).toRange()!])
////                attributes.append(colorAttribute(range: checkingRes.rangeAtIndex(2), color: color))
////            }
//        }
//    }
//    catch {
//        print(error)
//    }
//}
