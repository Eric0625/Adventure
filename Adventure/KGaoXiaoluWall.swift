//
//  KGaoXiaoluWall.swift
//  Adventure
//
//  Created by 苑青 on 2016/11/27.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KGaoXiaoluWall: KItem {

    required init(){
        super.init(name: "围墙")
        describe = "一道高高的围墙。"
        weight = 1.T
    }
    
    required init(k: KObject) {
        fatalError("init(k:) has not been implemented")
    }
    
    override var availableCommands: [String] {
        get {
            var cmd = super.availableCommands
            cmd.removeFirst(ItemCommands.get)
            cmd.append("翻墙")
            return cmd
        }
    }
    
    override func processCommand(_ cmd: String) -> Bool {
        switch cmd {
        case "翻墙":
            if TheWorld.ME.getEffSkillLevel(.dodge) < 30 {
                tellUser("你纵身跳起，没扒住墙头，栽了个狗啃泥。。。")
                TheWorld.ME.receiveDamage(.kee, damageAmout: Int(TheWorld.ME.kee.toDouble * 0.05))
                tellUser(getStatusMsg(TheWorld.ME, type: .kee))
            } else {
                tellUser("你一扒墙头，翻了过去。")
                TheRoomEngine.instance.move(TheWorld.ME, toRoomWithRoomID: TheRoomEngine.instance.roomIndex["高-后花园"]!)
            }
            return true
        default:
            return super.processCommand(cmd)
        }
    }
}
