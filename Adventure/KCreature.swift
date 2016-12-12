//
//  KCreature.swift
//  Adventure
//
//  Created by 苑青 on 16/4/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

//any thing that can fight，生物
/*
 天赋：str = 膂力, cor = 胆识, wiz = 悟性, Spe = 口才, kar = 福缘， per = 容貌，基准为20，上限为30,容貌为隐藏属性
 属性：kee = 气血，sen = 神志， force = 内力，均有max和当前值，Fury = 杀气
 频繁变化的属性：damage = 伤害力，armor = 护甲, combatExp = 武学，耐力
 */

class KCreature: KEntity, CombatEntity, WithHeartBeat {
       required init( k: KObject) {
        assert(k is KCreature)
        
        let creature = k as! KCreature
        gender = creature.gender
        attackableLimbs = creature.attackableLimbs
        isInFighting = creature.isInFighting
        rivalList = creature.rivalList //使用浅拷贝
        guardMessage = creature.guardMessage
        berserkMessage = creature.berserkMessage
        defaultActions = deepCopy(creature.defaultActions)
        combatInfo = creature.combatInfo
        damage = creature.damage
        armor = creature.armor
        combatExp = creature.combatExp
        lastDamager = creature.lastDamager//仅复制引用
        lastHealer = creature.lastHealer //仅复制引用
        reviver = creature.reviver //仅复制引用
        isGhost = creature.isGhost
        title = creature.title
        age = creature.age
        str = creature.str
        cor = creature.cor
        wiz = creature.wiz
        per = creature.per
        kar = creature.kar
        spe = creature.spe
        lifeProperty = creature.lifeProperty
        lifePropertyMax = creature.lifePropertyMax
        fury = creature.fury
        super.init(k: k)
        learnedSkills = [String: KSkill]()
        for (_, skill) in creature.learnedSkills {
            let newSkill = KSkill(k: skill)
            newSkill.owner = self
            learnedSkills[newSkill.name] = newSkill//优化，这里不调用函数加入，跳过存在性检查
        }
        mappedSkills = [SkillType: KSkill]()
        for (type, mskill) in creature.mappedSkills {
            let (_, skillToMap) = learnedSkills.filter({(_, value) in value.name == mskill.name })[0]
            mappedSkills[type] = skillToMap
        }
        for cond in creature.conditions {
            let new = KCondition(k: cond)
            applyCondition(new, caster: new.generator)
        }
        TheWorld.regHeartBeat(self)
    }
    
    override init(name: String){
        super.init(name: name)
        selfCapacity = Int.max
        mapSkill(KSUnarmed(), inType: .unarmed)
        mapSkill(KSDodge(), inType: .dodge)
        mapSkill(KSParry(), inType: .parry)
        TheWorld.regHeartBeat(self)
    }
    
    override func clone() -> KObject {
        return  KCreature(k: self)
    }
    
    //MARK:variables
    var gender = Gender.中性
    fileprivate let MAX_OPPPONENTS = 40
    var attackableLimbs = ["上部","中部","下部"] //用于攻击的部位
    var isInFighting = false {
        didSet{
            if isInFighting == true {
                //into fighting
                TheWorld.didUpdateUserInfo(self, type: .intoFight, info: oldValue as AnyObject?)
            } else {
                TheWorld.didUpdateUserInfo(self, type: .outFight, info: oldValue as AnyObject?)
            }
        }
    }
    
    ///对手列表，使用集合
    private(set) var rivalList = Set<KCreature>()
    ///防守信息
    var guardMessage = ["$A伺机而动。\n"]
    var berserkMessage = ["看起来$A想杀死$D！\n"]
    var defaultActions = [KSkillAction.defaultAction]
    ///具备的技能，键为技能名称（为了快速访问），值为技能本身
    fileprivate(set) var learnedSkills = [String: KSkill]()
    var combatInfo = CombatInfo()
    fileprivate(set) var mappedSkills = [SkillType: KSkill]() //与各类型动作对应的技能，如空手，武器，闪躲，招架等
    var damage = 0
    var armor = 0
    dynamic var combatExp = 0
    weak var lastDamager: KCreature?
    weak var lastHealer: KCreature?
    weak var reviver: KCreature?//复活者
    var isGhost = false {
        didSet{
            if oldValue == false {
                TheWorld.didUpdateUserInfo(self, type: .death, info: oldValue as AnyObject?)
            } else {
                TheWorld.didUpdateUserInfo(self, type: .revive, info: oldValue as AnyObject?)
            }
        }
    }
    
    fileprivate var conditions = [KCondition]()
    //MARK: - status
    var title = ""
    var age = 0{
        didSet{
            TheWorld.didUpdateUserInfo(self, type: .age, info: oldValue as AnyObject?)
        }
    }
    
