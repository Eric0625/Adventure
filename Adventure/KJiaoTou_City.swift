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
        //combatExp = 20000
        setLifePropertyMax(.force, amount: 200)
        setLifeProperty(.force, amount: 200)
        mapSkill(KSUnarmed(level: 30), inType: .unarmed)
        setSkill(KSDodge.NAME, toLevel: 30)
        setSkill(KSParry.NAME, toLevel: 30)
        age = 39
    }
    
    required init(k: KObject) {
        assert(k is KJiaoTou_City)
        super.init(k: k)
    }
    
    override func clone() -> KObject {
        return KJiaoTou_City(k: self)
    }
    
    override func readyEquips() {
        let c = KCloth()
        assert(c.moveTo(self))
        assert(equip(c))
    }
}
