//
//  KGaoHouHuaYuanRoom.swift
//  Adventure
//
//  Created by 苑青 on 2016/11/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KGaoHouHuaYuanRoom: KRoom {
    required init(roomDescribe d: KRoomDescribe) {
        super.init(roomDescribe: d)
    }
    
    required init(k: KObject) {
        fatalError("init(k:) has not been implemented")
    }
    
    var stage = 0
    
    override func explore() {
        switch stage {
        case 0:
            tellUser("你在花丛中发现了一条小路，小路直通向花园后墙")
            describe += "\n花丛中多了一条歪歪扭扭的小路。"
            TheWorld.didUpdateRoomInfo(self)
            stage = 1
        case 1:
            if let ent = self._entities?.first(where: { $0.name == KGaoHouHuaYuanWall.NAME }) {
                tellUser("你穿过小路，在长满了荆棘的墙头扒拉着，终于有了一个可以翻过去的缺口。")
                stage = 2
                ent.isInStealth = false
                TheWorld.didUpdateRoomInfo(self)
            } else {
                super.explore()
            }
        default:
            super.explore()
        }
    }
}
