//
//  KYuanTianGang_City.swift
//  Adventure
//
//  Created by Eric on 16/11/18.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KYuanTianGang_City: KHuman {
    
    static let questCmd = "杀怪"
    
    required init(){
        super.init(name: "袁天罡")
        title = "天监台总管"
        describe = "袁天罡是天监台总管，听说他法术高深。\n他为人正直仗义，脸上总是一股忧国忧民的神情。"
        chatMsg += [name + "叹道：生逢乱世，妖魔横行啊！",
                    name + "问道：可有谁愿去为大唐灭妖吗？"
        ]
        chatChance = 2
        combatExp = 50000
        setLifePropertyMax(.force, amount: 400)
        setLifeProperty(.force, amount: 450)
        mapSkill(KSUnarmed(level: 60), inType: .unarmed)
        mapSkill(KSFengshanSword(level: 60), inType: .sword)
        setSkill(KSDodge.NAME, toLevel: 50)
        setSkill(KSParry.NAME, toLevel: 50)
        age = 45
        availableCommands.append(KYuanTianGang_City.questCmd)
    }
    
    required init(k: KObject) {
        assert(k is KJiaoTou_City)
        super.init(k: k)
    }
    
    override func clone() -> KObject {
        return KJiaoTou_City(k: self)
    }
    
    override func readyEquips() {
        let c = KBaguaPao()
        c.moveTo(self)
        guard equip(c) == true else {
            fatalError()
        }
        let s = KTaomuJian()
        s.moveTo(self)
        guard equip(s) == true else {
            fatalError()
        }
    }

    override func processNPCCommand(_ cmd: String) -> Bool {
        switch cmd {
        case KYuanTianGang_City.questCmd:
            return TheQuestEngine.instance.assignQuest(questID: 01)
        default:
            return super.processNPCCommand(cmd)
        }
    }
}
