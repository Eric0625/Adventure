//
//  TheRoomEngine.swift
//  Adventure
//
//  Created by 苑青 on 16/4/27.
//  Copyright © 2016年 Eric. All rights reserved.
//  本游戏房间设计原则：普通房间直接写入roomdescribe类即可，自定义房间有两种方式：一种直接实现init，并在代码中独立实例化并使用之，第二种是实现init的roomdesribe调用，并将roomdescribe类的roomclassstring赋值成该房间类
//第一种的好处是实现简单，一般用于进入方式为非走动的情况，如只能传送到的房间（死亡点），但其生存周期由引擎独立维护，与其它房间分开，所以只用于一些特殊房间。第二种的好处是可与标准房间无缝连接，代码维护也相对集中，同时生命周期也保持了与标准房间的一致

import Foundation

class TheRoomEngine {
    
    //MARK: Singleton
    fileprivate init(){
        DEBUG("room engine inited")
    }
    static var instance: TheRoomEngine {
        struct Singleton {
            static let _instance = TheRoomEngine()
        }
        return Singleton._instance
    }
    //MARK:variables
    ///值为room的唯一id，从“1”开始！，key为room的唯一文字标示，不可重复，主要用于可读性，只在初始化时使用
    private(set) var roomIndex = [String: Int]()
    var fakeRooms = [KRoomDescribe]()
    private(set) var rooms = [Int: KRoom]()
    private var roomIDPool = 1
    ///特殊房间，如墓地，虚空等，定期销毁
    private var specialRooms = [KRoom]()
    //MARK:functions
    
    ///获取roomid，并将之加入索引
    func newRoomID(roomIdentifier: String, ignoreIndex: Bool = false) -> Int {
        if ignoreIndex == false {
            assert(roomIndex.keys.contains(roomIdentifier) == false)
            roomIndex.updateValue(roomIDPool, forKey: roomIdentifier)
        }
        roomIDPool += 1
        return roomIDPool - 1
    }
    
    func loadResources() {
//        var npcs: [KNPC] = [KLiBai_City(),
//                           KOrdinaryPerson(),
//                           KBookSeller_City(),
//                           KJiaoTou_City(),
//                           KXiaoXiao_City()]
//        let npc = KHuman(name: "武馆弟子", npcID: .武馆弟子)
//        npc.age = 18+randomInt(25)
//        npc.mapSkill(KSParry(level: 10), inType: .Parry)
//        npc.mapSkill(KSUnarmed(level: 10), inType: .Unarmed)
//        npc.describe = "你看到一位身材高大的汉子，正在辛苦地操练着。\n"
//        npc.per = 5 + randomInt(20)
//        npc.combatExp = 4000
//        let c = KCloth()
//        c.moveTo(npc)
//        npc.equip(c)
//        npcs.append(npc)
//        for n in npcs {
//            npcPool[n.ID] = n
//        }
//    //items
//        let items:[KItem] = [KSteelSword(), KQiMeiGun()]
//        for i in items {
//            itemPool[i.ID] = i
//        }
    }
    
    /// 链接两个房间，direction是指从r1到r2，因此r2到r1是反过来的
    func linkRoom(_ roomid1:Int, roomid2:Int, direction:Directions){
        let r1 = fakeRooms.filter({$0.roomID == roomid1})[0]
        let r2 = fakeRooms.filter({$0.roomID == roomid2})[0]
        assert(r1.linkedRooms[direction] == nil, "Room \(r1.roomID)已存在该方向：\(direction)")
        r1.linkedRooms[direction] = r2
        let d = direction.OppositeDirection
        assert(r2.linkedRooms[d] == nil, "Room \(r2.roomID)已存在该方向：\(d)")
        r2.linkedRooms[d] = r1
    }
    
    ///移动物体到某个实体房间，由于房间必须有外指针引用才不会被销毁，所以任何传送到某个独立房间的行为都必须调用此功能
    func move(_ ob:KEntity, toRoom room: KRoom) -> Bool {
        if specialRooms.contains(where: {$0.guid == room.guid}) == false {
            specialRooms.append(room)
        }
        return ob.moveTo(room)
    }
    
    @discardableResult func move(_ ob: KEntity, toRoomWithRoomID roomid: Int) -> Bool{
        if let room = rooms[roomid] {
            return ob.moveTo(room)
        } else {
            var destRooms = fakeRooms.filter({$0.roomID == roomid})
            if destRooms.isEmpty { return notifyFail("这个地方并不存在。", to: ob) }
            //先生成room
            let roomDesc = destRooms[0]
            var room:KRoom!
            if let roomClass = roomDesc.roomClassString {
                let special = NSClassFromString(roomClass) as! KRoom.Type
                room = special.init(roomDescribe: destRooms[0])
            } else {
                room = KRoom(roomDescribe: destRooms[0])
            }
            rooms[roomid] = room
            return ob.moveTo(room)
        }
    }
    
    func moveFrom(_ origin: KRoom, through direction: Directions, ob: KEntity) -> Bool{
        guard let id = origin.linkedRooms[direction] else {
            return notifyFail("这个方向并不存在。", to: ob)
        }
        if origin.canMoveTo(direction: direction, entity: ob) == false {
            return false
        }
        if move(ob, toRoomWithRoomID: id) {
            if let cob = ob as? KCreature {
                if cob.isInFighting {
                    tellRoom("\(ob.name)往\(direction.chineseString)落荒而逃了!", room: origin)
                } else {
                    tellRoom("\(ob.name)往\(direction.chineseString)离开。", room: origin)
                }
                //TheWorld.didUpdateRoomInfo(origin, ent: ob, type: .RemoveEntity)
            }
            return true
        }
        return false
    }
    
    //字符串形式的移动
    func moveFrom(_ origin: KRoom, throughStringDicrection str: String, ob: KEntity) -> Bool {
        if let direction = Directions.fromString(str: str) { return moveFrom(origin, through: direction, ob: ob) }
        return false
    }

}
