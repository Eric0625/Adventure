//
//  KObject.swift
//  Adventure
//
//  Created by 苑青 on 16/4/24.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KObject: Hashable {
    var name:String {
        set { neatName = newValue }
        get { return neatName }
    }
    private var neatName:String
    var describe = ""
    var guid = TheWorld.newGuid()
    
    var hashValue: Int { return Int(self.guid) }

    required init(k: KObject){
        guid = TheWorld.newGuid()
        describe = k.describe
        neatName = k.neatName
    }
    
    init(name:String){
        neatName = name
    }
    
    func clone() -> KObject{
        let ob = KObject(k: self)
        return ob
    }
    
    ///返回纯名称，用于对比
    final func getNeatName() -> String { return neatName }
}


func == (lhs: KObject, rhs: KObject) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
