//
//  TheRoomEngine.swift
//  Adventure
//
//  Created by 苑青 on 16/4/27.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class TheRoomEngine {
    
    //MARK: Singleton
    private init(){
        DEBUG("room engine inited")
        initDictionarys()
        //loadResources()
    }
    static var instance: TheRoomEngine {
        struct Singleton {
            static let _instance = TheRoomEngine()
        }
        return Singleton._instance
    }
    //MARK:variables
    var roomDic = [String: Int]()
    var fakeRooms = [KRoomDescribe]()
    var rooms = [Int: KRoom]()
        
    //MARK:functions
    private func initDictionarys() {
        var roomNames = [String]()
        roomNames.append("十字街头")
        roomNames.append("白虎大街1");
        roomNames.append("白虎大街2");
        roomNames.append("白虎大街3");
        roomNames.append("三联书局");
        roomNames.append("相记钱庄");
        roomNames.append("喜福会");
        roomNames.append("袁氏草堂");
        roomNames.append("长安城西门");
        roomNames.append("背阴巷");
        roomNames.append("青龙大街1");
        roomNames.append("兵器铺");
        roomNames.append("武馆");
        var id = 0
        for item in roomNames {
            roomDic[item] = id
            id += 1
        }
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
    private func linkRoom(roomid1:Int, roomid2:Int, direction:Directions){
        let r1 = fakeRooms.filter({$0.roomID == roomid1})[0]
        let r2 = fakeRooms.filter({$0.roomID == roomid2})[0]
        assert(r1.linkedRooms[direction] == nil, "Room \(r1.roomID)已存在该方向：\(direction)")
        r1.linkedRooms[direction] = r2
        let d = direction.OppositeDirection
        assert(r2.linkedRooms[d] == nil, "Room \(r2.roomID)已存在该方向：\(d)")
        r2.linkedRooms[d] = r1
    }
    
    func move(ob: KEntity, toRoomWithRoomID roomid: Int) -> Bool{
        if let room = rooms[roomid] {
            return ob.moveTo(room)
        } else {
            var destRooms = fakeRooms.filter({$0.roomID == roomid})
            if destRooms.isEmpty { return notifyFail("这个地方并不存在。", to: ob) }
            //先生成room
            let room = KRoom(roomDescribe: destRooms[0])
            rooms[roomid] = room
            return ob.moveTo(room)
        }
    }
    
    func moveFrom(origin: KRoom, through direction: Directions, ob: KEntity) -> Bool{
        guard let id = origin.linkedRooms[direction] else {
            return notifyFail("这个方向并不存在。", to: ob)
        }
        if move(ob, toRoomWithRoomID: id) {
            if ob is KCreature {
                tellRoom("\(ob.name)往\(direction.chineseString)离开。", room: origin)
            }
            return true
        }
        return false
    }
    
    //字符串形式的移动
    func moveFrom(origin: KRoom, throughStringDicrection str: String, ob: KEntity) -> Bool {
        if let direction = Directions(rawValue: str) { return moveFrom(origin, through: direction, ob: ob) }
        return false
    }
    
    func generateCity(){
        var rd = KRoomDescribe(name: "十字街头",id: roomDic["十字街头"]!)
        rd.describe = "这里便是长安城的中心，四条大街交汇于此。一座巍峨高大的钟楼耸立于前，很是有些气势。\n每到清晨，响亮的钟声便会伴着淡淡雾气传向长安城的大街小巷。路口车水马龙，来往人潮不断。\n"
        rd.npcLists[NSStringFromClass(KLiBai_City)] = 1//李白
        rd.npcLists[NSStringFromClass(KOrdinaryPerson)] = 2//路人
        fakeRooms.append(rd)
        rd = KRoomDescribe(name: "白虎大街", id: roomDic["白虎大街1"]!)
        rd.describe = "你走在一条宽阔的石板大街上，东面就快到城中心了，可以看到钟楼耸立于前。\n北面静静的是一家书局，来往多是些读书人。\n南面是一家钱庄，整天看见客人进进出出，显得生意很兴隆。\n"
        rd.itemLists[NSStringFromClass(KSteelSword)] = 1
        rd.itemLists[NSStringFromClass(KQiMeiGun)] = 2
        fakeRooms.append(rd)
        rd = KRoomDescribe(name: "白虎大街", id: roomDic["白虎大街2"]!)
        rd.describe = "你走在一条宽阔的石板大街上，东面就快到城中心了，可以看到钟楼\n耸立于前。北边是家大的酒楼，里面唏唏嚷嚷，热闹非凡。而南却是\n家规模不小的寺院，往西就快要出城了。\n"
        fakeRooms.append(rd)
        rd = KRoomDescribe(name: "白虎大街", id: roomDic["白虎大街3"]!)
        rd.describe = "这里已是白虎大街的西段，北面小巷里隐约看到一座大的草堂，堂外\n挂一蓝布幌子，上写一个“卦”字。南面巷中一行歪柳，处处民宅，\n几个小童在巷中玩耍。\n"
        fakeRooms.append(rd)
        rd = KRoomDescribe(name: "三联书局", id: roomDic["三联书局"]!)
        rd.describe = "这是一家新开张不久的书局。书架上整整齐齐地放着一些手抄的卷轴。\n雕板印刷书到了唐朝已日趋成熟，因此这里的书架上也放着不少印制\n精美图文并茂的图书。\n"
        rd.isOutDoor = false
        rd.hasWindow = true
        rd.npcLists[NSStringFromClass(KBookSeller_City)] = 1
        fakeRooms.append(rd)
        rd = KRoomDescribe(name: "相记钱庄", id: roomDic["相记钱庄"]!)
        rd.describe = "这是一家老字号的钱庄，相老板是山西人，这家钱庄从他的爷爷的爷\n爷的爷爷的爷爷那辈开始办起，一直传到他手里，声誉非常好，在全\n国各地都有分店。它发行的银票通行全国。钱庄的门口挂有一块牌子(paizi)。\n"
        rd.isOutDoor = false
        rd.hasWindow = true
        fakeRooms.append(rd)
        rd = KRoomDescribe(name: "青龙大街", id: roomDic["青龙大街1"]!)
        rd.describe = "你走在一条宽阔的石板大街上，西面就快到城中心了，可以看到钟楼\n耸立于前。北面是长安武馆，门匾上四个金字闪闪发光。南边是一家\n兵器铺子，是城内的振远镖局开的，专卖一些兵器。\n"
        fakeRooms.append(rd)
        rd = KRoomDescribe(name: "兵器铺", id: roomDic["兵器铺"]!)
        rd.describe = "刚一进门就看到兵器架上摆着各种兵器，从上百斤重的大刀到轻如芥\n子的飞磺石，是应有尽有。女老板是老英雄萧振远的小女儿，也是振\n远镖局二老板，巾帼不让须眉。\n"
        rd.npcLists[NSStringFromClass(KXiaoXiao_City)] = 1
        rd.isOutDoor = false
        rd.hasWindow = true
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"长安武馆" ,id: roomDic["武馆"]!)
        rd.describe = "你现在正站在一个长安武馆的教练场中，地上铺着黄色的细砂，一群\n二十来岁的年轻人正在这里努力地操练着, 还有一个中年汉子在不停\n的喊着号子，让人振奋。\n"
        rd.npcLists[NSStringFromClass(KJiaoTou_City)] = 1
        //rd.npcLists[.武馆弟子] = 4
        rd.isOutDoor = false
        rd.hasWindow = true
        fakeRooms.append(rd)
        linkRoom(roomDic["十字街头"]!, roomid2: roomDic["白虎大街1"]!, direction: .West)
        linkRoom(roomDic["白虎大街1"]!, roomid2: roomDic["白虎大街2"]!, direction: .West)
        linkRoom(roomDic["白虎大街1"]!, roomid2: roomDic["三联书局"]!, direction: .North)
        linkRoom(roomDic["白虎大街1"]!, roomid2: roomDic["相记钱庄"]!, direction: .South)
        linkRoom(roomDic["白虎大街2"]!, roomid2: roomDic["白虎大街3"]!, direction: .West)
        linkRoom(roomDic["十字街头"]!, roomid2: roomDic["青龙大街1"]!, direction: .East)
        linkRoom(roomDic["青龙大街1"]!, roomid2: roomDic["武馆"]!, direction: .North)
        linkRoom(roomDic["青龙大街1"]!, roomid2: roomDic["兵器铺"]!, direction: .South)
    }
}