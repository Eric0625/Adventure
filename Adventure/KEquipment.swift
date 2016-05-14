//
//  KEquipment.swift
//  Adventure
//
//  Created by 苑青 on 16/4/29.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KEquipment: KItem {
    
    required init(k: KObject) {
        guard let item = k as? KEquipment else {
            fatalError("Init KEquipment with unkown object")
        }
        equippedPosition = item.equippedPosition
        skillType = item.skillType
        equipType = item.equipType
        equipMessage = item.equipMessage
        unequipMessage = item.unequipMessage
        super.init(k: k)
    }
    
    override init(name: String){
        super.init(name: name)
    }
    
    required convenience init(){
        self.init(name: "普通装备")
    }
    
    override func clone() -> KObject{
        return  KEquipment(k: self)
    }
    
    var equippedPosition = EquipPosition.NONE
    var skillType = SkillType.None//用于确定对应的技能：剑法，掌法，棒法等
    var equipType = EquipType.NONE
    var equipMessage = ""
    var unequipMessage = ""
    
    func validEquip() -> Bool {
        guard let owner = environment as? KCreature else { return false }
        if equippedPosition != EquipPosition.NONE { return notifyFail("\(name)已经在装备了。", to: owner) }
        return true
    }
    
    func validUnequip() -> Bool {
        if equippedPosition == EquipPosition.NONE { return false }
        return true
    }
    
    func afterEquip() {}
    func afterUnequip() {}
}