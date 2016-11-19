//
//  KOrdinaryPerson.swift
//  Adventure
//
//  Created by 苑青 on 16/5/2.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KOrdinaryPerson: KHuman {
    
    required init(){
        super.init(name: names[randomInt(names.count)])
        mapSkill(KSUnarmed(level: randomInt(20) + 10), inType: .unarmed)
        mapSkill(KSQianJunBang(level: randomInt(20) + 10), inType: .stick)
        randomMoveChance = 9
        chatMsg += [ name+"嘴里嘟嘟囔囔不知道说什么。\n",
                     name+"打了个嗝。\n"]
        chatChance = 5
        age = 14 + randomInt(80)
        gender = .女性
        rebornInterval = 300
        readyEquips()
    }
    
    required init(k: KObject) {
        assert(k is KOrdinaryPerson)
        super.init(k: k)
        name = names[randomInt(names.count)]
        age = 14 + randomInt(80)
    }
    
    let names = ["路人甲", "路人乙", "路人丙"]
    
    func readyEquips() {
        let gun = KQiMeiGun()
        gun.moveTo(self)
        assert(equip(gun))
        let cloth = KCloth()
        cloth.moveTo(self)
        assert(equip(cloth))
    }
    
    override func reborn() {
        super.reborn()
        readyEquips()
    }
    
    override func clone() -> KObject {
        return KOrdinaryPerson(k: self)
    }
}
