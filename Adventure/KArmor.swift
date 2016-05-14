//
//  KArmor.swift
//  Adventure
//
//  Created by 苑青 on 16/4/30.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KArmor: KEquipment{
    var armor = 0
    required init(k: KObject) {
        guard let ar = k as? KArmor else {
            fatalError("Init KArmor with unkown object")
        }
        armor = ar.armor
        super.init(k: k)
    }
    
    override init(name: String){
        super.init(name: name)
    }
    
    required convenience init(){
        self.init(name: "普通防具")
    }
    
    override func clone() -> KObject{
        return  KArmor(k: self)
    }
    
    override func givePlayerBrief() {
        super.givePlayerBrief()
        tellPlayer("防御：\(armor)", usr: TheWorld.ME)
    }
}