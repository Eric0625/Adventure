//
//  KSMoonDance.swift
//  Adventure
//
//  Created by 苑青 on 16/5/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KSMoonDance: KSDodge {
    
    override init(level: Int){
        super.init(level: level)
        name = NAME
        actions = [KSkillAction(describe: "$D低头细数裙褶，情思困困，步法回旋之际似乎娇柔无力，却将$A攻势一一化于无形\n"),
                   KSkillAction(describe: "只见$D一个转身，忽然回眸一笑。$A一楞之下，哪里还有人在\n", actionTypeOfDamage: DamageActionType.Default, requiredLevel: 0, dodge: 1.05),
                   KSkillAction(describe: "可是$D婉尔一笑，不退反进，身形径向$A飘来。\n$A只觉一股甜香入鼻，这一招竟无着力之处\n", actionTypeOfDamage: DamageActionType.Default, requiredLevel: 0, dodge: 1.1),
                   KSkillAction(describe: "$D身法轻灵，腰肢几拧，居然幻出斑驳月影。$A眼一花，哪里分得出是人，是影\n", actionTypeOfDamage: DamageActionType.Default, requiredLevel: 5, dodge: 1.15),
                   KSkillAction(describe: "$D裙裾飘飘，白衣姗姗，已然从$A头顶飞过，这般女神端丽之姿，仙子缥缈之形，$A不由得看呆了\n", actionTypeOfDamage: DamageActionType.Default, requiredLevel: 10, dodge: 1.3),
                   KSkillAction(describe: "$D脚步轻盈，风姿嫣然，身子便如在水面上飘浮一般掠过，不等$A劲风袭到，已悄然隐去\n", actionTypeOfDamage: DamageActionType.Default, requiredLevel: 20, dodge: 1.5),
                   KSkillAction(describe: "$D纤腰微颤，带飞如虹，轻轻将$A的劲力拨在一旁，尽数化解\n", actionTypeOfDamage: DamageActionType.Default, requiredLevel: 50, dodge: 2)]
    }
    
    required init(k: KObject) {
        guard k is KSMoonDance else {
            fatalError("Cloning KSMoonDance with unkown object")
        }
        super.init(k: k)
    }
    
    let NAME = "冷月凝香舞"
    
    override func isValidForLearn() -> Bool {
        if let o = owner {
            if o.gender != .女性 { return notifyFail(NAME + "只有女性才能练习。", to: o) }
            return true
        }
        return false
    }
}