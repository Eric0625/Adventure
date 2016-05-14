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
        equipType = EquipType.OneHandedWeapon
    }
    
    required convenience init(){
        self.init(name: "普通武器")
    }
    
    override func clone() -> KObject{
        return  KWeapon(k: self)
    }
    
    var damage = 0
    var defaultActions = [KSkillAction(describe: "$A使用$W攻击$D")]
    
    override func validEquip() -> Bool {
        guard super.validEquip() else { return false }
        if !(environment is KHuman) && !(environment is KUser) { return false }//todo:直接装备身上容器内的武器
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