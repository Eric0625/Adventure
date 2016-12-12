//
//  KShuangChaLingBoss1.swift
//  Adventure
//
//  Created by 苑青 on 2016/11/21.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation
class KShuangChaLingBoss1: KHuman {
    required init(){
        super.init(name: KColors.HIY + "寅将军" + KColors.NOR)
        describe = "雄威身凛凛，猛气貌堂堂。电目飞光艳，雷声振四方。\n锯牙舒口外，凿齿露腮旁。锦绣围身体，文斑裹脊梁。\n钢须稀见肉，钩爪利如霜。东海黄公惧，南山白额王。"
        mapSkill(KSUnarmed(level: randomInt(20) + 10), inType: .unarmed)
        mapSkill(KSQianJunBang(level: randomInt(20) + 10), inType: .stick)
        combatExp = 10000
        setLifePropertyMax(.force, amount: 400)
        setLifeProperty(.force, amount: 450)
        setLifeProperty(.kee, amount: 1000)
        setLifePropertyMax(.kee, amount: 1000)
        attitude = .aggressive
        rebornInterval = -1
    }
    
    required init(k: KObject) {
        assert(k is KShuangChaLingBoss1)
        super.init(k: k)
    }
    
    override func clone() -> KObject {
        return KShuangChaLingBoss1(k: self)
    }
    
    override func readyEquips() {
        let gun = KQiMeiGun()
        gun.moveTo(self)
        assert(equip(gun))
        let cloth = KCloth()
        cloth.moveTo(self)
        assert(equip(cloth))
    }
    
    var berserk = false
    override func receiveDamage(_ type: DamageType, damageAmout: Int, from attacker: KCreature?) {
        super.receiveDamage(type, damageAmout: damageAmout, from: attacker)
        if berserk == false && Double(kee) < Double(maxKee) * 0.3 {
            tellRoom(KColors.HIR + "\(name)进入了狂暴状态！" + KColors.NOR, room: environment!)
            str *= 2
            damage *= 2
            berserk = true
        }
    }
    
    override func createCorpse() -> KCorpse {
        let corp = super.createCorpse()
        corp.describe = "一头凶猛的白额金睛虎！\n然而，它已经死了。"
        return corp
    }
    
    override func die() {
        super.die()
        tellRoom("\(name)露出了原形，原来竟是一头白额金睛虎！", room: environment!)
    }
}
