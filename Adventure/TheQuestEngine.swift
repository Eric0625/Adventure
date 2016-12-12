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
    if ent is KYuanTianGangYao {
            if var questInfo = TheWorld.ME.questData[01] {
                let killed = questInfo.data.toBool() //是否已杀
                if killed == false {
                    questInfo.data = "true"
                    questInfo.finished = true
                    TheWorld.ME.questData[01] = questInfo
                    tellUser(KColors.YEL + "任务【\(questInfo.name)】完成!" + KColors.NOR)
                }
            }
    } else if ent == nil {
        //派送任务
        if TheWorld.ME.questData.keys.contains(1) == false {
            let room = TheRoomEngine.instance.rooms.random()
            let monster = KYuanTianGangYao()
            monster.moveTo(room)
            let questInfo = STQuestData(name: "杀死\(monster.name)", description: "袁天罡请你在\(room.name)杀死\(monster.name)。", data: "false", finished: false)
            TheWorld.ME.questData[01] = questInfo
            tellUser("袁天罡掐指一算，说道：现有\(monster.name)在\(room.name)附近为非作歹，请\(rankRespect(TheWorld.ME))前往铲除妖孽！")
            tellUser(KColors.YEL + "你接受了杀怪任务。" + KColors.NOR)
        } else {
            if TheWorld.ME.questData[01]?.finished == false {
                return notifyFail("袁天罡皱了皱眉头：还请\(rankRespect(TheWorld.ME))速去铲除妖孽。", to: TheWorld.ME)
            }
            return notifyFail("你已经完成了这个任务。", to: TheWorld.ME)
        }
    }
    return true
}

class TheQuestEngine {
    
    //MARK: Singleton
    fileprivate init(){
        DEBUG("quest engine inited")
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

