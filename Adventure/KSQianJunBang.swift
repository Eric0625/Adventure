//
//  KSQianJunBang.swift
//  Adventure
//
//  Created by 苑青 on 16/5/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KSQianJunBang: KSkill {
    
    init(level: Int){
        super.init(name: NAME)
        self.level = level
        actions = [KSkillAction(describe: "$A身形稍退，手中$W迎风一抖，朝着$D劈头盖脸地砸将下来\n", actionTypeOfDamage: DamageActionType.Za, requiredLevel: 1, dodge: 1.05, parry: 0.9, damageFactor: 1.35),
                   KSkillAction(describe: "$A仰天长笑，看也不看，随手一棒向$D当头砸下\n", actionTypeOfDamage: DamageActionType.Za, requiredLevel: 1, dodge: 1, parry: 1, damageFactor: 1.25),
                   KSkillAction(describe: "$A一个虎跳，越过$D头顶，手中$W抡个大圆，呼！地一声砸向$D$l\n", actionTypeOfDamage: DamageActionType.Za, requiredLevel: 1, dodge: 1.1, parry: 0.8, damageFactor: 1.35),
                   KSkillAction(describe: "$A一声巨喝！<br>就在$D一愣之间，$A手中$W已是呼啸而至，扫向$D的$l\n", actionTypeOfDamage: DamageActionType.Za, requiredLevel: 1, dodge: 1.1, parry: 0.85, damageFactor: 1.25),
                   KSkillAction(describe: "$A使出「醉闹蟠桃会」，脚步跄踉，左一棒，右一棒，<br>打得$D手忙脚乱，招架不迭\n", actionTypeOfDamage: DamageActionType.Za, requiredLevel: 1, dodge: 0.95, parry: 0.95, damageFactor: 1.3),
                   KSkillAction(describe: "$A连翻几个筋斗云，手中$W转得如风车一般，一连三棒从半空中击向$D顶门\n", actionTypeOfDamage: DamageActionType.Za, requiredLevel: 15, dodge: 1.05, parry: 0.9, damageFactor: 1.2, name: "霹雳三打", coolDown: 20),
                   KSkillAction(describe: KColors.HIY+"$A手中$W一抖，化为千万道霞光，\n就在$D目眩神摇之时，再一抖，霞光顿收，\n$W已到了$D的$l！这一招有个名堂，叫作「千钧澄玉宇」\n"+KColors.NOR, actionTypeOfDamage: DamageActionType.Za, requiredLevel: 1, dodge: 1, parry: 0.8, damageFactor: 1.4, name: "千钧澄玉宇"),
                   KSkillAction(describe: KColors.HIY + "$A将手中$W迎风一挥，幻出万千虚影，蓄力劲发，高举过顶，$W对准$D的脑门就砸了下去。这一下要是打中，恐怕连大罗金仙也难逃一命\n" + KColors.NOR, actionTypeOfDamage: DamageActionType.Za, requiredLevel: 1, dodge: 0.5, parry: 0.4, damageFactor: 2, name: "乾坤一棒", coolDown: 10)]
    }
    
    required init(k: KObject) {
        guard k is KSQianJunBang else {
            fatalError("Cloning KSQianJunBang with unkown object")
        }
        super.init(k: k)
    }
    
    let NAME = "千钧棒法"
    
    override func isValidForLearn() -> Bool {
        guard super.isValidForLearn() else {return false }
        let owner = self.owner!
        if let wp = owner.getEquippedItem(EquipPosition.RightHand) as? KWeapon {
            if wp.skillType == .Stick {return true}
        }
        return notifyFail("必须手持棍棒才能学习这个技能", to: owner)
    }
    
    override func isValidForPractice() -> Bool {
        guard super.isValidForPractice() else {return false }
        let owner = self.owner!
        if let wp = owner.getEquippedItem(EquipPosition.RightHand) as? KWeapon {
            if wp.skillType == .Stick {return true}
        }
        return notifyFail("必须手持棍棒才能练习这个技能", to: owner)
    }
    
    override func performSpecialAction(name: String, toTarget target: KCreature) -> Bool {
        guard super.performSpecialAction(name, toTarget: target) else {return false}
        let owner = self.owner!
        if target.isGhost {return notifyFail("对方已经死了。。。", to: owner)}
        if !owner.isInFighting { return notifyFail("技能\(name)只能在战斗中使用。", to: owner) }
        switch name {
        case "乾坤一棒":
            if owner.sen < 50 { return notifyFail("你不够清醒，不足以施放\(name)", to: owner) }
            if owner.force < 100 { return notifyFail("你的内力不足，不能施放\(name)", to: owner) }
            let act = actions.filter({$0.name == name})[0]
            tellRoom(processInfomation("$A运足精神， 一个高跳在空，使出了" + KColors.Purple + "「乾坤一棒」" + KColors.NOR + "的绝技！", attacker: owner), room: owner.environment!)
            tellRoom(TheCombatEngine.instance.doCombat(owner, defenser: target, isCounterAttack: false, noGarding: true, designatedAction: act), room: owner.environment!)
            act.afterActionTaken()
            owner.receiveDamage(.Sen, damageAmout: 20 + randomInt(30), from: owner)
            owner.receiveDamage(.Force, damageAmout: 100, from: owner)
            owner.startBusy(2)
        case "霹雳三打":
            if level < 40 { return notifyFail("你的千钧棒技能太低了，使用这招有困难", to: owner) }
            let act = actions.filter({$0.name == name })[0]
            tellRoom(processInfomation(KColors.HIY+"$A运足精神，身形一转，霹雳间连续向$D攻出了三招！<br>"+KColors.NOR, attacker: owner, defenser: target), room: owner.environment!)
            tellRoom(TheCombatEngine.instance.doCombat(owner, defenser: target, isCounterAttack: false, noGarding: true), room: owner.environment!)
            tellRoom(TheCombatEngine.instance.doCombat(owner, defenser: target, isCounterAttack: false, noGarding: true), room: owner.environment!)
            tellRoom(TheCombatEngine.instance.doCombat(owner, defenser: target, isCounterAttack: false, noGarding: true), room: owner.environment!)
            act.afterActionTaken()
            owner.receiveDamage(.Sen, damageAmout: 30 + randomInt(30), from: owner)
            owner.receiveDamage(.Force, damageAmout: 100, from: owner)
            owner.startBusy(2)
        default:
            break
        }
        return true
    }
}