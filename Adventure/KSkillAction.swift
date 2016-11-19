//
//  KSkillAction.swift
//  Adventure
//
//  Created by 苑青 on 16/4/25.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

final class KSkillAction: KObject, WithHeartBeat{
    /// for copy
    required init(k: KObject)
    {
        guard let action = k as? KSkillAction else {
            fatalError("Cloning KSkillAction with unkown object")
        }
        dodgePower = action.dodgePower
        parryPower = action.parryPower
        damageFactor = action.damageFactor
        skillLevelRequire = action.skillLevelRequire
        coolDownTime = action.coolDownTime
        damageActionType = action.damageActionType
        _cdLeft = action._cdLeft
        super.init(k: k)
        if _cdLeft > 0 { TheWorld.regHeartBeat(self) }
    }
    
    
    init(describe:String, actionTypeOfDamage:DamageActionType = DamageActionType.default, requiredLevel lvl:Int = 0, dodge d:Double = 1, parry p:Double = 1, damageFactor dam:Double=1, name:String = NAME, coolDown cd:Int = 0)
    {
        damageActionType = actionTypeOfDamage
        skillLevelRequire = lvl
        dodgePower = d
        parryPower = p
        damageFactor = dam
        coolDownTime = cd
        super.init(name: name)
        self.describe = describe
    }
    
    override func clone() -> KObject{
        return  KSkillAction(k: self)
    }
    //MARK:Vars
    static var defaultAction = KSkillAction(describe: "$A向$N的$l发动了攻击\n")
    static let NAME = "SkillAction"
    let dodgePower: Double//这一招的躲闪加成，进攻招可利用此参数调低对方的躲闪,直接与DP相乘
    let parryPower: Double//这一招的招架加成，进攻招可利用此参数调低对方的招架，直接与DP相乘
    let damageFactor: Double//伤害加成，直接乘到AP上
    var skillLevelRequire: Int//使出这一招需要的技术等级
    let coolDownTime: Int//此特殊招式的CD时间
    fileprivate var _cdLeft = 0
    let damageActionType: DamageActionType
    var isInCooldDown: Bool{
        return _cdLeft != 0
    }

    //MARK:funcs
    func makeOneHeartBeat() {
        if _cdLeft > 0 {
            _cdLeft -= 1
        }
        if _cdLeft == 0 {
            TheWorld.unregHeartBeat(self)
        }
    }
    
    func afterActionTaken(){
        if coolDownTime != 0 {
            _cdLeft = coolDownTime
            TheWorld.regHeartBeat(self)
        }
    }
    
}
