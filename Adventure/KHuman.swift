//
//  KHuman.swift
//  Adventure
//
//  Created by 苑青 on 16/4/30.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KHuman: KNPC{
    required init(k: KObject) {
        guard let human = k as? KHuman else {
            fatalError("Init KHuman with unkown object")
        }
        _interactiveTarget = human._interactiveTarget
        super.init(k: k)
    }
    override init(name: String){
        super.init(name: name)
        attackableLimbs = ["头部","颈部","胸口","后心", "左肩","右肩",   "左臂",
            "右臂",   "左手",   "右手",   "腰间",   "小腹",   "左腿",   "右腿",
            "左脚",   "右脚"]
        guardMessage = [KColors.CYN + "$A注视着$D的行动，企图寻找机会出手。\n" + KColors.NOR]
        guardMessage += [KColors.CYN + "$A正盯着$D的一举一动，随时准备发动攻势。\n" + KColors.NOR,
                         KColors.CYN + "$A缓缓地移动脚步，想要找出$D的破绽。\n" + KColors.NOR]
        guardMessage += [KColors.CYN + "$A目不转睛地盯着$D的动作，寻找进攻的最佳时机。\n" + KColors.NOR ,
                         KColors.CYN + "$A慢慢地移动着脚步，伺机出手。\n" + KColors.NOR]
        defaultActions.removeAll()
        defaultActions.append(KSkillAction(describe: "$A挥拳攻击$D的$l。\n", actionTypeOfDamage: DamageActionType.zhang))
        defaultActions.append(KSkillAction(describe: "$A往$D的$l一抓。\n", actionTypeOfDamage: DamageActionType.zhua))
        defaultActions.append(KSkillAction(describe: "$A往$D的$l狠狠地踢了一脚。\n", actionTypeOfDamage: DamageActionType.zhang))
        defaultActions.append(KSkillAction(describe: "$A提起拳头往$D的$l捶去。\n", actionTypeOfDamage: DamageActionType.za))
        defaultActions.append(KSkillAction(describe: "$A对准$D的$l用力挥出一拳。\n", actionTypeOfDamage: DamageActionType.za))
        berserkMessage = [
            KColors.HIR+"$A和$D仇人相见份外眼红，立刻打了起来！\n"+KColors.NOR,
            KColors.HIR+"$A对着$D大喝：「可恶，又是你这个$Dr！\n"+KColors.NOR,
            KColors.HIR+"$A和$D一碰面，二话不说就打了起来！\n"+KColors.NOR,
            KColors.HIR+"$A一眼瞥见$D，「哼」的一声冲了过来！\n"+KColors.NOR,
            KColors.HIR+"$A一见到$D，愣了一愣，大叫：「$Dr，我宰了你！\n"+KColors.NOR,
            KColors.HIR+"$A喝道：「$Dr，我们的帐还没算完，看招！\n"+KColors.NOR,
            KColors.HIR+"$A喝道：「$Dr，看招！\n"+KColors.NOR
        ]
        initGift()
        gender = .男性
        weight = 100.KG // todo 这里可以使用正态分布
    }
    
    required convenience init(){
        self.init(name: "普通人形npc")
    }
    
    override func clone() -> KObject{
        return  KHuman(k: self)
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
    
    override func interactWith(_ user: KUser) {
        super.interactWith(user)
        if user.isGhost == false { _interactiveTarget = user }
    }

    override func makeOneHeartBeat() {
        super.makeOneHeartBeat()
        if let target = _interactiveTarget {
            if !isInFighting && !isGhost && target.environment == environment
                { greeting(target) }
            _interactiveTarget = nil
        }
    }
    
    override var describe: String{
        set { super.describe = newValue }
        get { return generateDescribe() }
    }
    func generateDescribe() -> String {
        var str = "--------------------------------------------\n\(name)\n" + super.describe
        let dispAge = (age / 10) * 10
        str += "\n" + gender.thirdPersonPronounce + "是一位" + toChineseNumber(dispAge)
        if dispAge != age { str += "多" }
        str += "岁的" + rankRespect(self) + "\n"
        str += gender.thirdPersonPronounce + getPerMsg(self) + "\n"
        if let inventory = _entities {
            var equipArmor = ""
            var equipWeapon = ""
            for ent in inventory {
                if let eq = ent as? KEquipment {
                    if eq.isEquipped {
                        if let wp = eq as? KWeapon{
                            if wp.equipType == EquipmentType.oneHandedWeapon {
                                equipWeapon += "单手提着\(wp.name)"
                            }else { equipWeapon += "双手提着\(wp.name)"}
                            equipWeapon += "。\n"
                        }else {
                            assert(eq is KArmor)
                            switch eq.definedEquipPosition {
                            case .leftHand:
                                equipWeapon += "左手扛着\(eq.name)。\n"
                            case .head:
                                equipArmor += "头上戴着\(ent.name)。\n"
                            case .neck:
                                equipArmor += "脖子上戴着\(ent.name)。\n"
                            case .leftRing:
                                equipArmor += "左手戒指戴着\(ent.name)。\n"
                            case .rightRing:
                                equipArmor += "右手戒指戴着\(ent.name)。\n"
                            case .waist:
                                equipArmor += "腰间别着\(ent.name)。\n"
                            case .foot:
                                equipArmor += "脚上穿着\(ent.name)。\n"
                            case .leg:
                                equipArmor += "腿上穿着\(ent.name)。\n"
                            case .body:
                                equipArmor += "身上穿着\(ent.name)。\n"
                            case .glove:
                                equipArmor += "手上戴着\(ent.name)。\n"
                            case .shoudler:
                                equipArmor += "肩上披着\(ent.name)。\n"
                            case .rightHand, .none:
                                break
                            }
                        }
                    }
                }
            }
            if !equipArmor.isEmpty || !equipWeapon.isEmpty {
                str += "只见" + gender.thirdPersonPronounce
                if !equipWeapon.isEmpty { str += equipWeapon }
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
