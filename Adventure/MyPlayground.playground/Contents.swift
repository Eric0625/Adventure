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

var s = "100.020000"
let range = s.regMatch("\\.*(0+)$", range: NSMakeRange(0, s.length))
if range.isEmpty == false {
print(range[0].rangeAtIndex(1))
let start = range[0].range.location
let end = start + range[0].range.length
let ss = s[0..<start]
print(ss)

    //let p = s.replaceRange(range[0].rangeAtIndex(1), with: "")
}