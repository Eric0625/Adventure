//
//  KBeast.swift
//  Adventure
//
//  Created by 苑青 on 2016/11/22.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation
///四足有爪野兽
class KBeastWithClaw: KNPC{
    required init(k: KObject) {
        guard let beast = k as? KBeastWithClaw else {
            fatalError("Init Kbeast with unkown object")
        }
        _interactiveTarget = beast._interactiveTarget
        super.init(k: k)
    }
    override init(name: String){
        super.init(name: name)
        attackableLimbs = ["头部","颈部","胸口", "左爪", "右爪", "左前腿",
                           "右前腿",   "左后脚",  "右后脚",  "腰间",   "肚皮",   "左后腿",   "右后腿",
                           "尾巴"]
        guardMessage = [KColors.CYN + "$A注视着$D的行动，企图寻找机会出击。\n" + KColors.NOR]
        guardMessage += [KColors.CYN + "$A正盯着$D的一举一动，随时准备发动攻势。\n" + KColors.NOR,
                         KColors.CYN + "$A缓缓地移动四脚，想要找出$D的破绽。\n" + KColors.NOR]
        guardMessage += [KColors.CYN + "$A目不转睛地盯着$D的动作，寻找进攻的最佳时机。\n" + KColors.NOR ,
                         KColors.CYN + "$A慢慢地移动着脚步，伺机出手。\n" + KColors.NOR]
        defaultActions.removeAll()
        defaultActions.append(KSkillAction(describe: "$A挥爪攻击$D的$l。\n", actionTypeOfDamage: DamageActionType.zhua))
        defaultActions.append(KSkillAction(describe: "$A往$D的$l一抓。\n", actionTypeOfDamage: DamageActionType.zhua))
        defaultActions.append(KSkillAction(describe: "$A往$D的$l狠狠地挠了一下。\n", actionTypeOfDamage: DamageActionType.zhua))
        defaultActions.append(KSkillAction(describe: "$A蹬起后腿往$D的$l踢去。\n", actionTypeOfDamage: DamageActionType.yu))
        defaultActions.append(KSkillAction(describe: "$A对准$D的$l咬了下去。\n", actionTypeOfDamage: DamageActionType.ci))
        berserkMessage = [
            KColors.HIR+"$A和$D仇人相见份外眼红，立刻打了起来！\n"+KColors.NOR,
            KColors.HIR+"$A对着$D发出一声怒吼！\n"+KColors.NOR,
            KColors.HIR+"$A和$D一碰面，立刻战在一起！\n"+KColors.NOR,
            KColors.HIR+"$A一眼瞥见$D，「嗷」的一声冲了过来！\n"+KColors.NOR,
        ]
        initGift()
        gender = .公
        weight = 20.KG // todo 这里可以使用正态分布
    }
    
    required convenience init(){
        self.init(name: "普通野兽npc")
    }
    
    override func clone() -> KObject{
        return  KBeastWithClaw(k: self)
    }
    
    weak var _interactiveTarget: KUser?
    override var isLiving: Bool{return true}
    
    func initGift() {
        kar = 0
        while(kar < 10 || kar > 30){
            str = 7 + randomInt(24)
            cor = 7 + randomInt(24)
            wiz = 7 + randomInt(24)
            per = 7 + randomInt(24)
            spe = 7 + randomInt(24)
            let n = str + cor + wiz + spe
            if n > 100 { kar = 0 }
            else { kar = 100 - n }
        }
        setLifePropertyMax(.kee, amount: 200)
        receiveHeal(.kee, healAmount: 200)
        setLifePropertyMax(.sen, amount: 200)
        receiveHeal(.sen, healAmount: 200)
        resetArmor()
        resetDamage()
        //selfCapacity = (str * 5 + 10).KG
    }
    
    func greeting(_ usr: KUser) {}
    
    override func interactWith(_ ent: KEntity) {
        super.interactWith(ent)
        if let user = ent as? KUser {
            if user.isGhost == false { _interactiveTarget = user }
        }
    }
    
    override func makeOneHeartBeat() {
        super.makeOneHeartBeat()
        if let target = _interactiveTarget {
            if !isInFighting && !isGhost && target.environment == environment
            { greeting(target) }
            _interactiveTarget = nil
        }
    }
    
    override func generateDescribe() -> String {
        var str = super.generateDescribe()
        if let inventory = _entities {
            var equipArmor = ""
            for ent in inventory {
                if let eq = ent as? KEquipment {
                    if eq.isEquipped {
                            switch eq.definedEquipPosition {
                            case .head:
                                equipArmor += "头上戴着\(ent.name)。\n"
                            case .neck:
                                equipArmor += "脖子上箍着\(ent.name)。\n"
                            case .waist:
                                equipArmor += "腰间套着\(ent.name)。\n"
                            case .foot:
                                equipArmor += "脚上穿着\(ent.name)。\n"
                            case .leg:
                                equipArmor += "腿上套着\(ent.name)。\n"
                            case .body:
                                equipArmor += "身上套着\(ent.name)。\n"
                            case .glove:
                                equipArmor += "爪上套着\(ent.name)。\n"
                            default:
                                break
                            }
                        }
                    }
                }
            if !equipArmor.isEmpty {
                str += "只见" + gender.thirdPersonPronounce
                if !equipArmor.isEmpty { str += equipArmor }
            }
        }
        for skill in learnedSkills.values {
            var status = " "
            if mappedSkills.values.contains(skill) {
                status += "□"
            } else { status += "  " }
            status += "\(skill.name): \(skill.level)/\(skill.subLevel)"
            str += status + "\n" //todo:技能等级描述
        }
        return str
    }
}
