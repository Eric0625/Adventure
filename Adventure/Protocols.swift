//
//  Protocols.swift
//  Adventure
//
//  Created by 苑青 on 16/4/24.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

protocol DisplayMessageDelegate {
    func displayMessage(_ message:String)
    func clearAllMessage()
}

///由于二元组直接传入anyvlaue会引起编译器错误，构建一个结构专用于装备变更的情况
struct EquipmentChangeInfo {
    let new: KEquipment
    let old: KEquipment?
}
///所有重要的状态更新消息代码，information不做特别说明都是oldvalue
enum CreatureStatusUpdateType {
    case kee
    case maxKee
    case sen
    case maxSen
    case force
    case maxForce
    case age
    case combatExp
    case damage
    case defense
    case target
    case death
    case revive
    case intoFight
    case outFight
    case addRival //此时information为该添加的对手
    case removeRival //此时information为该删除的对手
    case equip //information为二元组(新装备，之前的装备)
    case unequip //infomation为卸载的装备
    case dropItem //information为丢弃的物品
    case getItem //information为得到的物品
    case applyCondition //information为condition
}

protocol StatusUpdateDelegate {
    //optional func statusWillUpdate()
    func statusDidUpdate(_ creature:KCreature, type:CreatureStatusUpdateType, information:AnyObject?)
}

protocol CombatEntity{
    associatedtype combatOponent
    func makeOneAttack(_ op: combatOponent) -> KSkillAction
    func startFighting(_ op: combatOponent)
    func endFighting(_ op: combatOponent)
}

///遵循该协议的类具有心跳(需在心跳引擎处注册)
protocol WithHeartBeat {
    func makeOneHeartBeat()
}

enum RoomInfoUpdateType {
    case newRoom
    case newEntity
    case removeEntity
    case updateEntity
}
//所有需要处理房间更新信息的类都应声明此协议
protocol RoomInfoUpdateDelegate {
    func processRoomInfo(_ room: KRoom, entity:KEntity?, type:RoomInfoUpdateType)
}
