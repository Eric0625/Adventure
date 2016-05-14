//
//  KChouPao.swift
//  Adventure
//
//  Created by 苑青 on 16/5/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KChouPao : KArmor
{
    required init(k: KObject) {
        guard k is KChouPao else {
            fatalError("Cloning KChouPao with unkown object")
        }
       super.init(k: k)
    }
    
    required init()
    {
        super.init(name: "绸袍")
        describe = "一件丝绸长袍，质的和裁剪都不错。"
        value = 600
        weight = 500
        armor = 2
        equipType = .Cloth
    }
    
    override func clone() -> KObject {
        return KChouPao(k: self)
    }
}