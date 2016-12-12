//
//  KNPC.swift
//  Adventure
//
//  Created by 苑青 on 16/4/27.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

///NPC不同于creature基类的地方是具备和玩家互动的能力，如有触发函数，命令处理函数等
class KNPC: KCreature {
    required init(k: KObject) {
        guard let npc = k as? KNPC else {
            fatalError("Init KNPC with unkown object")
        }
        startRoomID = npc.startRoomID
        attitude = npc.attitude
        //availableCommands = npc.availableCommands
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
        readyEquips()
    }
    
    required convenience init(){
        self.init(name: "普通npc")
    }
    
    override func clone() -> KObject{
        return  KNPC(k: self)
    }
    
    var money = 0 //击杀时可获得的money
    var startRoomID = -1
    var attitude = NPCAttitude.peace
    var availableCommands = NPCCommands.normalCmds
    var chatMsg = [String]()
    var combatChatMsg = [String]()
    var chatChance = 0
    var combatChatChance = 0
    var randomMoveChance = 0
    var rebornInterval = 300//十分钟,-1为永不复生
    fileprivate var _rebornTick = 0
    var expGain = 0//杀死时直接获得的经验
    
    ///npc与房间内物体的互动，可用来自定义触发情节，因为是立即触发，因此greeting不发生在这里
    func interactWith(_ ent: KEntity){
        if let user = ent as? KUser {
            switch attitude {
            case .peace: break
            case .aggressive:
                if !isFightingWith(user) {
                    startFighting(user)
                }
            case .defend: break
            }
        }
    }
    
    @discardableResult func chat() -> Bool {
        if isInFighting {return false }
        if isGhost { return false }
        if chatMsg.isEmpty { return false }
        if environment == nil {return false }
        tellRoom(chatMsg[randomInt(chatMsg.count)], room: environment!)
        return true
    }
    
    @discardableResult func combatChat() -> Bool {
        if isInFighting == false { return false }
        if isGhost { return false }
        if environment == nil { return false }
        if let msg = combatChatMsg.random() {
            tellRoom(msg, room: environment!)
            return true
        }
        return false
    }
    ///初始化装备的地方
    func readyEquips() { }
    
    func reborn() {
        _rebornTick = 0
        TheRoomEngine.instance.move(self, toRoomWithRoomID: startRoomID)
        readyEquips()
        reviveFrom()
        let room = environment as! KRoom
        TheWorld.didUpdateRoomInfo(room, ent: self, type: .newEntity)//因为前面的移动是以鬼魂形式，所以这里需要更新（todo：玩家是鬼魂形式时的额外处理)
    }
    
    override func makeOneHeartBeat() {
        super.makeOneHeartBeat()
        if isGhost {
            if rebornInterval < 0 {
                TheWorld.unregHeartBeat(self)
                environment?.remove(self)
                return
            }
            _rebornTick += 1
            if _rebornTick == rebornInterval{
                reborn()
                return
            }
        }
        if randomInt(100) < chatChance { chat() }
        if isInFighting && randomInt(100) < combatChatChance { combatChat() }
        if randomInt(100) < randomMoveChance { randomMove() }
    }
    
    func acceptObject(_ ent: KEntity) -> Bool { return true }
    
    @discardableResult func randomMove() -> Bool {
        if isGhost { return false }
        if isInFighting { return false }
        if isBusy { return false }
        guard let room = environment as? KRoom else { return false }
        if let direct = room.exits.random() {
            return TheRoomEngine.instance.moveFrom(room, through: direct, ob: self)
        }
        return false
    }
    
    @discardableResult func processNPCCommand(_ cmd: String) -> Bool {
        switch cmd {
        case NPCCommands.observe:
            if TheWorld.ME.environment != environment {
                return notifyFail("你看不见" + gender.thirdPersonPronounce + "了。", to: TheWorld.ME)
            }
            tellUser(describe)
        case NPCCommands.kill:
            if TheWorld.ME.environment != environment {
                return notifyFail("你和" + gender.thirdPersonPronounce + "不在一起了。", to: TheWorld.ME)
            }
            startFighting(TheWorld.ME)
        default:
            return notifyFail("什么？", to: TheWorld.ME)
        }
        return true
    }
    
    func createCorpse() -> KCorpse{
        return KCorpse(creature: self)
    }
    
    override func die() {
        super.die()
        guard let env = environment else { return }
        let corpse = createCorpse()
        var belongingDest:KEntity = corpse
        if let inventory = _entities {
            for item in inventory {
                if item.moveTo(belongingDest) == false
                { item.moveTo(env) }
            }
        }
        if corpse.moveTo(env) == false {
            belongingDest = env
            if let inventory = corpse._entities {
                for item in inventory {
                    if item.moveTo(belongingDest) == false
                    { print("尸体物品转移失败：from \(name) to \(belongingDest.name)") }
                }
            }
        }
        corpse.weight = weight
        if lastDamager == TheWorld.ME { rewardUser() }
        if let room = env as? KRoom {
            if TheWorld.ME.canSee(ent: self) {
                TheWorld.didUpdateRoomInfo(room, ent: self, type: .updateEntity)
            } else {
                TheWorld.didUpdateRoomInfo(room, ent: self, type: .removeEntity)
            }
        }

    }
    
    /// 玩家杀死NPC后的奖励
    fileprivate func rewardUser(){
        if money != 0 {
            TheWorld.ME.money += money
            tellUser("你获得了\(money.moneyString)")
        }
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
        tellUser("你获得了\(reward)点武学。")
        TheWorld.ME.combatExp += reward
    }
    
    override var describe: String{
        set { super.describe = newValue }
        get { return generateDescribe() }
    }
    
    func generateDescribe() -> String {
        var str = "--------------------------------------------\n\(nameWithTitle)"
        if isInFighting {
            str += KColors.HIR + "<战斗中>" + KColors.NOR
        }
        str += "\n" + super.describe
        if age != 0 {
            let dispAge = (age / 10) * 10
            str += "\n" + gender.thirdPersonPronounce + "是一位" + toChineseNumber(dispAge)
            if dispAge != age { str += "多" }
            str += "岁的" + rankRespect(self) + "\n"
        }
        str += gender.thirdPersonPronounce + getPerMsg(self) + "\n"
        return str
    }
}
