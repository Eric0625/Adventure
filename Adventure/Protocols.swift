//
//  Protocols.swift
//  Adventure
//
//  Created by 苑青 on 16/4/24.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

protocol DisplayMessageDelegate {
    func displayMessage(message:String)
    func clearAllMessage()
}

enum UserStatusUpdateType {
    case Kee
    case MaxKee
    case Sen
    case MaxSen
    case Force
    case MaxForce
    case Age
    case CombatExp
    case Damage
    case Defense
    case Target
    case Death
    case Revive
    case IntoFight
    case OutFight
}

protocol StatusUpdateDelegate {
    //optional func statusWillUpdate()
    func statusDidUpdate(creature:KCreature, type:UserStatusUpdateType, oldValue:AnyObject?)
}

protocol CombatEntity{
    associatedtype combatOponent
    func makeOneAttack(op: combatOponent) -> KSkillAction
    func startFighting(op: combatOponent)
    func endFighting(op: combatOponent)
}

protocol WithHeartBeat {
    func makeOneHeartBeat()
}

enum RoomInfoUpdateType {
    case NewRoom
    case NewEntity
    case RemoveEntity
    case UpdateEntity
}
//所有需要处理房间更新信息的类都应声明此协议
protocol RoomInfoUpdateDelegate {
    func processRoomInfo(room: KRoom, entity:KEntity?, type:RoomInfoUpdateType)
}
