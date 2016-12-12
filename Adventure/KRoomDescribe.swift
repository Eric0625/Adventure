//
//  RoomDescribe_t.swift
//  Adventure
//
//  Created by 苑青 on 16/4/27.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation
import UIKit

class KRoomDescribe {
    var linkedRooms = [Directions: KRoomDescribe]()
    var npcLists = [String: Int]()
    var itemLists = [String: Int]()
    var isOutDoor = true
    var hasWindow = true
    private(set) var roomID:Int = -1
    var roomIDInString:String
    var roomClassString:String?
    var name: String
    var describe = ""
    var dungeonID = -1
    var dungeonCoordinate = CGPoint.zero
    init(name:String, id:String, ignoreIndex:Bool = false) {
        self.name = name
        roomIDInString = id
        roomID = TheRoomEngine.instance.newRoomID(roomIdentifier: id, ignoreIndex: ignoreIndex)
    }    
}
