//
//  KSFengshanSword.swift
//  Adventure
//
//  Created by 苑青 on 16/5/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KSFengshanSword: KSkill {
    
    let NAME = "封山剑法";
    init(level:Int = 1)
    {
        super.init(name: NAME)
        self.level = level
        skillType = .sword
        actions = [KSkillAction(describe: "$A使一招「峰回路转」，手中$W如一条银蛇般刺向$D的$l\n", actionTypeOfDamage: DamageActionType.ci, requiredLevel: 0, dodge: 1, parry: 1, damageFactor: 1.3),
                   KSkillAction(describe: "$A使出封山剑法中的「空山鸟语」，剑光霍霍斩向$D的$l\n", actionTypeOfDamage: DamageActionType.ge, requiredLevel: 0, dodge: 1, parry: 1, damageFactor: 1.3),
                   KSkillAction(describe: "$A一招「御风而行」，身形陡然滑出数尺，手中$W斩向$D的$l\n", actionTypeOfDamage: DamageActionType.ge, requiredLevel: 0, dodge: 1, parry: 1, damageFactor: 1.2),
                   KSkillAction(describe: "$A手中$W中宫直进，一式「旭日东升」对准$D的$l刺出一剑\n", actionTypeOfDamage: DamageActionType.ci),
                   KSkillAction(describe: "$A纵身一跃，手中$W一招「金光泻地」对准$D的$l斜斜刺出一剑\n", actionTypeOfDamage: DamageActionType.ci),
                   KSkillAction(describe: "$A的$W凭空一指，一招「童子引路」刺向$D的$l\n", actionTypeOfDamage: DamageActionType.ci, requiredLevel: 0, dodge: 1, parry: 1, damageFactor: 1.4),
                   KSkillAction(describe: "$A手中$W向外一分，使一招「柳暗花明」反手对准$D$l一剑刺去\n", actionTypeOfDamage: DamageActionType.ci, requiredLevel: 10, dodge: 0.8, parry: 1, damageFactor: 1.2),
                   KSkillAction(describe: "$A横剑上前，身形一转手中$W使一招「空谷秋虹」画出一道光弧斩向$D的$l\n", actionTypeOfDamage: DamageActionType.ge, requiredLevel: 20, dodge: 0.8, parry: 0.9, damageFactor: 1.5)]
    }
    
    required init(k: KObject) {
        guard k is KSFengshanSword else {
            fatalError("Cloning KSFengshanSword with unkown object")
        }
        super.init(k: k)
    }

}
