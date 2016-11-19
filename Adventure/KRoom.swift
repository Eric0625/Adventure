//
//  KRoom.swift
//  Adventure
//
//  Created by 苑青 on 16/4/27.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class KRoom: KEntity, WithHeartBeat{
    
    required init(k: KObject) {
        fatalError("房间不支持克隆")
    }
    
    fileprivate func initializeLocalItem(_ itemClass: String){
        let type = NSClassFromString(itemClass) as! KItem.Type
        let real = type.init()        
        itemRestoreClassString[real.guid] = itemClass
        assert(super.accept(real))//作为特殊处理，这里不使用本房间的accept函数以跳过销毁物品的步骤
    }
    
    convenience init(roomDescribe d:KRoomDescribe){
        self.init(name: d.name, roomDescribe: d)
        isOutDoor = d.isOutDoor
        hasWindow = d.hasWindow
        for (npcClassString, npcNumber) in d.npcLists {
            if let npcClassType = NSClassFromString(npcClassString) as? KNPC.Type {
                for _ in 0..<npcNumber {
                    let real = npcClassType.init()
                    assert(accept(real))
                    real.startRoomID = d.roomID
                }
            }
        }
        for (itemClassString, itemNumber) in d.itemLists {
                for _ in 0..<itemNumber {
                    initializeLocalItem(itemClassString)
                }
        }
        for (direction, roomDescribe) in d.linkedRooms {
            addLinkedRoom(direction, roomID: roomDescribe.roomID)
        }        
        describe = d.describe
        itemStayDuration = 300
        
    }
    
    init(name:String = KRoom.NAME, roomDescribe d: KRoomDescribe? = nil){
        roomDesc = d
        super.init(name: name)
        selfCapacity = 1000.T        
    }
    
    required convenience init(){
        self.init(name: KRoom.NAME)
    }
    
    override func clone() -> KObject{
        return  KRoom(k: self)
    }
    
    //MARK:variables
    class var NAME:String { return  "一个普通的房间" }
    var itemStayDuration = 300//物品留存时间，默认5分钟
    var itemRestoreInterval = 1800//物品刷新时间，一小时
    var exits = [Directions]()
    var exitsInString = [String]()
    var itemDestroyTimeStamp: [Guid: Int]?//物品摧毁时间戳，key为物品guid，value为计时
    var itemRestoreTimeStamp: [Guid: Int]?//物品重新生成的时间戳
    var itemRestoreClassString = [Guid: String]()//需要恢复的物品所对应的类字符串
    fileprivate let roomDesc:KRoomDescribe?
    var linkedRooms = [Directions:Int]()//与该房间链接的房间,value为该房间ID
    var isOutDoor = true
    var hasWindow = false
    var title:String {
        get { return KColors.HIY + name + KColors.NOR }
    }
    
    //MARK:functions
    func addLinkedRoom(_ direction:Directions, roomID:Int){
        //let link = "<a href=d:\(direction)>" + KColors.HIW +  direction.chineseString + KColors.NOR + "</a>"
        let link = KColors.HIW + direction.chineseString + KColors.NOR
        exitsInString.append(link)
        exits.append(direction)
        linkedRooms[direction] = roomID
    }
    
    fileprivate func prepareItemDestroy(_ item: KItem){
        TheWorld.regHeartBeat(self)
        if itemDestroyTimeStamp == nil {
            itemDestroyTimeStamp = [:]
        }
        itemDestroyTimeStamp![item.guid] = 0//开始计算物品存留时间，拿起又放下的物品重新计算时间
    }
    
    fileprivate func interruptItemDestroy(_ itemGuid: Guid){
        itemDestroyTimeStamp![itemGuid] = nil
        if itemDestroyTimeStamp!.isEmpty {
            itemDestroyTimeStamp = nil
        }
        if itemDestroyTimeStamp == nil && itemRestoreTimeStamp == nil {
            TheWorld.unregHeartBeat(self)
        }
    }
    
    fileprivate func prepareItemRestore(_ item: KItem){
        TheWorld.regHeartBeat(self)
        if itemRestoreTimeStamp == nil {
            itemRestoreTimeStamp = [:]
        }
        itemRestoreTimeStamp![item.guid] = 0
    }
    
    fileprivate func interruptItemRestore(_ itemGuid:Guid){
        itemRestoreTimeStamp![itemGuid] = nil
        if itemRestoreTimeStamp!.isEmpty {
            itemRestoreTimeStamp = nil
        }
        if itemDestroyTimeStamp == nil && itemRestoreTimeStamp == nil {
            TheWorld.unregHeartBeat(self)
        }
    }
    
    func isNativeItem(_ item: KItem) -> Bool {
        return itemRestoreClassString.keys.contains(item.guid)
    }
    
    ///所有自定义了触发事件的房间都应该重载这个函数，当用户进入时发生事件
    override func accept(_ ent: KEntity) -> Bool {
        guard super.accept(ent) else { return false}
        if let chr = ent as? KCreature {
            if !(chr is KUser) && !chr.isGhost {
                tellRoom(chr.name + "走了过来", room: self) //todo:加上坐骑和战斗信息
                TheWorld.didUpdateRoomInfo(self, ent: chr, type: .newEntity)//提醒代理发生了房间更新事件
            }
            if let user = chr as? KUser {
                if TheWorld.ME.isInFighting {
                    tellPlayer("你跌跌撞撞地跑到了\(name)", usr: TheWorld.ME)
                } else {
                    tellPlayer("你来到了\(name)", usr: TheWorld.ME)
                }
                TheWorld.didUpdateRoomInfo(self)//提醒代理发生了房间更新事件
                if let inventory = _entities {
                    for entInRoom in inventory {
                        if let npc = entInRoom as? KNPC {
                            npc.interactWith(user)
                        }
                    }
                }
            }
        }else if let item = ent as? KItem {
            if !isNativeItem(item) {
                prepareItemDestroy(item) //不是房间里原本的物品，需要丢弃
            } else {
                interruptItemRestore(item.guid)
            }
            TheWorld.didUpdateRoomInfo(self, ent: item, type: .newEntity)
        }
        return true
    }
    
    override func remove(_ ent: KEntity) -> Bool {
        guard super.remove(ent) else { return false }
        if let item = ent as? KItem {
            if isNativeItem(item){
                //是原有物品
                prepareItemRestore(item)
            } else {
                interruptItemDestroy(item.guid)
            }

        }
        TheWorld.didUpdateRoomInfo(self, ent: ent, type: .removeEntity)
        return true
    }
    
    func getLongDescribe() -> String {
//        var msg = KColors.HIR + "〖" + KColors.NOR + name +
//            KColors.HIR + "〗" + KColors.NOR + "\n\n" + describe;
        var msg = describe
        if exits.count != 0 {
            if exits.count == 1 {
                msg += "\n    这里唯一的出口是："+exitsInString[0]
            } else {
                msg += "\n    这里明显的出口是："
                msg += exitsInString[0..<exitsInString.count-1].joined(separator: "、")
                msg += "和" + exitsInString.last!
            }
        }
        return msg
    }
    
    func makeOneHeartBeat() {
        if var destroy = itemDestroyTimeStamp {
            for (u, _) in destroy {
                itemDestroyTimeStamp![u] = itemDestroyTimeStamp![u]! + 1
                if destroy[u] > itemStayDuration {
                    let item = _entities!.filter({$0.guid == u})[0]
                    assert(remove(item))
                    tellRoom("一阵风吹过，\(item.name)化为灰尘消失不见了。", room: self)
                    item.environment = nil
                }
            }
        }
        if var restore = itemRestoreTimeStamp {
            for (u, _) in restore {
                itemRestoreTimeStamp![u] = itemRestoreTimeStamp![u]! + 1
                if restore[u] == itemRestoreInterval {
                    //从物品池生成新物品
                    initializeLocalItem(itemRestoreClassString[u]!)
                    itemRestoreClassString[u] = nil //作为引子的原物品不再认为是该房间原有的物品，进入后一样被摧毁
                    interruptItemRestore(u)
                }
            }
        }
    }
    
}
