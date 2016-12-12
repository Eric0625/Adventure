//
//  KGaoGateRoom.swift
//  Adventure
//
//  Created by 苑青 on 2016/11/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KGaoGateRoom: KRoom {
    
    required init(roomDescribe d: KRoomDescribe) {
        super.init(roomDescribe: d)
    }
    
    required init(k: KObject) {
        fatalError("init(k:) has not been implemented")
    }
    
    override func canMoveTo(direction: Directions, entity: KEntity) -> Bool {
        if let creature = entity as? KCreature {
            if direction == .North {
                tellRoom(processInfomation("$A向\(direction.chineseString)探头探脑，被守卫呵斥了回去。", attacker: creature), room: self)
                return true
            }
        }
        return super.canMoveTo(direction: direction, entity: entity)
    }
}
