//
//  KVoidRoom.swift
//  Adventure
//
//  Created by Eric on 16/11/7.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KVoidRoom: KEntity {
    required init(){
        super.init(name: KColors.HIW + "扭曲虚空" + KColors.NOR)
        describe = "这里什么也没有。\n";
        selfCapacity = Int.max
    }
    
    required init(k: KObject) {
        assert(k is KVoidRoom)
        super.init(k: k)
    }
    
    ///容量无限大
    override func accept(_ ent: KEntity) -> Bool {
        usedCapacity = 0
        let result = super.accept(ent)
        return result
    }
}
