import Foundation

class MyClass {
    var member = 10
    
    required init(v: Int) {
        member = v
        print("init")
    }
    
    func xprint(){
        print(member)
    }
    
    func Clone()-> MyClass{
        let object = MyClass(v: member)
        return object
    }
}

class SecondClass: MyClass{
    override func xprint() {
        print(member2)
    }
    var member2 = 100
    required init(v: Int) {
        print("init second")
        super.init(v: v)
        member2 = v
    }
    
    override func Clone() -> MyClass {
        let object = SecondClass(v: member)
        object.member2 = member2 + 1
        return object
    }
}

//
//let v = NSStringFromClass(SecondClass)
//let s = "__lldb_expr_17.SecondClass"
//let q = NSClassFromString(v) as! MyClass.Type
//let object = q!.init(v: 17)
//let o2 = object.Clone()
////q?.self.xprint()
//o2.xprint()
//print(o2.member)
let x = SecondClass(v: 19)
let m = Mirror(reflecting: x)
let s = (m.subjectType as! MyClass.Type)
let u = s.init(v: 5)
let g = s.init(v: 89)
u.xprint()
print (u.member)
g.xprint()
var message = "<span class=hig>$D脸现痛苦之色，显然是毒药发作了！<br></span>"
message = message.stringByReplacingOccurrencesOfString("$D", withString: "李白")
print(message)
