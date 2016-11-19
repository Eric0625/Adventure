//
//  KPoisonCondition.swift
//  Adventure
//
//  Created by 苑青 on 16/4/30.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KPoisonCondition: KCondition {
    
    init(amount: Int, duration: Int){
        _amout = amount
        super.init(name: NAME, duration: duration)
    }
    
    required init(k: KObject) {
        guard let poison = k as? KPoisonCondition else {
            fatalError("Cloning KPoisonCondition with unkown object")
        }
        _amout = poison._amout
        super.init(k: k)
    }
    
    let NAME = "毒药"
    fileprivate let _amout:Int
    override func tickle() {
        super.tickle()
        guard let owner = self.owner else { return }
        if duration > 0 {
            let cor = Double(owner.cor)
            let ratio = Int(0.051 + 1.173 * cor + 0.071 * cor * cor);//todo，修改ratio
            if randomInt(100) < ratio {
                owner.receiveDamage(.kee, damageAmout: _amout, from: generator as? KCreature)
                if let env = owner.environment{
                    tellRoom(processInfomation(KColors.HIG + "$D脸现痛苦之色，显然是毒药发作了！<br>" + KColors.NOR, attacker: nil, defenser: owner), room: env)
                    tellRoom(getStatusMsg(owner, type: .kee), room: env)
                }
            }
        } else {
            if let env = owner.environment {
                tellRoom(processInfomation(KColors.HIG + "$D身上的毒药消失了。<br>" + KColors.NOR, attacker: nil, defenser: owner), room: env)
            }
        }
    }
}
