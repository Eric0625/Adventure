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
        super.init(k: k)
    }
    
    override init(name: String){
        super.init(name: name)
    }
    
    ///该初始化函数是作为动态载入物品时的必需调用出现的
    required convenience init(){
        self.init(name: "普通物品")
    }
    
    override func clone() -> KObject{
        return  KItem(k: self)
    }
    
    var itemType = ItemType.item
    var value = 0
    var availableCommands: [String] {
        get {
            //对于一般物品来说，可用命令只有丢弃，拾取和观察，其它命令需要各自类别物品自己重载
            var cmds = [String]()
            if environment === TheWorld.ME { cmds.append(ItemCommands.drop) }
            else { cmds.append(contentsOf: [ItemCommands.get, ItemCommands.observe]) }
            if _entities?.isEmpty == false {
                cmds.append(ItemCommands.getAll)
            }
            return cmds
        }
    }
    var buyValue: Int { return TheWorld.ME.buyValueOf(self) }
    var sellValue: Int { return TheWorld.ME.sellValueOf(self) }

    fileprivate func isPickable() -> Bool {
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
    
    ///处理可用命令，这里要根据是否在玩家身上进行调整
    ///当不知道该命令如何处理时，应返回真，返回假表示处理失败
    @discardableResult func processCommand(_ cmd: String) -> Bool {
        
        switch cmd {
        case ItemCommands.observe:
            if isPickable() == false {return notifyFail("这件物品已经不在这里了。", to: TheWorld.ME) }
            tellUser(describe)
            break
        case ItemCommands.get:
            if isPickable() == false {return notifyFail("这件物品已经不在这里了。", to: TheWorld.ME) }
            if TheWorld.ME.isBusy { return notifyFail("你正忙着呢。", to: TheWorld.ME) }
            if self.moveTo(TheWorld.ME){
                if TheWorld.ME.isInFighting {
                    TheWorld.ME.startBusy(2)
                }
                tellUser("你拾取了\(name)")
            }
        case ItemCommands.drop:
            if environment !== TheWorld.ME { return notifyFail("这件物品不在你身上", to: TheWorld.ME) }
            if TheWorld.ME.isBusy { return notifyFail("你正忙着呢。", to: TheWorld.ME) }
            if let env = TheWorld.ME.environment {
                if self.moveTo(env) {
                    if TheWorld.ME.isInFighting {
                        TheWorld.ME.startBusy(5)
                    }
                    tellUser("你将\(name)丢在\(env.name)")
                } else {
                    return notifyFail("物品\(name)丢弃失败。", to: TheWorld.ME)
                }
            } else {
                return notifyFail("你并没有地方可丢弃这件物品", to: TheWorld.ME)
            }
        case ItemCommands.getAll :
            //取出所有内容物，逐一放到玩家身上
            if let inv = _entities {
                for ent in inv {
                    if ent.moveTo(TheWorld.ME) {
                        tellPlayer("你拾取了\(ent.name)", usr: TheWorld.ME)
                    }
                }
            }
        default:
            break
        }
        return true
    }
    
    override var describe: String {
        set {
            super.describe = newValue
        }
        get {
            var str = "\(name)\n\(super.describe)\n重量：\(weight)克\n"
            if let inventroy = _entities {
                let corpse = self as? KCorpse
                if corpse != nil && corpse!.decayPhase == 0
                    { str += corpse!.gender.thirdPersonPronounce + "的遗物有：\n" }
                else {
                    str += "里面有：\n"
                }
                for item in inventroy {
                    str += KColors.White + item.name + KColors.NOR + "\n"
                }
            }
            return str
        }
    }
}
