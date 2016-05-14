//
//  KSUnarmed.swift
//  Adventure
//
//  Created by 苑青 on 16/5/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KSUnarmed: KSkill{
    
    init(level:Int = 1){
        super.init(name: KSUnarmed.NAME)
        self.level = level
    }
    
    required init(k: KObject) {
        guard k is KSUnarmed else {
            fatalError("Cloning KSUnarmed with unkown object")
        }
        super.init(k: k)
    }
    
    static let NAME = "空手格斗"
    
    override func isValidForMappingWith(usage: SkillType) -> Bool {
        return usage == SkillType.Unarmed
    }

}