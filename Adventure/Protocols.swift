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

@objc protocol UserStatusUpdateDelegate {
    optional func statusWillUpdate()
    func statusDidUpdate()
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
