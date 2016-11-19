//
//  KSkill.swift
//  Adventure
//
//  Created by 苑青 on 16/4/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KSkill:KObject{
    
    required init(k: KObject) {
        guard let skill = k as? KSkill else {
            fatalError("Init KSkill with unkown object")
        }
        level = skill.level
        subLevel = skill.subLevel
        owner = nil
        actions = deepCopy(skill.actions)
        super.init(k: k)
    }
    
    override init(name: String){
        super.init(name: name)
    }
    
    override func clone() -> KObject{
        return  KSkill(k: self)
    }
    
    //MARK:variables
    static let _DEFAULT_SKILL_LEVEL = 1
    var level = 1
    var subLevel = 0 //达到level＋1的平方后level加1
    var skillType = SkillType.none
    var actions = [KSkillAction]()
    weak var owner:KCreature?
    
    //MARK:functions
    func isValidForMappingWith(_ usage: SkillType) -> Bool { return owner != nil && skillType == usage }
    func isValidForLearn() -> Bool {return owner != nil}
    func isValidForPractice() -> Bool{return owner != nil}
    
    func afterSkillHit(_ someone: KCreature){}
    
    func getRandomAction() -> KSkillAction {
        guard let owner = self.owner else {
            fatalError("no owner when get action")
        }
        if actions.count == 0 {
            return owner.getDefaultAction() //返回所有者的默认招式
        }
        var x = 0
        var act = actions[Int(arc4random_uniform(UInt32(actions.count)))]
        while (act.skillLevelRequire > level || act.name != KSkillAction.NAME) && x < 100 {
            act = actions[Int(arc4random_uniform(UInt32(actions.count)))]
            x += 1
        }
        if x < 100 {
            return act
        } else { return owner.getDefaultAction() }
    }
    
    func improveSubLevel( _ amount: Int ) {
        guard let owner = self.owner else { return }
        var realAmount = amount
        let wiz = owner.wiz / 2
        let count = owner.learnedSkills.count
        if wiz < count {
            realAmount /= count - wiz
        }
        subLevel += realAmount
        if subLevel > (level + 1) * (level + 1) {
            level += 1
            tellPlayer(KColors.HIC + "你的" + name + "进步了！\n" + KColors.NOR, usr: owner)
            subLevel = 0
        }
    }
    
    func getSpecialPerformNames() -> [String]? {
        if actions.isEmpty {return nil}
        var x = [String]()
        for action in actions {
            if action.name != KSkillAction.NAME {
                x.append(action.name)
            }
        }
        if !x.isEmpty { return x }
        return nil
    }
    
    /// 施展一个特定的招式，在基类中什么也不做，只进行标准判断
    func performSpecialAction(_ name: String, toTarget target:KCreature) -> Bool{
        guard let owner = self.owner else { return false }
        if owner.isGhost {return false}
        if owner.isBusy { return notifyFail("你正忙着呢。", to: owner) }
        let act = actions.filter({$0.name == name})[0]
        if act.isInCooldDown { return notifyFail("这个技能还在蓄力中。", to: owner) }
        return true
    }
    
}
