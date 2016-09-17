//
//  KUser.swift
//  Adventure
//
//  Created by 苑青 on 16/4/28.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KUser: KCreature {
    
        required init(){
            _lastSetTime = NSDate()
            super.init(name: "王老五")
            limbs = ["头部","颈部","胸口","后心", "左肩","右肩",   "左臂",
                     "右臂",   "左手",   "右手",   "腰间",   "小腹",   "左腿",   "右腿",
                     "左脚",   "右脚"]
            guardMessage = [KColors.CYN + "$A注视着$D的行动，企图寻找机会出手。\n" + KColors.NOR]
            guardMessage += [KColors.CYN + "$A正盯着$D的一举一动，随时准备发动攻势。\n" + KColors.NOR,
                             KColors.CYN + "$A缓缓地移动脚步，想要找出$D的破绽。\n" + KColors.NOR]
            guardMessage += [KColors.CYN + "$A目不转睛地盯着$D的动作，寻找进攻的最佳时机。\n" + KColors.NOR ,
                             KColors.CYN + "$A慢慢地移动着脚步，伺机出手。\n" + KColors.NOR]
            defaultActions.removeAll()
            defaultActions.append(KSkillAction(describe: "$A挥拳攻击$D的$l。\n", actionTypeOfDamage: DamageActionType.Zhang))
            defaultActions.append(KSkillAction(describe: "$A往$D的$l一抓。\n", actionTypeOfDamage: DamageActionType.Zhua))
            defaultActions.append(KSkillAction(describe: "$A往$D的$l狠狠地踢了一脚。\n", actionTypeOfDamage: DamageActionType.Zhang))
            defaultActions.append(KSkillAction(describe: "$A提起拳头往$D的$l捶去。\n", actionTypeOfDamage: DamageActionType.Za))
            defaultActions.append(KSkillAction(describe: "$A对准$D的$l用力挥出一拳。\n", actionTypeOfDamage: DamageActionType.Za))
            berserkMessage = []
            gender = Gender.男性
            weight = 100.KG
            selfCapacity = Int.max
            initGift()
            mapSkill(KSPutiZhi(level: 26), inType: .Unarmed)
            mapSkill(KSMoonDance(level: 70), inType: .Dodge)
            age = 14
    }
    
    required init(k: KObject) {
        fatalError("Clone function is not been implemented")
    }
    
    
    override func clone() -> KObject{
        return  KUser(k: self)
    }
    
    private var _deathTick = 0
    private(set) var deathTime = 0
    private var _mudAge:NSTimeInterval = 0
    private var _lastSetTime: NSDate
    var money = 0
    let availableCommands = UserCommands.All
    
    override var combatExp: Int {
        //willSet{ TheWorld() }
        didSet{ TheWorld.didUpdateUserInfo(self, type: .CombatExp, oldValue: oldValue) }
    }
    override var isLiving: Bool { return true }
    
    private var sellRatio:Double {
        let Spe = Double(spe)
        return (16.217 + 0.878 * Spe + 0.045 * Spe * Spe) / 100
    }
    
    var target: KNPC?{
        //willSet { TheWorld.willUpdateUserInfo() }
        didSet{  TheWorld.didUpdateUserInfo(self, type: .Target, oldValue: oldValue) }
    }
    
    func initGift() {
        kar = 0
        while(kar < 10 || kar > 30){
            str = 7 + randomInt(24)
            cor = 7 + randomInt(24)
            wiz = 7 + randomInt(24)
            per = 7 + randomInt(24)
            spe = 7 + randomInt(24)
            let n = str + cor + wiz + spe
            if n > 100 { kar = 0 }
            else { kar = 100 - n }
        }
        setLifePropertyMax(.Kee, amount: 200)
        receiveHeal(.Kee, healAmount: 200)
        setLifePropertyMax(.Sen, amount: 200)
        receiveHeal(.Sen, healAmount: 200)
        resetArmor()
        resetDamage()
    }
    
    override func startFighting(op: KCreature) {
        super.startFighting(op)
        tellPlayer(KColors.HIR + "看起来" + op.name + "想杀死你！" + KColors.NOR, usr: self)
    }
    
    override func makeOneHeartBeat() {
        super.makeOneHeartBeat()
        for rival in rivalList {
            if rival.environment != environment { rivalList.remove(rival) }
        }
        if isGhost == false {
            let now = NSDate()
            _mudAge += now.timeIntervalSinceDate(_lastSetTime)
            _lastSetTime = now
            age = 14 + _mudAge.day
        }
        else{
            if _deathTick < 0 {
                isGhost = false
                let deathRoom = KDeathRoom()
                moveTo(deathRoom)
                _deathTick = 0
                receiveHeal(.Sen, healAmount: maxSen / 5)
                receiveHeal(.Kee, healAmount: maxKee / 5)
            }
            else { _deathTick -= 1 }
        }
    }
    
   private func skillLoss(){
        DEBUG("Skill Loss")
        for skill in learnedSkills {
            skill.1.subLevel /= 2
        }
    }
    
    override func die() {
        super.die()
        let combatLoss = combatExp / 40
        fury = 0
        if randomInt(100) > kar {
            skillLoss()
        }
        combatExp -= combatLoss
        _deathTick = 5
        deathTime += 1
    }
    
    override func equip(eqp: KEquipment) -> Bool {
        let result = super.equip(eqp)
        if result {
            if isInFighting { startBusy(20) }
        }
        return result
    }
    
    override func unequip(eqp: KEquipment) -> Bool {
        let result = super.unequip(eqp)
        if result {
            if isInFighting { startBusy(20) }
        }
        return result
    }
    
    func dropItem(item: KItem) -> Bool{
        guard let inv = _entities else { return false }
        if !inv.contains(item) { return false }
        if environment == nil { return false }
        let result = item.moveTo(environment!)
        if result {
            tellRoom("你将\(item.name)丢在\(environment!.name)。", room: environment!)
            if isInFighting { startBusy(10) }
        }
        return result
    }
    
    func sellValueOf(item: KItem) -> Int {
        var value = Int(Double(item.value) * sellRatio)
        if value > (item.value - 1 ){ value = item.value - 1 }
        return value
    }
    
    func buyValueOf(item: KItem) -> Int {
        var value = Int(Double(item.value) / sellRatio)
        if value < item.value { value = item.value }
        return value
    }
    
    func processCommand(cmd: UserCommands) {
        switch cmd {
        case UserCommands.Inventory:
            print("dd")
        default:
            TheWorld.broadcast("什么？")
        }
    }
}

extension NSTimeInterval {
    var day: Int { return Int(self) / 86400 }
}
