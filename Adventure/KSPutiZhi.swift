//
//  KSPutiZhi.swift
//  Adventure
//
//  Created by 苑青 on 16/5/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KSPutiZhi: KSUnarmed {
    
    override init(level: Int){
        super.init(level: level)
        name = NAME
        skillType = .unarmed
        actions = [KSkillAction(describe: "$A“呼”地一指点出，这一招由中宫直进，\n指未到，指风已把$D压得喘不过气来\n", actionTypeOfDamage: DamageActionType.ci, requiredLevel: 1, dodge: 0.95, parry: 0.95, damageFactor: 1.6),
                   KSkillAction(describe: "$A身形不动，右手作「佛祖拈花」状。$D稍一犹豫，$A的中指指节已敲向$D的$l\n",actionTypeOfDamage: DamageActionType.za, requiredLevel: 10, dodge: 1.1, parry: 0.9, damageFactor: 2.2),
                   KSkillAction(describe: "只见$A面带微笑，负手而立。但是$D觉得有一道指力直扑$l而来\n", actionTypeOfDamage: DamageActionType.nei, requiredLevel: 1, dodge: 1.15, parry: 0.95, damageFactor: 1.6),
                   KSkillAction(describe: "$A双掌一错，十指如穿花蝴蝶一般上下翻飞。$D只觉得全身都在$A指力笼罩之下\n", actionTypeOfDamage: DamageActionType.ci, requiredLevel: 1, dodge: 0.85, parry: 1.1, damageFactor: 1.6),
                   KSkillAction(describe: "忽听$A一声轻叱，左手划了个半弧，右手食指闪电般点向$D的$l\n", actionTypeOfDamage: DamageActionType.ci, requiredLevel: 1, dodge: 0.95, parry: 0.95, damageFactor: 1.7),
                   KSkillAction(describe: "只见$A一转身，一指由胁下穿出，疾刺$D的$l\n", actionTypeOfDamage: DamageActionType.ci, requiredLevel: 1, dodge: 0.95, parry: 1.1, damageFactor: 1.8)]
    }
    
    required init(k: KObject) {
        guard k is KSPutiZhi else {
            fatalError("Cloning KSPutiZhi with unkown object")
        }
        super.init(k: k)
    }
    
    let NAME = "菩提指"
    
    override func isValidForLearn() -> Bool {
        guard super.isValidForLearn() else { return false}
        let owner = self.owner!
        if owner.getEquippedItem(EquipPosition.rightHand) != nil || owner.getEquippedItem(EquipPosition.leftHand) != nil {
            return notifyFail("练菩提指必须空手", to: owner)
        }
        return true;
    }
}
