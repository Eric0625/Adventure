//
//  KGaoHouHuaYuanWall.swift
//  Adventure
//
//  Created by 苑青 on 2016/11/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KGaoHouHuaYuanWall: KItem {
    static let NAME = "围墙"
    required init(){
        super.init(name: KGaoHouHuaYuanWall.NAME)
        describe = "一道高高的围墙。"
        weight = 1.T
        isInStealth = true
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
                TheRoomEngine.instance.move(TheWorld.ME, toRoomWithRoomID: TheRoomEngine.instance.roomIndex["高-后花园小路"]!)
            }
            return true
        default:
            return super.processCommand(cmd)
        }
    }
}
