//
//  KStick.swift
//  Adventure
//
//  Created by 苑青 on 16/5/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KLongStick: KWeapon {
    
    required init(){
        super.init(name: "长棒")
        damage = 15
        describe = "一根普普通通的长棒。\n"
        equipType = EquipType.TwoHandedWeapon
        skillType = SkillType.Stick
        defaultActions = [ KSkillAction(describe: "$A挥舞$W，往$D的$l用力一砸。\n", actionTypeOfDamage: DamageActionType.Za),
                           KSkillAction(describe: "$A高高举起$W，往$D的$l当头砸下。\n", actionTypeOfDamage: DamageActionType.Za),
                           KSkillAction(describe: "$A手握$W，眼露凶光，猛地对准$D的$l挥了过去。\n", actionTypeOfDamage: DamageActionType.Yu)]
    }
    
    required init(k: KObject) {
        guard k is KLongStick else {
            fatalError("Cloning KLongStick with unkown object")
        }
        super.init(k: k)
    }
    
    override func clone() -> KObject {
        return KLongStick(k: self)
    }
}