    var str = 20
    var cor = 20
    var wiz = 20
    var per = 20
    var kar = 20
    var spe = 20
    fileprivate(set) var lifeProperty = [DamageType.force: 0, DamageType.kee: 100, DamageType.sen: 100]
    //设置生命、内力或精神
    func setLifeProperty(_ type:DamageType, amount:Int){
        let oldValue = lifeProperty[type]!
        lifeProperty[type] = amount
        switch type {
        case .kee:
            TheWorld.didUpdateUserInfo(self, type: .kee, info: oldValue as AnyObject?)
        case .force:
            TheWorld.didUpdateUserInfo(self, type: .force, info: oldValue as AnyObject?)
        case .sen:
            TheWorld.didUpdateUserInfo(self, type: .sen, info: oldValue as AnyObject?)
        }
    }
    
    fileprivate(set) var lifePropertyMax = [DamageType.force: 0, DamageType.kee: 100, DamageType.sen: 100]
    func setLifePropertyMax(_ type:DamageType, amount:Int){
        let oldValue = lifePropertyMax[type]!
        lifePropertyMax[type] = amount
        switch type {
        case .kee:
            TheWorld.didUpdateUserInfo(self, type: .maxKee, info: oldValue as AnyObject?)
        case .force:
            TheWorld.didUpdateUserInfo(self, type: .maxForce, info: oldValue as AnyObject?)
        case .sen:
            TheWorld.didUpdateUserInfo(self, type: .maxSen, info: oldValue as AnyObject?)
        }
    }
    
    var kee: Int { return lifeProperty[DamageType.kee]! }
    var sen: Int { return lifeProperty[DamageType.sen]! }
    var force: Int { return lifeProperty[DamageType.force]! }
    var maxKee: Int { return lifePropertyMax[DamageType.kee]! }
    var maxSen: Int { return lifePropertyMax[DamageType.sen]! }
    var maxForce: Int { return lifePropertyMax[DamageType.force]! }
    var fury = 0 //杀气
    //----------计算型属性-----------------
    var nameWithTitle: String {
        if title.isEmpty { return name }
        return title + " " + name
    }
    
    var isLiving: Bool{ return false }
    var isBusy: Bool {
        for cond in conditions {
            if cond.name == KBusyCondition.NAME { return true }
        }
        return false
    }
    //MARK: - functions
    //MARK: skill functions
    func hasLearnedSkill(_ skill: KSkill) -> Bool {
        return learnedSkills.contains(where: {
            $0.1 == skill
        })
    }
    
    /// 设置对应类型的skill等级，必须已经map了这个skill
    func setSkill(inType skillType: SkillType, toLevel level: Int) {
        if let skill = mappedSkills[skillType] {
            skill.level = level
        }
    }
    
    func setSkill(_ skillname: String, toLevel level:Int){
        if let skill = learnedSkills[skillname] {
            skill.level = level
        }
    }
    
    /// 如果没有该skill，会加入，如果已有同名的，会替换
    func addSkill(_ skill: KSkill) {
        if learnedSkills[skill.name] != nil {
            //找出map里的旧skill，替换之
            if mappedSkills.values.contains(skill) {
                for item in mappedSkills {
                    if item.1 == skill {
                        mappedSkills[item.0] = skill
                        break
                    }
                }
            }
        }
        learnedSkills[skill.name] = skill
        skill.owner = self
    }
    
    func deleteSkill(_ skill:KSkill){
        skill.owner = nil
        learnedSkills[skill.name] = nil
        for item in mappedSkills {
            if item.1 == skill {
                mappedSkills[item.0] = nil
                break
            }
        }
    }
    
    func getSkill(_ name: String) -> KSkill?{
        return learnedSkills[name]
    }
    
    func mapSkill(_ skill:KSkill, inType type: SkillType){
        if hasLearnedSkill(skill) == false {
           //先加入该skill
            addSkill(skill)
        }
        if skill.isValidForMappingWith(type) == false { return }
        mappedSkills[type] = skill
    }
    
    fileprivate func getSkillLevel(_ skillname: String) -> Int {
        return learnedSkills[skillname]?.level ?? KSkill._DEFAULT_SKILL_LEVEL
    }
 
    func applyCondition(_ cond: KCondition, caster: KObject? = nil, doPostApply:Bool = true){
        cond.owner = self
        cond.generator = caster
        conditions.append(cond)
        if doPostApply { cond.afterAppliedToOwner() }
        TheWorld.didUpdateUserInfo(self, type: .applyCondition, info: cond)
    }
    
