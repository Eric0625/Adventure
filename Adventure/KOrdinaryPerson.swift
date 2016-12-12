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
        super.init(name: "temp")
        name = initName()
        mapSkill(KSUnarmed(level: randomInt(20) + 10), inType: .unarmed)
        mapSkill(KSQianJunBang(level: randomInt(20) + 10), inType: .stick)
        randomMoveChance = 9
        chatMsg += [ name+"嘴里嘟嘟囔囔不知道说什么。\n",
                     name+"打了个嗝。\n"]
        chatChance = 5
        age = 14 + randomInt(80)
        gender = .女性
        rebornInterval = 300
    }
    
    required init(k: KObject) {
        assert(k is KOrdinaryPerson)
        super.init(k: k)
        name = initName()
        age = 14 + randomInt(80)
    }
    
    func initName() -> String {
        if randomInt(2) == 0 {
            return firstName.random()! + nameWords.random()! + nameWords.random()!
        } else {
            return firstName.random()! + nameWords.random()!
        }
    }
    let firstName = ["赵","钱","孙","李","周","吴","郑","王","张","陈",
    "刘","林"]
    let nameWords = [ "顺","昌","振","发","财","俊","彦","良","志","忠",
    "孝","雄","益","添","金","辉","长","盛","胜","进","安","福","同","满",
    "富","万","龙","隆","祥","栋","国","亿","寿", "青", "林", "丽"]
    
    override func readyEquips() {
        let gun = KQiMeiGun()
        gun.moveTo(self)
        assert(equip(gun))
        let cloth = KCloth()
        cloth.moveTo(self)
        assert(equip(cloth))
    }
    
    override func clone() -> KObject {
        return KOrdinaryPerson(k: self)
    }
}
