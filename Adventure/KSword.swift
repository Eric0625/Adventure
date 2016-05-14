//
//  KSword.swift
//  Adventure
//
//  Created by 苑青 on 16/5/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KSword: KWeapon{
    
    required init(){
        super.init(name: "剑")
        damage = 5
        describe = "一柄普普通通的剑。\n"
        skillType = SkillType.Sword
        defaultActions = [KSkillAction(describe: "$A挥动$W，斩向$D的$l\n", actionTypeOfDamage: DamageActionType.Ge, requiredLevel: 0, dodge: 1, parry: 1.2),
                          KSkillAction(describe: "$A用$W往$D的$l砍去\n", actionTypeOfDamage: DamageActionType.Pi, requiredLevel: 0, dodge: 1.2, parry: 1),
                          KSkillAction(describe: "$A用$W往$D的$l刺去\n", actionTypeOfDamage: DamageActionType.Ci, requiredLevel: 0, dodge: 1.15, parry: 0.85),
                          KSkillAction(describe: "$A的$W往$D的$l狠狠地一捅\n", actionTypeOfDamage: DamageActionType.Ci, requiredLevel: 0, dodge: 0.7, parry: 0.7)]
        equipMessage = "$A唰地一声，抽出一柄$W。\n"
        unequipMessage = "$A将$W插回腰间。\n"
    }
    
    required init(k: KObject) {
        guard k is KSword else {
            fatalError("Cloning KSword with unkown object")
        }
        super.init(k: k)
    }
    
    override func clone() -> KObject {
        return KSword(k: self)
    }
}