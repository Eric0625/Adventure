//
//  KSDodge.swift
//  Adventure
//
//  Created by 苑青 on 16/5/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KSDodge: KSkill {
    
    init(level:Int = 1){
        super.init(name: KSDodge.NAME)
        self.level = level
        actions = [KSkillAction(describe: "$D一闪，躲开了$A的攻击\r\n"),
                   KSkillAction(describe: "$D身子一侧，$A的攻击便落了空\r\n")]
        //skillType =
    }
    
    required init(k: KObject) {
        guard k is KSDodge else {
            fatalError("Cloning KSDodge with unkown object")
        }
        super.init(k: k)
    }
    
    static let NAME = "基本躲闪"
    
    override func getRandomAction() -> KSkillAction {
        //todo 重型盔甲降低躲闪
        return super.getRandomAction()
    }
    
    override func isValidForMappingWith(usage: SkillType) -> Bool {
        return usage == SkillType.Dodge
    }
}