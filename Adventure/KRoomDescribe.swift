//
//  RoomDescribe_t.swift
//  Adventure
//
//  Created by 苑青 on 16/4/27.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KRoomDescribe:KObject {
    var linkedRooms = [Directions: KRoomDescribe]()
    var npcLists = [String: Int]()
    var itemLists = [String: Int]()
    var isOutDoor = true
    var hasWindow = true
    var roomID = -1
    

    init(name:String, id:Int){
        super.init(name: name)
        self.name = name
        roomID = id
    }
    
    required init(k: KObject) {
        fatalError("room desc can't be cloned!")
    }
    
    override func clone() -> KObject{
        return  KNPC(k: self)
    }
}