//
//  KWeapon.swift
//  Adventure
//
//  Created by 苑青 on 16/4/30.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KWeapon: KEquipment {
    
    required init(k: KObject) {
        guard let wp = k as? KWeapon else {
            fatalError("Init KWeapon with unkown object")
        }
        damage = wp.damage
        defaultActions = deepCopy(wp.defaultActions)
        super.init(k: k)
    }
    
    override init(name: String)
    {
        super.init(name: name)
        equipType = .oneHandedWeapon
        definedEquipPosition = .rightHand
    }
    
    required convenience init(){
        self.init(name: "普通武器")
    }
    
    override func clone() -> KObject{
        return  KWeapon(k: self)
    }
    
    var damage = 0
    var defaultActions = [KSkillAction(describe: "$A使用$W攻击$D")]
    ///描述中增加了伤害字样
    override var describe: String {
        set(desc) { super.describe = desc}
        get {
            var desc = super.describe + KColors.HIG + "伤害：\(damage)" + KColors.NOR
            if isEquipped { return desc }
            desc += "\n装备后：\n"
            var delta = damage
            //获取同部位装备信息
            if let weapon = TheWorld.ME.getEquippedItem(definedEquipPosition) as? KWeapon{
                delta = damage - weapon.damage
            }
            if delta > 0 {
                desc += KColors.HIG + "伤害＋" + delta.toString + KColors.NOR
            } else if delta == 0 {
                desc += "伤害不变"
            } else {
                desc += KColors.HIR + "伤害－" + abs(delta).toString + KColors.NOR
            }
            //减去当前武器的特效
            //双手武器还要考虑副手，目前只考虑防具
            if equipType == EquipmentType.twoHandedWeapon  {
                if let arm = TheWorld.ME.getEquippedItem(EquipPosition.leftHand) as? KArmor {
                    if arm.armor != 0 {
                        desc += KColors.HIR + "\n护甲－\(arm.armor)"
                    }
                    //减去副手装备的特效
                }
            }
            return desc
        }
    }
    
    
    override func validEquip() -> Bool {
        guard super.validEquip() else { return false }
        if !(environment is KNPC) && !(environment is KUser) { return false }//todo:直接装备身上容器内的武器
        return true
    }
    
    override func afterEquip() {
        super.afterEquip()
    }
    
    override func afterUnequip() {
        super.afterUnequip()
    }
    
    func getRandomAction() -> KSkillAction {
        return defaultActions[randomInt(defaultActions.count)]
    }
    
    func Bash() {}
    
}
