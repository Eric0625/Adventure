//
//  KBookSeller.swift
//  Adventure
//
//  Created by 苑青 on 16/5/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KBookSeller_City: KSalesMan {
    
    required init(){
        super.init(name: "孔方兄")
        title = "书店老板"
        describe = "孔秀才入京赶考落第，盘缠用尽，无法还乡，\n不得已在长安开一家书店。传说他曾遇异人，\n学得一些防身之术。"
        availableCommands.removeFirst(NPCCommands.kill)
        availableCommands.removeFirst(NPCCommands.give)
        age = 40
    }
    
    required init(k: KObject) {
        guard k is KBookSeller_City else {
            fatalError("Cloning KBookSeller with unkown object")
        }
        super.init(k: k)
    }
    
    override func greeting(_ usr: KUser) {
        super.greeting(usr)
        if let env = environment {
            tellRoom("孔方兄说道：这位" + rankRespect(usr) + "，快请进。\n", room: env)
        }
    }
    
    override func clone() -> KObject {
        return KBookSeller_City(k: self)
    }
}
