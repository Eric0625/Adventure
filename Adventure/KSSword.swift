//
//  KSSword.swift
//  Adventure
//
//  Created by 苑青 on 16/5/4.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KSSword:KSkill {
    init(level: Int){
        super.init(name: "基本剑法")
        self.level = level
        skillType = .sword
    }
    
    required init(k: KObject) {
        super.init(k: k)
    }

}