    func chooseRandomOpponent() -> KCreature?{
        let qualified = rivalList.filter({$0.environment == environment})
        if qualified.isEmpty { return nil }
        return qualified[randomInt(qualified.count)]
    }
   
    func startBusy(_ time:Int){
        if time <= 0 { return }
        let busy = KBusyCondition(time: time)
        applyCondition(busy)
    }
    
    func getDefaultAction() -> KSkillAction{
        if let wp = getEquippedItem(.rightHand) as? KWeapon {
            return wp.getRandomAction()
        } else {
            return defaultActions[randomInt(defaultActions.count)]
        }
    }
    
    func isFightingWith(_ op: KCreature) -> Bool {
        return rivalList.contains(op) && isInFighting
    }
    
    func startFighting(_ op: KCreature) {
        if isGhost { return }
        if op.isGhost { return }
        if rivalList.count >= MAX_OPPPONENTS { return }
        if isFightingWith(op) { return }
        isInFighting = true
        insertRival(r: op)
        if op.isFightingWith(self) == false { op.startFighting(self) }
        combatInfo.clearAll()
        combatInfo.rival = op
    }
    
    func endFighting(_ op: KCreature) {
        if rivalList.contains(op) == false { return }
        removeRival(r: op)
        if rivalList.isEmpty { isInFighting = false }
    }
    
    
    func makeOneAttack(_ op: KCreature) -> KSkillAction {
        //最基本的一次攻击返回信息
        if let wp = getEquippedItem(.rightHand) as? KWeapon {
            let usage = wp.skillType
            if let skill = mappedSkills[usage] {
                return skill.getRandomAction()
            } else { return wp.getRandomAction() }
        }
        return mappedSkills[.unarmed]!.getRandomAction()
    }
    
    func unequip(_ eqp: KEquipment) -> Bool {
        guard eqp.validUnequip() else { return false }
        if !isGhost && eqp.unequipMessage != ""  && environment != nil{
            tellRoom(processInfomation(eqp.unequipMessage, attacker: self), room: environment!)
        }
        eqp.isEquipped = false
        eqp.afterEquip()
        resetDamage()
        resetArmor()
        TheWorld.didUpdateUserInfo(self, type: .unequip, info: eqp)
        return true
    }

    func equip(_ eqp: KEquipment) -> Bool {
        guard let inventory = _entities else { return false }
        if inventory.contains(eqp) == false { return false }
        if eqp.validEquip() == false { return false }
        if isGhost { return false }
        var oldep: KEquipment?
        if let wp = getEquippedItem(eqp.definedEquipPosition) {
            if unequip(wp) == false {
                return notifyFail("你必须先卸下" + wp.name, to: self)
            }
            oldep = wp
        }
        //只有双手武器需要额外检查左手
        if eqp.equipType == .twoHandedWeapon {
            if let wp = getEquippedItem(EquipPosition.leftHand) {
                if unequip(wp) == false {
                    return notifyFail("你必须先卸下" + wp.name, to: self)
                }
            }
        }
        //检测通过，开始装备
        eqp.isEquipped = true
        if !isGhost && environment != nil && !eqp.equipMessage.isEmpty { tellRoom(processInfomation(eqp.equipMessage, attacker: self), room: environment!) }
        eqp.afterEquip()
        resetDamage()
        resetArmor()
        
        TheWorld.didUpdateUserInfo(self, type: .equip, info: EquipmentChangeInfo(new: eqp, old: oldep) as AnyObject? )
        return true
    }
    
    func startBerserk(_ chr: KCreature){
        let msg = processInfomation(berserkMessage[randomInt(berserkMessage.count)], attacker: self, defenser: chr)
        tellRoom(msg, room: self.environment!)
        chr.startFighting(self)
    }
    
    fileprivate var _tick = 0
    func makeOneHeartBeat() {
        guard environment != nil else{
            TheWorld.unregHeartBeat(self)
            return
        }
        if !isGhost && (kee < 0 || sen < 0) {
            die()
            return
        }
        if isGhost {return}
        for i in (0..<conditions.count).reversed() {
            if conditions[i].duration == -1 { conditions.remove(at: i) }
            else {
                conditions[i].tickle()
                conditions[i].duration -= 1
            }
        }
        if !isBusy && !rivalList.isEmpty {
            if let op = chooseRandomOpponent() {
                if isInFighting == false {
                    startBerserk(op)
                    isInFighting = true
                }
                _tick -= 1
                if _tick > 0 {return}
                _tick = randomInt(3)
                TheWorld.broadcast(TheCombatEngine.instance.doCombat(self, defenser: op))
            }else {
                isInFighting = false
            }
        }
    }

    func getGuardingMessage() -> String { return guardMessage[randomInt(guardMessage.count)] }
    
