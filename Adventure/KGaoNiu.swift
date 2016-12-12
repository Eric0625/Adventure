//
//  KGaoNiu.swift
//  Adventure
//
//  Created by 苑青 on 2016/11/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KGaoNiu: KBeastWithPalm {
    required init(){
        super.init(name: "老牛")
        combatExp = 100
        str = 26
        cor = 27
        armor = 29
        describe = "一头老牛。"
    }
    
    required init(k: KObject) {
        guard k is KGaoNiu else {
            fatalError("Init KGaoNiu with unkown object")
        }
        super.init(k: k)
    }
    
    override func clone() -> KObject {
        return KBeastWithPalm(k: self)
    }
}
