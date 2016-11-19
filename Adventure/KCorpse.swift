//
//  KCorpse.swift
//  Adventure
//
//  Created by 苑青 on 16/4/30.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KCorpse: KItem, WithHeartBeat {
    
    let corpseToDecay = 60
    let decayToSkeleton = 60
    let skeletonToVoid = 30
    
    init(creature: KCreature){
        gender = creature.gender
        var age = creature.age / 10
        age *= 10
        super.init(name: creature.name + "的尸体")
        var desc = creature.getPureDescribe() //提取原始字符串
        desc +=  gender.thirdPersonPronounce + "是一位" + toChineseNumber(age)
        if creature.age != age {
            desc += "多"
        }
        desc += "岁的" + rankRespect(creature) + "\n"
        desc += gender.thirdPersonPronounce + getPerMsg(creature) + "\n"
        desc += "然而" + gender.thirdPersonPronounce + "已经死了，只剩下一具尸体静静地躺在这里。"
        describe = desc
        TheWorld.regHeartBeat(self)
        selfCapacity = creature.selfCapacity
        weight = 10.KG
    }
    
    required init(k: KObject) {
        guard let corpse = k as? KCorpse else {
            fatalError("Cloning KCorpse with unkown object")
        }
        decayPhase = corpse.decayPhase
        _tick = corpse._tick
        gender = corpse.gender
        super.init(k: k)
    }
    
    required convenience init() {
        fatalError("尸体无法独立生成")
    }
    
    override func clone() -> KObject {
        return KCorpse(k: self)
    }
    
    var decayPhase = 0
    fileprivate var _tick = 0
    let gender:Gender
    
    func makeOneHeartBeat() {
        guard let env = self.environment else {
            TheWorld.unregHeartBeat(self)
            return
        }
        _tick += 1
        switch decayPhase {
        case 0:
            if _tick >= corpseToDecay {
                decayPhase = 1
                _tick = 0
                tellRoom("\(name)开始腐烂了， 发出一股难闻的恶臭。", room: env)
                switch gender {
                case .男性:
                    name = "腐烂的男尸"
                case .中性:
                    name = "腐烂的尸体"
                case .女性:
                    name = "腐烂的女尸"
                }
                describe = "这具尸体显然已经躺在这里有一段时间了，正散发着一股腐尸的味道。"
                if let r = env as? KRoom {
                    TheWorld.didUpdateRoomInfo(r, ent: self, type: .updateEntity)
                }
            }
        case 1:
            if _tick >= decayToSkeleton {
                decayPhase = 2
                _tick = 0
                tellRoom("\(name)被风吹干了，变成了一具骸骨。", room: env)
                name = "一具枯干的骸骨"
                describe = "这副骸骨已经躺在这里很久了。"
                if let r = env as? KRoom {
                    TheWorld.didUpdateRoomInfo(r, ent: self, type: .updateEntity)
                }
            }
        case 2:
            if _tick >= skeletonToVoid {
                tellRoom("一阵风吹过，把\(name)化成骨灰吹散了。\n", room: env)
                moveAllInventoryItemTo(destEnv: env)
                env.remove(self)
                environment = nil
                TheWorld.unregHeartBeat(self)
            }
        default:
            fatalError()
        }
    }
}
