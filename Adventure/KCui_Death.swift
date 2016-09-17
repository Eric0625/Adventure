//
//  KCui_Death.swift
//  Adventure
//
//  Created by 苑青 on 16/5/4.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KCui_Death: KHuman {
    required init(){
        super.init(name: "崔判官")
        title = KColors.HIW + "朱笔判官" + KColors.NOR
        describe = "崔判官原是阳世为官，因广积阴德，死后被封为阴间判官。"
        setLifePropertyMax(.Kee, amount: 600)
        receiveHeal(DamageType.Kee, healAmount: maxKee)
        setLifePropertyMax(.Sen, amount: 600)
        receiveHeal(DamageType.Sen, healAmount: maxSen)
        combatExp = 100000;
        setSkill(inType: .Unarmed, toLevel: 50)
        setSkill(inType: .Dodge, toLevel: 50)
        setSkill(inType: .Parry, toLevel: 50)
        let k = KSSword()
        k.level = 50
        addSkill(k)
        mapSkill(k, inType: .Sword)
        var i:KEquipment = KChouPao()
        i.moveTo(self)
        equip(i)
        i = KPanguanBi()
        i.moveTo(self)
        equip(i)
    }
    
    required init(k: KObject) {
        assert(k is KCui_Death)
        super.init(k: k)
    }
    
    override func clone() -> KObject {
        return KCui_Death(k: self)
    }
}