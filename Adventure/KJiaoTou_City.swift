//
//  KJiaoTou.swift
//  Adventure
//
//  Created by 苑青 on 16/5/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KJiaoTou_City: KHuman {
    required init(){
        super.init(name: "范卢平")
        title = "武馆教头"
        describe = "一个精精瘦瘦的小个子，在练一套拳。"
        combatExp = 20000
        lifePropertyMax[.Force] = 200
        lifeProperty[.Force] = 200
        mapSkill(KSUnarmed(level: 30), inType: .Unarmed)
        setSkill(KSDodge.NAME, toLevel: 30)
        setSkill(KSParry.NAME, toLevel: 30)
        age = 39
        readyEquips()
    }
    
    required init(k: KObject) {
        assert(k is KJiaoTou_City)
        super.init(k: k)
    }
    
    override func clone() -> KObject {
        return KJiaoTou_City(k: self)
    }
    
    func readyEquips() {
        let c = KCloth()
        c.moveTo(self)
        equip(c)
    }
    
    override func reborn() {
        super.reborn()
        readyEquips()
    }
}