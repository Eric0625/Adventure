//
//  Zones.swift
//  Adventure
//
//  Created by 苑青 on 2016/11/25.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

extension TheRoomEngine {
    func generateCity() {
        var rd = KRoomDescribe(name: "十字街头",id: "十字街头")
        rd.describe = "这里便是长安城的中心，四条大街交汇于此。一座巍峨高大的钟楼耸立于前，很是有些气势。\n每到清晨，响亮的钟声便会伴着淡淡雾气传向长安城的大街小巷。路口车水马龙，来往人潮不断。\n"
        rd.npcLists[NSStringFromClass(KLiBai_City.self)] = 1//李白
        rd.npcLists[NSStringFromClass(KOrdinaryPerson.self)] = 2//路人
        fakeRooms.append(rd)
        rd = KRoomDescribe(name: "白虎大街", id: "白虎大街1")
        rd.describe = "你走在一条宽阔的石板大街上，东面就快到城中心了，可以看到钟楼耸立于前。\n北面静静的是一家书局，来往多是些读书人。\n南面是一家钱庄，整天看见客人进进出出，显得生意很兴隆。\n"
        rd.itemLists[NSStringFromClass(KSteelSword.self)] = 1
        rd.itemLists[NSStringFromClass(KQiMeiGun.self)] = 2
        fakeRooms.append(rd)
        rd = KRoomDescribe(name: "白虎大街", id: "白虎大街2")
        rd.describe = "你走在一条宽阔的石板大街上，东面就快到城中心了，可以看到钟楼\n耸立于前。北边是家大的酒楼，里面唏唏嚷嚷，热闹非凡。而南却是\n家规模不小的寺院，往西就快要出城了。\n"
        rd.itemLists[NSStringFromClass(KMNormal.self)] = 3
        fakeRooms.append(rd)
        rd = KRoomDescribe(name: "白虎大街", id: "白虎大街3")
        rd.describe = "这里已是白虎大街的西段，北面小巷里隐约看到一座大的草堂，堂外\n挂一蓝布幌子，上写一个“卦”字。南面巷中一行歪柳，处处民宅，\n几个小童在巷中玩耍。\n"
        fakeRooms.append(rd)
        rd = KRoomDescribe(name: "三联书局", id: "三联书局")
        rd.describe = "这是一家新开张不久的书局。书架上整整齐齐地放着一些手抄的卷轴。\n雕板印刷书到了唐朝已日趋成熟，因此这里的书架上也放着不少印制\n精美图文并茂的图书。\n"
        rd.isOutDoor = false
        rd.hasWindow = true
        rd.npcLists[NSStringFromClass(KBookSeller_City.self)] = 1
        fakeRooms.append(rd)
        rd = KRoomDescribe(name: "相记钱庄", id: "相记钱庄")
        rd.describe = "这是一家老字号的钱庄，相老板是山西人，这家钱庄从他的爷爷的爷\n爷的爷爷的爷爷那辈开始办起，一直传到他手里，声誉非常好，在全\n国各地都有分店。它发行的银票通行全国。钱庄的门口挂有一块牌子(paizi)。\n"
        rd.isOutDoor = false
        rd.hasWindow = true
        fakeRooms.append(rd)
        rd = KRoomDescribe(name: "青龙大街", id: "青龙大街1")
        rd.describe = "你走在一条宽阔的石板大街上，西面就快到城中心了，可以看到钟楼\n耸立于前。北面是长安武馆，门匾上四个金字闪闪发光。南边是一家\n兵器铺子，是城内的振远镖局开的，专卖一些兵器。\n"
        fakeRooms.append(rd)
        rd = KRoomDescribe(name: "兵器铺", id: "兵器铺")
        rd.describe = "刚一进门就看到兵器架上摆着各种兵器，从上百斤重的大刀到轻如芥\n子的飞磺石，是应有尽有。女老板是老英雄萧振远的小女儿，也是振\n远镖局二老板，巾帼不让须眉。\n"
        rd.npcLists[NSStringFromClass(KXiaoXiao_City.self)] = 1
        rd.isOutDoor = false
        rd.hasWindow = true
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"长安武馆" ,id: "武馆")
        rd.describe = "你现在正站在一个长安武馆的教练场中，地上铺着黄色的细砂，一群\n二十来岁的年轻人正在这里努力地操练着, 还有一个中年汉子在不停\n的喊着号子，让人振奋。\n"
        rd.npcLists[NSStringFromClass(KJiaoTou_City.self)] = 1
        //rd.npcLists[.武馆弟子] = 4
        rd.isOutDoor = false
        rd.hasWindow = true
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"玄武大街" ,id: "玄武大街1")
        rd.describe = "这里的路相当的宽，能容好几匹马车并行，长长的道路通向北方。远远的能看到皇宫的朝阳门。西面是麒麟阁，东边是醉星楼。\n"
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"玄武大街" ,id: "玄武大街2")
        rd.describe = "这里的路相当的宽，能容好几匹马车并行，长长的道路通向北方。远远的能看到皇宫的朝阳门。西面是天监台，东边是国子监。\n"
        fakeRooms.append(rd)
        rd = KRoomDescribe(name: "国子监", id: "国子监")
        rd.describe = "国子监是国家培养高级人才的地方。唐朝的学风很浓，在这里不时可以看到三三两两的学生模样的人大声争辩着什么问题，还有一些老先生门蹙着眉头匆匆走过，象是在思考着什么问题。\n"
        rd.npcLists[NSStringFromClass(KYuanTianGang_City.self)] = 1
        rd.isOutDoor = false
        rd.hasWindow = true
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"双叉岭" ,id: "双叉岭入口")
        rd.describe = "多年生长的荆棘枝条胡乱地向各个方向伸展着，前方是一条杂草丛生的小路，道路蜿蜒曲折看不到尽头。更远处是一道山岭，举目眺望这岭上，真个是寒飒飒雨林风，响潺潺涧下水。香馥馥野花开，密丛丛乱石磊。\n"
        rd.roomClassString = NSStringFromClass(KMazeShuangChaLing.self)
        fakeRooms.append(rd)
        linkRoom(roomIndex["十字街头"]!, roomid2: roomIndex["白虎大街1"]!, direction: .West)
        linkRoom(roomIndex["十字街头"]!, roomid2: roomIndex["相记钱庄"]!, direction: .SWest)
        linkRoom(roomIndex["白虎大街1"]!, roomid2: roomIndex["白虎大街2"]!, direction: .West)
        linkRoom(roomIndex["白虎大街1"]!, roomid2: roomIndex["三联书局"]!, direction: .North)
        linkRoom(roomIndex["白虎大街1"]!, roomid2: roomIndex["相记钱庄"]!, direction: .South)
        linkRoom(roomIndex["白虎大街2"]!, roomid2: roomIndex["白虎大街3"]!, direction: .West)
        linkRoom(roomIndex["十字街头"]!, roomid2: roomIndex["青龙大街1"]!, direction: .East)
        linkRoom(roomIndex["青龙大街1"]!, roomid2: roomIndex["武馆"]!, direction: .North)
        linkRoom(roomIndex["青龙大街1"]!, roomid2: roomIndex["兵器铺"]!, direction: .South)
        linkRoom(roomIndex["十字街头"]!, roomid2: roomIndex["玄武大街1"]!, direction: .North)
        linkRoom(roomIndex["玄武大街1"]!, roomid2: roomIndex["玄武大街2"]!, direction: .North)
        linkRoom(roomIndex["玄武大街2"]!, roomid2: roomIndex["国子监"]!, direction: .East)
        linkRoom(roomIndex["白虎大街3"]!, roomid2: roomIndex["双叉岭入口"]!, direction: .West)
    }
}