    /// 返回对应类型的技能等级
    func getEffSkillLevel(_ type: SkillType) -> Int{
        return getActualSkillLevel(type)// in base clas,only return raw level
    }
    
    func getEffSkillLevel(_ skillname: String) -> Int?{
        return learnedSkills[skillname]?.level
    }
    
    func receiveHeal(_ type:DamageType, healAmount: Int, from healer: KCreature? = nil){
        lastHealer = healer
        var result = lifeProperty[type]! + healAmount
        if result > lifePropertyMax[type] {
            result = lifePropertyMax[type]!
        }
        setLifeProperty(type, amount: result)
    }
    
    func receiveDamage(_ type:DamageType, damageAmout: Int, from attacker: KCreature? = nil){
        lastDamager = attacker
        if lifeProperty[type]! < 0 { return } //死亡不再受到伤害
        setLifeProperty(type, amount: lifeProperty[type]! - damageAmout)        
    }
    
    func die() {
        if isGhost == true { return }
        isGhost = true
        conditions.removeAll() //清除状态,todo，有一些状态死后不消失
        for ob in rivalList {
            ob.endFighting(self)
        }
        endAllFighting()
        if let env = environment {
            tellRoom(processInfomation("$A死了。", attacker: self), room: env)
        }
    }
    
    func reviveFrom(_ chr: KCreature? = nil){
        reviver = chr
        for type in DamageType.AllValues {
            lifeProperty[type] = lifePropertyMax[type]
        }
        isGhost = false
        TheWorld.regHeartBeat(self)
    }
    
    override func remove(_ ent: KEntity) -> Bool {
        if let eq = ent as? KEquipment {
            if eq.isEquipped {
                if unequip(eq) == false { return false }
            }
        }
        guard super.remove(ent) else { return false }
        //移除成功，发送消息
        TheWorld.didUpdateUserInfo(self, type: .dropItem, info: ent)
        return true
    }
    
    func getActualSkillLevel(_ type: SkillType) -> Int {
        if let skill = mappedSkills[type] { return skill.level}
        return KSkill._DEFAULT_SKILL_LEVEL
    }
    
    override var allCapacity: Int{
        let c = (str * 5 + (getActualSkillLevel(SkillType.unarmed))).KG
        return min(super.allCapacity, c)
    }
   
    func endAllFighting() {
        removeAllRival()
        isInFighting = false;
    }
    
    func getRandomLimb() -> String{
        return attackableLimbs[randomInt(attackableLimbs.count)]
    }
    
        
    func resetDamage(){
        damage = str
        if let wp = getEquippedItem(EquipPosition.rightHand) as? KWeapon {
            damage += wp.damage
        }
        if let wp = getEquippedItem(EquipPosition.leftHand) as? KWeapon {
            damage += wp.damage / 2
        }
    }
    
    func resetArmor(){
        armor = 0
        if let inventory = _entities {
            for item in inventory {
                if let ar = item as? KArmor {
                    if ar.isEquipped {
                        armor += ar.armor
                    }
                }
            }
        }
    }
    
    ///返回特定装备位置的装备
    func getEquippedItem(_ position: EquipPosition) -> KEquipment? {
        guard let inventory = _entities else { return nil }
        let result = inventory.filter(){
            if let item = $0 as? KEquipment {
                return item.definedEquipPosition == position && item.isEquipped
            }
            return false
        }
        assert(result.count <= 1)
        if result.isEmpty { return nil }
        return result[0] as? KEquipment
    }
    
    ///todo:根据百分比加上颜色
    func formatLifeProperty(_ type: DamageType) -> String{
        let amout = TheWorld.ME.lifeProperty[type]!
        let amoutMax = TheWorld.ME.lifePropertyMax[type]!
        var per:Double = 0
        if amoutMax > 0 {
            per = (Double(amout) * 100 / Double(amoutMax))
        }
        let s = cutZeroesAtTail(String(format: "%.2f", per))
        
        return "\(amout)/\(amoutMax)(\(s)%)"
    }
    
    //封装对手池编辑功能，因为需要在对手池发生变动时呼叫代理函数
    func insertRival(r:KCreature){
        rivalList.insert(r)
        TheWorld.didUpdateUserInfo(self, type: .addRival, info: r)
    }
    func removeRival(r:KCreature){
        rivalList.remove(r)
        TheWorld.didUpdateUserInfo(self, type: .removeRival, info: r)
    }
    func removeAllRival(){
        for r in rivalList{
            removeRival(r: r)
        }
    }

    ///逃跑函数，各生物可自定义自己的情况，在基类中永远逃跑失败
    func fleeFromFight() -> Bool{
        return false
    }
    
    func getPureDescribe() -> String{
        return super.describe
    }
}

