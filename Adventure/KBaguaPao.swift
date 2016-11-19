//
//  KBaguaPao.swift
//  Adventure
//
//  Created by Eric on 16/11/18.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation
class KBaguaPao : KArmor
{
    required init(k: KObject) {
        guard k is KBaguaPao else {
            fatalError("Cloning KBaguaPao with unkown object")
        }
        super.init(k: k)
    }
    
    required init()
    {
        super.init(name: "八卦道袍")
        describe = "一件对襟道袍，上面工整地绣着八卦图。"
        value = 200
        weight = 500
        armor = 3
        equipType = .cloth
        definedEquipPosition = .body
    }
    
    override func clone() -> KObject {
        return KBaguaPao(k: self)
    }
}
