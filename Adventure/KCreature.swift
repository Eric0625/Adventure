//
//  KCreature.swift
//  Adventure
//
//  Created by 苑青 on 16/4/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation
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
        limbs = creature.limbs
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
        mapSkill(KSUnarmed(), inType: .Unarmed)
        mapSkill(KSDodge(), inType: .Dodge)
        mapSkill(KSParry(), inType: .Parry)
        TheWorld.regHeartBeat(self)
    }
    
    override func clone() -> KObject {
        return  KCreature(k: self)
    }
    
    //MARK:variables
    var gender = Gender.中性
    private let MAX_OPPPONENTS = 40
    var limbs = ["上部","中部","下部"]
    var isInFighting = false
    var rivalList = Set<KCreature>()
    var guardMessage = ["$A伺机而动。\n"]
    var berserkMessage = ["看起来$A想杀死$D！\n"]
    var defaultActions = [KSkillAction.defaultAction]
    private(set) var learnedSkills = [String: KSkill]()
    var combatInfo = CombatInfo()
    private(set) var mappedSkills = [SkillType: KSkill]() //与各类型动作对应的技能，如空手，武器，闪躲，招架等
    var damage = 0
    var armor = 0
    var combatExp = 0
    weak var lastDamager: KCreature?
    weak var lastHealer: KCreature?
    weak var reviver: KCreature?//复活者
    var isGhost = false
    private var conditions = [KCondition]()
    //MARK: - status
    var title = ""
    var age = 0
    
    var str = 20
    var cor = 20
    var wiz = 20
    var per = 20
    var kar = 20
    var spe = 20
    var lifeProperty = [DamageType.Force: 0, DamageType.Kee: 100, DamageType.Sen: 100]
    var lifePropertyMax = [DamageType.Force: 0, DamageType.Kee: 100, DamageType.Sen: 100]
    var kee: Int { return lifeProperty[DamageType.Kee]! }
    var sen: Int { return lifeProperty[DamageType.Sen]! }
    var force: Int { return lifeProperty[DamageType.Force]! }
    var maxKee: Int { return lifePropertyMax[DamageType.Kee]! }
    var maxSen: Int { return lifePropertyMax[DamageType.Sen]! }
    var maxForce: Int { return lifePropertyMax[DamageType.Force]! }
    var fury = 0 //杀气
    //----------计算型属性-----------------
    var longName: String { return title + " " + name }
    var isLiving: Bool{ return false }
    var isBusy: Bool {
        for cond in conditions {
            if cond.name == KBusyCondition.NAME { return true }
        }
        return false
    }
    //MARK: - functions
    //MARK: skill functions
    func hasLearnedSkill(skill: KSkill) -> Bool {
        return learnedSkills.contains({
            $0.1 == skill
        })
    }
    
    /// 设置对应类型的skill等级，必须已经map了这个skill
    func setSkill(inType skillType: SkillType, toLevel level: Int) {
        if let skill = mappedSkills[skillType] {
            skill.level = level
        }
    }
    
    func setSkill(skillname: String, toLevel level:Int){
        if let skill = learnedSkills[skillname] {
            skill.level = level
        }
    }
    
    /// 如果没有该skill，会加入，如果已有同类型的，会替换
    func addSkill(skill: KSkill) {
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
    
    func deleteSkill(skill:KSkill){
        skill.owner = nil
        learnedSkills[skill.name] = nil
        for item in mappedSkills {
            if item.1 == skill {
                mappedSkills[item.0] = nil
                break
            }
        }
    }
    
    func getSkill(name: String) -> KSkill?{
        return learnedSkills[name]
    }
    
    func mapSkill(skill:KSkill, inType type: SkillType){
        if hasLearnedSkill(skill) == false {
           //先加入该skill
            addSkill(skill)
        }
        if skill.isValidForMappingWith(type) == false { return }
        mappedSkills[type] = skill
    }
    
    private func getSkillLevel(skillname: String) -> Int {
        return learnedSkills[skillname]?.level ?? KSkill._DEFAULT_SKILL_LEVEL
    }
 
    func applyCondition(cond: KCondition, caster: KObject? = nil, doPostApply:Bool = true){
        cond.owner = self
        cond.generator = caster
        conditions.append(cond)
        if doPostApply { cond.afterAppliedToOwner() }
    }
    
    func chooseRandomOpponent() -> KCreature?{
        let qualified = rivalList.filter({$0.environment == environment})
        if qualified.isEmpty { return nil }
        return qualified[randomInt(qualified.count)]
    }
   
    func startBusy(time:Int){
        if time <= 0 { return }
        let busy = KBusyCondition(time: time)
        applyCondition(busy)
    }
    
    func getDefaultAction() -> KSkillAction{
        if let wp = getEquippedItem(.RightHand) as? KWeapon {
            return wp.getRandomAction()
        } else {
            return defaultActions[randomInt(defaultActions.count)]
        }
    }
    
    func isFightingWith(op: KCreature) -> Bool {
        return rivalList.contains(op) && isInFighting
    }
    
    func startFighting(op: KCreature) {
        if isGhost { return }
        if op.isGhost { return }
        if rivalList.count >= MAX_OPPPONENTS { return }
        if isFightingWith(op) { return }
        isInFighting = true
        rivalList.insert(op)
        if op.isFightingWith(self) == false { op.startFighting(self) }
        combatInfo.clearAll()
        combatInfo.rival = op
    }
    
    func endFighting(op: KCreature) {
        if rivalList.contains(op) == false { return }
        rivalList.remove(op)
        if rivalList.isEmpty { isInFighting = false }
    }
    
    
    func makeOneAttack(op: KCreature) -> KSkillAction {
        //最基本的一次攻击返回信息
        if let wp = getEquippedItem(.RightHand) as? KWeapon {
            let usage = wp.skillType
            if let skill = mappedSkills[usage] {
                return skill.getRandomAction()
            } else { return wp.getRandomAction() }
        }
        return mappedSkills[.Unarmed]!.getRandomAction()
    }
    
    func unequip(eqp: KEquipment) -> Bool {
        guard eqp.validUnequip() else { return false }
        if eqp.equippedPosition == .NONE {return notifyFail("你并没有装备这件装备。\n", to: self)}//TODO:考虑双持
        if !isGhost && eqp.unequipMessage != ""  && environment != nil{
            tellRoom(processInfomation(eqp.unequipMessage, attacker: self), room: environment!)
        }
        eqp.equippedPosition = .NONE
        eqp.afterEquip()
        resetDamage()
        resetArmor()
        return true
    }
    
    func equipTo(equipment: KEquipment, position: EquipPosition) -> Bool{
        if let eq = getEquippedItem(position) {
            if unequip(eq) == false { return notifyFail("你必须先卸下\(eq.name)", to: self) }
        }
        equipment.equippedPosition = position
        if !isGhost && !equipment.equipMessage.isEmpty { tellRoom(equipment.equipMessage, room: environment!) }
        equipment.afterEquip()
        resetDamage()
        resetArmor()
        return true
    }

    func equip(eqp: KEquipment) -> Bool {
        guard let inventory = _entities else { return false }
        if inventory.contains(eqp) == false { return false }
        if eqp.validEquip() == false { return false }
        
        switch eqp.equipType {
        case EquipType.OneHandedWeapon:
            //检查右手是否有武器，有则先卸下，如果卸下失败，返回，成功则装载
            //todo:考虑双持
            if let wp = getEquippedItem(EquipPosition.RightHand){
                if unequip(wp) == false { return notifyFail("你必须先卸下手里的武器。", to: self) }
            }
            eqp.equippedPosition = EquipPosition.RightHand
        case EquipType.TwoHandedWeapon:
            if let wp = getEquippedItem(EquipPosition.RightHand){
                if unequip(wp) == false { return notifyFail("你必须先卸下手里的武器。", to: self) }
            }
            if let wp = getEquippedItem(EquipPosition.RightHand) {
                if unequip(wp) == false {
                    if wp is KWeapon { return notifyFail("你必须先卸下左手的武器。", to: self) }
                    return notifyFail("你必须先卸下手里的防具。", to: self)
                }
            }
            eqp.equippedPosition = EquipPosition.RightHand
        case EquipType.HeadArmor:
            return equipTo(eqp, position: EquipPosition.Head)
        case EquipType.Cloth:
            return equipTo(eqp, position: EquipPosition.Body)
        case EquipType.Off_hand:
            if let wp = getEquippedItem(EquipPosition.RightHand) {
                if wp.equipType == EquipType.TwoHandedWeapon {
                    if unequip(wp) == false { return notifyFail("你必须先卸下双手武器。", to: self) }
                }
            }
            return equipTo(eqp, position: EquipPosition.LeftHand)
        default:
            return false
        }
        return true
    }
    
    
    
    func startBerserk(chr: KCreature){
        let msg = processInfomation(berserkMessage[randomInt(berserkMessage.count)], attacker: self, defenser: chr)
        tellRoom(msg, room: self.environment!)
        chr.startFighting(self)
    }
    
    private var _tick = 0
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
        for i in (0..<conditions.count).reverse() {
            if conditions[i].duration == -1 { conditions.removeAtIndex(i) }
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
    func getEffSkillLevel(type: SkillType) -> Int{
        return getActualSkillLevel(type)// in base clas,only return raw level
    }
    
    func getEffSkillLevel(skillname: String) -> Int?{
        return learnedSkills[skillname]?.level
    }
    
    func receiveHeal(type:DamageType, healAmount: Int, from healer: KCreature? = nil){
        lastHealer = healer
        lifeProperty[type]! += healAmount
        if lifeProperty[type]! > lifePropertyMax[type]! { lifeProperty[type] = lifePropertyMax[type] }
    }
    
    func receiveDamage(type:DamageType, damageAmout: Int, from attacker: KCreature? = nil){
        lastDamager = attacker
        if lifeProperty[type]! < 0 { return } //死亡不再受到伤害
        lifeProperty[type]! -= damageAmout
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
    
    func reviveFrom(chr: KCreature? = nil){
        reviver = chr
        for type in DamageType.AllValues {
            lifeProperty[type] = lifePropertyMax[type]
        }
        isGhost = false
        TheWorld.regHeartBeat(self)
    }
    
    override func remove(ent: KEntity) -> Bool {
        if let eq = ent as? KEquipment {
            if eq.equippedPosition != EquipPosition.NONE {
                if unequip(eq) == false { return false }
            }
        }
        return super.remove(ent)
    }
    
    func getActualSkillLevel(type: SkillType) -> Int {
        if let skill = mappedSkills[type] { return skill.level}
        return KSkill._DEFAULT_SKILL_LEVEL
    }
    
    override var allCapacity: Int{
        return min(super.allCapacity, (str * 5 + getActualSkillLevel(SkillType.Unarmed) * 10).KG)
    }
   
    func endAllFighting() {
        rivalList.removeAll()
        isInFighting = false;
    }
    
    func getRandomLimb() -> String{
        return limbs[randomInt(limbs.count)]
    }
    
        
    func resetDamage(){
        damage = str
        if let wp = getEquippedItem(EquipPosition.RightHand) as? KWeapon {
            damage += wp.damage
        }
        if let wp = getEquippedItem(EquipPosition.LeftHand) as? KWeapon {
            damage += wp.damage / 2
        }
    }
    
    func resetArmor(){
        if let inventory = _entities {
            for item in inventory {
                if let ar = item as? KArmor {
                    if ar.equippedPosition != EquipPosition.NONE {
                        armor += ar.armor
                    }
                }
            }
        }
    }
    
    func getEquippedItem(position: EquipPosition) -> KEquipment? {
        guard let inventory = _entities else { return nil }
        for item in inventory {
            let eq = item as? KEquipment
            if let eq = eq {
                if eq.equippedPosition == position { return eq }
            }
        }
        return nil
    }
}

