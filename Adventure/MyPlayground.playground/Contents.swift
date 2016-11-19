import Foundation
import UIKit

extension String {
        
        ///Eric: regular expression under default options
        public func regMatch(_ patter:String, range: NSRange) -> [NSTextCheckingResult] {
            do{
                let regex = try NSRegularExpression(pattern: patter, options: .dotMatchesLineSeparators)
                return regex.matches(in: self, options: .reportCompletion, range: range)
            }
            catch{
                print(error)
            }
            fatalError()
        }
    public subscript(integerRange: Range<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: integerRange.lowerBound)
        let end = characters.index(startIndex, offsetBy: integerRange.upperBound)
        let range = start..<end
        return self[range]
    }

    /// EZSE: Cut string from integerIndex to the end
    public subscript(integerIndex: Int) -> Character {
        let index = characters.index(startIndex, offsetBy: integerIndex)
        return self[index]
    }
}

let str = "<color chatColor>s"
let ranges = str.regMatch("^<color (\\w*)>$", range: NSMakeRange(0, str.characters.count))

print(ranges.count)
for range in ranges {
    let r = range.rangeAt(1).toRange()!
    print(r)
    print(str[r])
}

class TClass {
    var desc = "test"
    required init(){
        
    }
}
let someType = TClass.self
let sobject = someType.init()
//let emptyString = someType.init()
print(sobject.desc)
print(someType.self)
