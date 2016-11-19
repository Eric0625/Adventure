//
//  TheQuestEngine.swift
//  Adventure
//
//  Created by 苑青 on 2016/11/17.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

///杀怪任务
///只杀一个特定的怪
fileprivate func quest01(ent: KObject?) -> Bool{
    if let monster = ent as? KNPC {
        if monster.name == "xxx" {
            if var questInfo = TheWorld.ME.questData[01] {
                let killed = questInfo.data.toBool() //是否已杀
                if killed == false {
                    questInfo.data = "true"
                    questInfo.description = "杀死xx（已完成）"
                }
            }
        }
    } else if ent == nil {
        //派送任务
        if TheWorld.ME.questData.keys.contains(1) == false {
            let room = TheRoomEngine.instance.rooms.random()
            let questInfo = STQuestData(name: "杀死xxx", description: "在\(room.name)杀死xxx", data: "false", finished: false)
            TheWorld.ME.questData[01] = questInfo
            tellPlayer("袁天罡掐指一算，说道：现有xxx在\(room.name)为非作歹，请\(rankRespect(TheWorld.ME))前往铲除妖孽！", usr: TheWorld.ME)
            tellPlayer(KColors.YEL + "你接受了杀怪任务。" + KColors.NOR, usr: TheWorld.ME)
        } else {
            return notifyFail("你已经有这个任务了。", to: TheWorld.ME)
        }
    }
    return true
}

class TheQuestEngine {
    
    //MARK: Singleton
    fileprivate init(){
        DEBUG("room engine inited")
        //loadResources()
    }
    static var instance: TheQuestEngine {
        struct Singleton {
            static let _instance = TheQuestEngine()
        }
        return Singleton._instance
    }
    
    private let questData:[Int: (KObject?)->Bool] = [
        1: quest01
    ]
    
    func processQuest(sender:KObject, questID: Int) -> Bool{
        if let handle = questData[questID] {
            return handle(sender)
        }
        return false
    }
    
    func assignQuest(questID: Int) -> Bool{
        if let handle = questData[questID] {
            return handle(nil)
        }
        return false
    }
}

