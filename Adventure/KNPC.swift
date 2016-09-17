//
//  KNPC.swift
//  Adventure
//
//  Created by 苑青 on 16/4/27.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KNPC: KCreature {
    required init(k: KObject) {
        guard let npc = k as? KNPC else {
            fatalError("Init KNPC with unkown object")
        }
        startRoomID = npc.startRoomID
        attitude = npc.attitude
        availableCommands = npc.availableCommands
        chatMsg = npc.chatMsg
        chatChance = npc.chatChance
        randomMoveChance = npc.randomMoveChance
        rebornInterval  = npc.rebornInterval
        _rebornTick = npc._rebornTick
        expGain = npc.expGain
        super.init(k: k)
    }
    
    override init(name: String) {
        super.init(name: name)
    }
    
    required convenience init(){
        self.init(name: "普通npc")
    }
    
    override func clone() -> KObject{
        return  KNPC(k: self)
    }
    
    var startRoomID = -1
    var attitude = NPCAttitude.Peace
    var availableCommands = NPCCommands.Normal
    var chatMsg = [""]
    var chatChance = 0
    var randomMoveChance = 0
    var rebornInterval = 300//十分钟
    private var _rebornTick = 0
    var expGain = 0//杀死时直接获得的经验
    var visible: Bool { return isGhost == TheWorld.ME.isGhost }
    
    ///在玩家来到同一环境时的互动，因为是立即触发，因此greeting不发生在这里
    func interactWith(user: KUser){
        switch attitude {
        case .Peace: break
        case .Aggressive:
            if !isFightingWith(user) {
                startFighting(user)
            }
        case .Defend: break
        }
    }
    
    func chat() -> Bool {
        if isInFighting {return false }
        if isGhost { return false }
        if chatMsg.isEmpty { return false }
        if environment == nil {return false }
        tellRoom(chatMsg[randomInt(chatMsg.count)], room: environment!)
        return true
    }
    
    func reborn() {
        _rebornTick = 0
        TheRoomEngine.instance.move(self, toRoomWithRoomID: startRoomID)
        reviveFrom()
        let room = environment as! KRoom
        TheWorld.didUpdateRoomInfo(room, ent: self, type: .NewEntity)//因为前面的移动是以鬼魂形式，所以这里需要更新（todo：玩家是鬼魂形式时的额外处理)
    }
    
    override func makeOneHeartBeat() {
        super.makeOneHeartBeat()
        if isGhost {
            _rebornTick += 1
            if _rebornTick == rebornInterval{
                reborn()
                return
            }
        }
        if randomInt(100) < chatChance { chat() }
        if randomInt(100) < randomMoveChance { randomMove() }
    }
    
    func acceptObject(ent: KEntity) -> Bool { return true }
    
    func randomMove() -> Bool {
        if isGhost { return false }
        if isInFighting { return false }
        if isBusy { return false }
        guard let room = environment as? KRoom else { return false }
        if let direct = room.exits.random() {
            return TheRoomEngine.instance.moveFrom(room, through: direct, ob: self)
        }
        return false
    }
    
    func processUserCommand(cmd: NPCCommands) -> Bool {
        switch cmd {
        case NPCCommands.Observe:
            if TheWorld.ME.environment != environment {
                return notifyFail("你看不见" + gender.thirdPersonPronounce() + "了。", to: TheWorld.ME)
            }
            givePlayerBrief()
        case NPCCommands.Kill:
            if TheWorld.ME.environment != environment {
                return notifyFail("你和" + gender.thirdPersonPronounce() + "不在一起了。", to: TheWorld.ME)
            }
            startFighting(TheWorld.ME)
        default:
            return notifyFail("什么？", to: TheWorld.ME)
        }
        return true
    }
    
    override func die() {
        super.die()
        guard let env = environment else { return }
        let corpse = KCorpse(creature: self)
        var belongingDest:KEntity = corpse
        if env.accept(corpse) == false { belongingDest = env }
        if let inventory = _entities {
            for item in inventory {
                if item.moveTo(belongingDest) == false
                { item.moveTo(env) }
            }
        }
        if lastDamager == TheWorld.ME { rewardUser() }
        if let room = env as? KRoom {
            if visible {
                TheWorld.didUpdateRoomInfo(room, ent: self, type: .UpdateEntity)
            } else {
                TheWorld.didUpdateRoomInfo(room, ent: self, type: .RemoveEntity)
            }
        }

    }
    
    /// 玩家杀死NPC后的奖励
    private func rewardUser(){
        var reward = expGain
        var effExp:Double = Double(combatExp)
        if effExp > 20000 { effExp /= 3 }
        else if effExp > 5000 { effExp /= 2 }
        let userExp:Double = Double(TheWorld.ME.combatExp)
        var ratio:Double = 1
        if effExp > 200 && userExp > effExp {return}
        if userExp < effExp / 3{
            if userExp > effExp / 8
                {ratio = (userExp - effExp / 8) / (effExp / 3 - effExp / 8)}
            else if effExp > 500 {return} //武学低于NPC1/8，无法获得经验
        }
        DEBUG("combat with \(name)（\(guid)） gain ratio:\(ratio)")
        if reward == 0{
            switch effExp {
            case 0...500:
                reward = 25
            case 501...2000:
                reward = 50
            case 2001...5000:
                reward = 100
            case 5001...17000:
                reward = 150
            case 17001...33000:
                reward = 200
            case 33001...100000:
                reward = 300
            case 100000...333000:
                reward = 400
            case 333001...667000:
                reward = 500
            default:
                reward = 600
            }
        }
        reward = Int(Double(reward) * ratio)
        DEBUG("combat with \(name) gain exp:\(reward)")
        tellPlayer("你获得了\(reward)点武学。", usr: TheWorld.ME)
        TheWorld.ME.combatExp += reward
    }    
}