//
//  JiangZhouZone.swift
//  Adventure
//
//  Created by Eric on 16/11/29.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation
extension TheRoomEngine {
    func createJZ(){
        var rd = KRoomDescribe(name: "土路",id: "jz-土路1")
        rd.describe = "路上人不是很多，偶尔有几个过客．前方是一个小镇，镇上有一户高姓人家，却是这方圆百里土地的主人．附近的农民大多是靠租高家的田度日。\n"
        //rd.npcLists[NSStringFromClass(KLiBai_City.self)] = 1//李白
        //rd.npcLists[NSStringFromClass(KOrdinaryPerson.self)] = 2//路人
        fakeRooms.append(rd)
        rd = KRoomDescribe(name:"街道" ,id: "高-街道1")
        rd.describe = "进到镇中人似乎多了些，也有些做小买卖的．青青的石板铺在路上，延续到镇的另一端。\n"
        fakeRooms.append(rd)
    }
}
