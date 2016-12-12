//
//  KYuanTianGangYao.swift
//  Adventure
//
//  Created by 苑青 on 2016/11/19.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KYuanTianGangYao: KHuman {
    required init(){
        super.init(name: names[randomInt(names.count)])
        mapSkill(KSUnarmed(level: randomInt(20) + 10), inType: .unarmed)
        mapSkill(KSQianJunBang(level: randomInt(20) + 10), inType: .stick)
        randomMoveChance = 1
        age = 14 + randomInt(80)
        gender = .男性
        rebornInterval = 5
        attitude = .aggressive
    }
    
    required init(k: KObject) {
        assert(k is KYuanTianGangYao)
        super.init(k: k)
        name = names[randomInt(names.count)]
        age = 14 + randomInt(80)
    }
    
    let names = ["黑熊怪", "灰狼怪", "野猪怪", "黑狗怪"]
    
    override func readyEquips() {
        let gun = KQiMeiGun()
        gun.moveTo(self)
        assert(equip(gun))
        let cloth = KCloth()
        cloth.moveTo(self)
        assert(equip(cloth))
    }
    
    override func clone() -> KObject {
        return KYuanTianGangYao(k: self)
    }

    override func die() {
        super.die()
        _ = TheQuestEngine.instance.processQuest(sender: self, questID: 01)
        //从对象列表中移除自己
        TheWorld.unregHeartBeat(self)
        environment?.remove(self)
        environment = nil
    }
}
