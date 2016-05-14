//
//  KCondition.swift
//  Adventure
//
//  Created by 苑青 on 16/4/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

/// 各种buff和debuff
class KCondition:KObject
{
    init(name: String, duration: Int){
        super.init(name: name)
        self.duration = duration
    }
    
    required init(k: KObject) {
        guard let cond = k as? KCondition else {
            fatalError("Init KCondition with unkown object")
        }
        duration = cond.duration
        owner = cond.owner
        generator = cond.generator
        super.init(k: k)
    }
  
    override func clone() -> KObject{
        return  KCondition(k: self)
    }
    
    var duration = 0
    weak var owner: KCreature? //状态的宿主
    weak var generator: KObject?//状态的施加者，有可能不是实体，比如技能等
    
    func tickle() { }
    func afterAppliedToOwner() { }
}