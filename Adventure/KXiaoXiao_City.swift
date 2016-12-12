//
//  KXiaoXiao_City.swift
//  Adventure
//
//  Created by 苑青 on 16/5/2.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KXiaoXiao_City: KSalesMan {
    required init(){
        super.init(name: "萧萧")
        title = "恶娘子"
        describe = "老英雄萧振远的小女儿，兵器铺女老板。由于凶蛮狠毒，江湖人称＂恶娘子＂。\n"
        per = 14 + randomInt(9)
        combatExp = 10;
        var skill:KSkill = KSParry(level: 50)
        addSkill(skill)
        mapSkill(skill, inType: .parry)
        skill = KSUnarmed(level: 50)
        addSkill(skill)
        mapSkill(skill, inType: .unarmed)
        skill = KSMoonDance(level: 50)
        addSkill(skill)
        mapSkill(skill, inType: .dodge)
        skill = KSFengshanSword(level: 50)
        addSkill(skill)
        mapSkill(skill, inType: .sword)
        addGoods(KQiMeiGun())
        gender = .女性
        age = 26
    }
    
    required init(k: KObject) {
        assert(k is KXiaoXiao_City)
        super.init(k: k)
    }
    
    override func clone() -> KObject {
        return KXiaoXiao_City(k: self)
    }
    
    override func readyEquips() {
        var e:KEquipment = KSteelSword()
        e.moveTo(self)
        assert(equip(e))
        e = KPinkCloth()
        e.moveTo(self)
        assert(equip(e))
    }
}
