//
//  KSParry.swift
//  Adventure
//
//  Created by 苑青 on 16/5/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KSParry: KSkill {
    
    init(level:Int = 1){
        _unaramedAction = [KSkillAction(describe: "但是被$D格开了。\n"),
                           KSkillAction(describe: "结果被$D挡开了。\n")]
        super.init(name: KSParry.NAME)
        self.level = level
        skillType = .parry
        actions = [KSkillAction(describe: "只听见「锵」一声，被$D的$w格开了。\n"),
                   KSkillAction(describe: "结果「当」地一声被$D的$w挡开了。\n"),
                   KSkillAction(describe: "但是被$D用手中$w架开。\n"),
                   KSkillAction(describe: "但是$D身子一侧，用手中$w格开。\n")]
   }
    
    required init(k: KObject) {
        guard let parry = k as? KSParry else {
            fatalError("Cloning KSParry with unkown object")
        }
        _unaramedAction = deepCopy(parry._unaramedAction)
        super.init(k: k)
    }
    
    static let NAME = "基本招架"
    fileprivate let _unaramedAction: [KSkillAction]
    
    override func getRandomAction() -> KSkillAction {
        guard let o = owner else {return super.getRandomAction()}
        if o.getEquippedItem(EquipPosition.rightHand) != nil { return super.getRandomAction() }
        var a: KSkillAction
        repeat {
            a = _unaramedAction[randomInt(_unaramedAction.count)]
        } while a.skillLevelRequire > level
        return a
    }
}
