//
//  TheCombatEngine.swift
//  Adventure
//
//  Created by 苑青 on 16/4/30.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class TheCombatEngine {
    //MARK: Singleton
    private init(){
        DEBUG("combat engine inited")
        
    }
    static var instance: TheCombatEngine {
        struct Singleton {
            static let _instance = TheCombatEngine()
        }
        return Singleton._instance
    }
    
    private func calculateRealDamage(attacker: KCreature, defenser: KCreature) -> Double{
        let starter = attacker.damage - defenser.armor
        var realDamage = Double( starter + randomInt(starter)) / 2
        //TODO:技能特殊效果，武器特殊效果
        /*// Let combat exp take effect
         defense_factor = your["combat_exp"];
         while( random(defense_factor) > my["combat_exp"] ) {
         damage -= damage / 3;
         defense_factor /= 2;
         }*/
        if realDamage <= 0 { realDamage = 1 }
        return realDamage
    }
    
    private func getSkillPower(chr:KCreature, skill:KSkill?) -> Double {
        var power = Double(skill?.level ?? 1)
        power = power * (power + 1) * (2 * power + 1) / 6
        if chr.maxSen > 0 {power = power * Double(chr.sen / chr.maxSen)}
        power += Double(chr.combatExp) / 5.0
        if power < 1 {power = 1}
        return power
    }
    
    /// 战斗中最核心的函数，代表一次攻击和防守
    /// - parameters:
    ///   - isCounterAttack: 是否反击，如果是反击则不会闪躲
    ///   - noGarding: 如果为真则必定出手（仍然有可能躲闪和招架）
    ///   - designatedAction: 是否已指定招式
    func doCombat(attacker: KCreature, defenser: KCreature, isCounterAttack:Bool = false, noGarding: Bool = false, designatedAction:KSkillAction? = nil) -> String{
        if attacker.isGhost || defenser.isGhost {return ""}
        let aCor = Double(attacker.cor)
        var ap, dp, pp, checker, mod: Double
        var message = ""
        var attackerAction, defenserAction: KSkillAction
        let attackerSkill: KSkill?
        let aWeapon: KWeapon? = attacker.getEquippedItem(EquipPosition.RightHand) as? KWeapon
        //let dWeapon: KWeapon? = defenser.getEquippedItem(EquipPosition.RightHand) as? KWeapon
        let defenserLimb = defenser.getRandomLimb()
        if !isCounterAttack { attacker.combatInfo.allRounds += 1 }
        let attackRatio = 0.051 + 1.173 * aCor + 0.071 * aCor * aCor
        if !noGarding && !isCounterAttack && randomInt(100) + 1 > Int(attackRatio) {
            //we do not take action
            message += processInfomation(attacker.getGuardingMessage(), attacker: attacker, defenser: defenser, limbDesc: defenserLimb)
            attacker.combatInfo.guardings += 1
            return message
        } else {
            if let aw = aWeapon {
                attackerSkill = attacker.mappedSkills[aw.skillType]
            } else { attackerSkill = attacker.mappedSkills[SkillType.Unarmed] }
            if designatedAction != nil { attackerAction = designatedAction! }
            else { attackerAction = attacker.makeOneAttack(defenser) }
            ap = getSkillPower(attacker, skill: attackerSkill)
            dp = 0
            message += attackerAction.describe
            //招式已经使出，不管效果如何，都呼叫actiontaken
            attackerAction.afterActionTaken()
            if !isCounterAttack {
                //check the dodge
                let dodge = defenser.mappedSkills[SkillType.Dodge]!
                defenserAction = dodge.getRandomAction()
                dp = getSkillPower(defenser, skill: dodge)
                dp *= defenserAction.dodgePower
                dp *= attackerAction.dodgePower
                if defenser.isBusy { dp /= 3 }
                checker = ap + dp
                let xx = String(format: "%.4f", dp / checker)
                DEBUG("attacker:\(attacker.name), defenser:\(defenser.name),ap:\(ap)  dp:\(dp), dodge possiblity:\(xx)")
                mod = dp
                if checker < 100000{
                    mod *= 100
                    checker *= 100
                }
                let dodgeCheck = randomInt(Int(checker))
                if dodgeCheck < Int(mod) {
                    //闪躲，判断是否反击
                    message += defenserAction.describe
                    attacker.combatInfo.dodges += 1
                    if dp < ap && randomInt(Int(defenser.kar * defenser.wiz + defenser.sen * 100 / defenser.maxSen)) > 150 {
                        defenser.combatExp += 1
                        dodge.improveSubLevel(1)
                    }
                    let pozhan = -10.341 + 1.32 * aCor + 0.023 * aCor * aCor
                    if randomInt(100) < Int(pozhan) {
                        message += KColors.White + "$A一击不中，露出了破绽！<br>" + KColors.NOR
                        attacker.combatInfo.pozhans += 1
                        message += doCombat(defenser, defenser: attacker, isCounterAttack: true)
                    }
                    message = processInfomation(message, attacker: attacker, defenser: defenser, limbDesc: defenserLimb)
                    return message
                }
            }
            //命中，判断是否格挡
            let parry = defenser.mappedSkills[SkillType.Parry]!
            defenserAction = parry.getRandomAction()
            pp = getSkillPower(defenser, skill: parry)
            pp *= defenserAction.parryPower
            pp *= attackerAction.parryPower
            pp = pp * Double(defenser.str) / Double(attacker.str)
            if defenser.isBusy { pp /= 3 }
            mod = pp
            checker = ap + mod
            //let x = pp / checker
            if checker < 100000 {
                mod *= 100
                checker *= 100
            }
            if randomInt(Int(checker)) < Int(mod) {
                //格挡成功
                message += defenserAction.describe
                if !isCounterAttack { attacker.combatInfo.parrys += 1 }
                if pp < ap && randomInt(Int(defenser.kar * defenser.wiz + defenser.sen * 100 / defenser.maxSen)) > 150 {
                    defenser.combatExp += 1
                    parry.improveSubLevel(1)
                }
                return processInfomation(message, attacker: attacker, defenser: defenser, limbDesc: defenserLimb)
            }
            //格挡失败，计算伤害
            var damage = calculateRealDamage(attacker, defenser: defenser)
            damage *= attackerAction.damageFactor
            defenser.receiveDamage(.Kee, damageAmout: Int(damage), from: attacker)
            attacker.combatInfo.lastDamage = damage
            attacker.combatInfo.keeDamage += damage
            if damage > attacker.combatInfo.maxDamage {
                attacker.combatInfo.maxDamage = damage
            }
            message += getDamageMsg(Int(damage), type: attackerAction.damageActionType)
            message += getStatusMsg(defenser, type: .Kee)
            if ap < max(pp, dp)  && randomInt(Int(attacker.kar * attacker.wiz + attacker.sen * 100 / attacker.maxSen)) > 150{
                attacker.combatExp += 1
                if let askill = attackerSkill { askill.improveSubLevel(1) }
            }
            if !isCounterAttack { attacker.combatInfo.hits += 1 }
            else { attacker.combatInfo.counterAttackDamage  += 1 }
            return processInfomation(message, attacker: attacker, defenser: defenser, limbDesc: defenserLimb)
        }
    }
    
}