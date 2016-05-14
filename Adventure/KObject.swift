//
//  KObject.swift
//  Adventure
//
//  Created by 苑青 on 16/4/24.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KObject: Hashable {
    var name:String
    var describe = ""
    var guid = TheWorld.newGuid()
    
    var hashValue: Int { return Int(self.guid) }

    required init(k: KObject){
        guid = TheWorld.newGuid()
        name = k.name
        describe = k.describe
    }
    
    init(name:String){
        self.name = name        
    }
    
    func clone() -> KObject{
        let ob = KObject(k: self)
        return ob
    }
}


func == (lhs: KObject, rhs: KObject) -> Bool {
    return lhs.hashValue == rhs.hashValue
}