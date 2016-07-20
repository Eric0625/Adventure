//
//  KItem.swift
//  Adventure
//
//  Created by 苑青 on 16/4/27.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KItem: KEntity {
    required init(k: KObject) {
        guard let item = k as? KItem else {
            fatalError("Init KItem with unkown object")
        }
        itemType = item.itemType
        value = item.value
        availableCommands = item.availableCommands
        super.init(k: k)
    }
    
    override init(name: String){
        super.init(name: name)
    }
    
    required convenience init(){
        self.init(name: "普通物品")
    }
    
    override func clone() -> KObject{
        return  KItem(k: self)
    }
    
    var itemType = ItemType.Item
    var value = 0
    var availableCommands = ItemCommands.Normal
    var buyValue: Int { return TheWorld.ME.buyValueOf(self) }
    var sellValue: Int { return TheWorld.ME.sellValueOf(self) }

    private func isPickable() -> Bool {
        //检查user和物品是否在一个房间里
        let room = TheWorld.ME.environment
        var itemRoom = environment
        if itemRoom == nil { return false }
        while itemRoom != room {
            itemRoom = itemRoom!.environment
            if itemRoom == nil { return false }
        }
        return true
    }
    
    func processCommand(cmd: ItemCommands) -> Bool {
        if isPickable() == false {return notifyFail("这件物品已经不在这里了。", to: TheWorld.ME) }
        switch cmd {
        case ItemCommands.Observe:
            givePlayerBrief()
            break
        case ItemCommands.Get:
            if TheWorld.ME.isBusy { return notifyFail("你正忙着呢。", to: TheWorld.ME) }
            if self.moveTo(TheWorld.ME){
                if TheWorld.ME.isInFighting {
                    TheWorld.ME.startBusy(2)
                }
                tellPlayer("你拾取了\(name)", usr: TheWorld.ME)
            }
        default:
            break
        }
        return true
    }
    
    override func givePlayerBrief() {
        var str = "\(name)\n\(describe)\n"
        if let inventroy = _entities {
            let corpse = self as? KCorpse
            if corpse != nil && corpse!.decayPhase == 0
                {str += corpse!.gender.thirdPersonPronounce() + "的遗物有：\n"}
            else {
                str += "里面有：\n"
            }
            for item in inventroy {
                str += KColors.White + item.name + KColors.NOR
            }
        
        }
        TheWorld.broadcast(str)
    }
}