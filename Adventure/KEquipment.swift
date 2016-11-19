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
        definedEquipPosition = item.definedEquipPosition
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
    
    ///获取可用命令，根据是否在玩家身上返回不同值
    override var availableCommands: ItemCommands {
        get {
            let cmd = super.availableCommands
            if environment === TheWorld.ME {
                if isEquipped { return cmd.union(ItemCommands.unequip) }
                else { return cmd.union(ItemCommands.equip) }
            }
            return cmd
        }
    }
    
    ///是否已装备
    var isEquipped = false
    ///这里定义该装备应该装备的部位
    var definedEquipPosition = EquipPosition.none
    var skillType = SkillType.none//用于确定对应的技能：剑法，掌法，棒法等
    var equipType = EquipmentType.none //这里主要是控制装备的类型，比如板甲，皮甲，锤，等
    var equipMessage = ""
    var unequipMessage = ""
    
    ///装备前检查是否能够装备
    func validEquip() -> Bool {
        //检查是否在生物身上，包括其携带的容器里
        guard var owner = environment  else { return false }
        while(!(owner is KCreature)) {
            if owner.environment == nil { return false }
            owner = owner.environment!
        }
        if isEquipped == true { return notifyFail("\(name)已经在装备了。", to: owner) }
        return true
    }
    
    ///卸下装备时检查是否满足卸下的要求
    func validUnequip() -> Bool {
        return isEquipped
    }
    
    func afterEquip() {}
    func afterUnequip() {}
    
    override func processCommand(_ cmd: ItemCommands) -> Bool {
        if super.processCommand(cmd) == false { return false }
        switch cmd {
        case ItemCommands.equip:
            if isContained(in: TheWorld.ME) {
                return TheWorld.ME.equip(self)
            }
        case ItemCommands.unequip:
            if isContained(in: TheWorld.ME) {
                return TheWorld.ME.unequip(self)
            }
        default:
            break
        }
        return true
    }
    
    override var describe: String {
        set { super.describe = newValue }
        get { return super.describe + "(\(equipType.rawValue))" }
    }
}
