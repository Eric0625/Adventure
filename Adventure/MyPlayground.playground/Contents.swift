import Foundation
import UIKit

//extension String {
//        
//        ///Eric: regular expression under default options
//        public func regMatch(_ patter:String, range: NSRange) -> [NSTextCheckingResult] {
//            do{
//                let regex = try NSRegularExpression(pattern: patter, options: .dotMatchesLineSeparators)
//                return regex.matches(in: self, options: .reportCompletion, range: range)
//            }
//            catch{
//                print(error)
//            }
//            fatalError()
//        }
//    public subscript(integerRange: Range<Int>) -> String {
//        let start = characters.index(startIndex, offsetBy: integerRange.lowerBound)
//        let end = characters.index(startIndex, offsetBy: integerRange.upperBound)
//        let range = start..<end
//        return self[range]
//    }
//
//    /// EZSE: Cut string from integerIndex to the end
//    public subscript(integerIndex: Int) -> Character {
//        let index = characters.index(startIndex, offsetBy: integerIndex)
//        return self[index]
//    }
//}
//
//let str = "<color chatColor>s"
//let ranges = str.regMatch("^<color (\\w*)>$", range: NSMakeRange(0, str.characters.count))
//
//print(ranges.count)
//for range in ranges {
//    let r = range.rangeAt(1).toRange()!
//    print(r)
//    print(str[r])
//}
//
//class TClass {
//    var desc = "test"
//    required init(){
//        
//    }
//}
//let someType = TClass.self
//let sobject = someType.init()
////let emptyString = someType.init()
//print(sobject.desc)
//print(someType.self)
class Maze {
    var cells: [MazeCell]
    let width: Int
    let height: Int
    init(w:Int, h:Int) {
        cells = Array(repeating: MazeCell(), count: w * h)
        width = w
        height = h
        //开始生成迷宫
        generate(x: 0, y: 0)
    }
    func randomInt(_ upper:Int)->Int{
        assert(upper >= 0)
        return Int(arc4random_uniform(UInt32(upper)))
    }
    
    private func generate(x:Int, y:Int) {
        self[x, y].visited = true
        var next = randomInt(999999)
        for i in 0..<4 {
            next = (next + i) % 4
            //print("x is \(x), y is \(y), i is \(i), next is \(next % 4)")
            switch next {
            case 0://北面的墙
                if y - 1 < 0 { break }
                if self[x, y - 1].visited { break }
                self[x, y].top = false
                self[x, y - 1].bottom = false
                generate(x: x, y: y - 1)
            case 1://东面的墙
                if x + 1 >= width { break }
                if self[x + 1, y].visited { break }
                self[x, y].right = false
                self[x + 1, y].left = false
                generate(x: x + 1, y: y)
            case 2://south
                if y+1 >= height { break }
                if self[x, y + 1].visited { break }
                self[x, y].bottom = false
                self[x, y + 1].top = false
                generate(x: x, y: y + 1)
            case 3://west
                if x - 1 < 0 { break }
                if self[x - 1, y].visited { break }
                self[x, y].left = false
                self[x - 1, y].right = false
                generate(x: x - 1, y: y)
            default:
                break
            }
        }
    }
    
    subscript (x:Int, y:Int) -> MazeCell{
        get {
            assert(x < width && x >= 0)
            assert(y < height && y >= 0)
            return cells[y * width + x]
        }
        set {
            assert(x < width && x >= 0)
            assert(y < height && y >= 0)
            cells[y * width + x] = newValue
        }
    }
    
    func printall(){
        var i = 0
        cells.forEach(){
            print("\(i):\($0)\n")
            i += 1
        }
    }
}

///迷宫的一个房间
struct MazeCell {
    var visited = false
    var left = true
    var right = true
    var top = true
    var bottom = true
}

let m = Maze(w: 4, h: 4)
m.printall()