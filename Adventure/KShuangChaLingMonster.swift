//
//  Monster.swift
//  Adventure
//
//  Created by 苑青 on 2016/11/21.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation
class KShuangChaLingMonster: KBeastWithClaw {
    required init(){
        super.init(name: names[randomInt(names.count)])
        mapSkill(KSUnarmed(level: randomInt(20) + 10), inType: .unarmed)
        mapSkill(KSQianJunBang(level: randomInt(20) + 10), inType: .stick)
        randomMoveChance = 1
        attitude = .aggressive
    }
    
    required init(k: KObject) {
        assert(k is KShuangChaLingMonster)
        super.init(k: k)
        name = names[randomInt(names.count)]
    }
    
    let names = ["野牛精", "白虎精", "山枭精", "黑熊精"]
    
    override func readyEquips() {
        let gun = KQiMeiGun()
        gun.moveTo(self)
        assert(equip(gun))
        let cloth = KCloth()
        cloth.moveTo(self)
        assert(equip(cloth))
    }
    
    override func clone() -> KObject {
        return KShuangChaLingMonster(k: self)
    }

    override func die() {
        super.die()
        //从对象列表中移除自己
        TheWorld.unregHeartBeat(self)
        environment?.remove(self)
        environment = nil
    }
}
