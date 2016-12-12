//
//  KMazeShuangChaLing.swift
//  Adventure
//
//  Created by 苑青 on 2016/11/21.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation
import UIKit

class KMazeShuangChaLing: KRoom {
    static let WIDTH = 4
    static let HEIGHT = 5
    
    required init(k: KObject) {
        assert(k is KVoidRoom)
        super.init(k: k)
    }
    
    required init(roomDescribe d: KRoomDescribe) {
        super.init(roomDescribe: d)
        let maze = TheDungeonEngine.instance.mazes[mazeID]
        //50个怪，1个boss
        let describes = [
            "岭上参天古树，漫路荒藤。万壑风尘冷，千崖气象奇。\n",
            "但见一径野花香袭体，数竿幽竹绿依依。石板桥，白土壁，真乐真稀。秋容萧索，爽气孤高。\n",
            "幽深的峡谷之中，升腾着神鬼莫测的氤氲山气，边沿是陡峭的悬崖，悬崖上怪松搭棚，古藤蟠缠。\n"
        ]
        let maxMonsterNumber = 50
        for y in 0..<KMazeShuangChaLing.HEIGHT {
            for x in 0..<KMazeShuangChaLing.WIDTH {
                let currentPoint = TheRoomEngine.instance.fakeRooms.count
                let rd = KRoomDescribe(name: "双叉岭(\(x),\(y))", id: "双叉岭地下城")
                rd.describe = describes[randomInt(describes.count)]
                rd.dungeonID = mazeID
                rd.dungeonCoordinate = CGPoint(x: x, y: y)
                let cell = maze[x, y]
                if cell.top == false {
                    let rd2 = TheRoomEngine.instance.fakeRooms[currentPoint - KMazeShuangChaLing.WIDTH]
                    rd.linkedRooms[.North] = rd2
                    rd2.linkedRooms[.South] = rd
                }
                if cell.left == false {
                    let rd2 = TheRoomEngine.instance.fakeRooms[currentPoint - 1]
                    rd.linkedRooms[.West] = rd2
                    rd2.linkedRooms[.East] = rd
                }
                maze[x,y].rd = rd
                TheRoomEngine.instance.fakeRooms.append(rd)
            }
        }
        let monsterString = NSStringFromClass(KShuangChaLingMonster.self)
        let bossString1 = NSStringFromClass(KShuangChaLingBoss1.self)
        for i in 0...maxMonsterNumber {
            let x = randomInt(KMazeShuangChaLing.WIDTH)
            let y = randomInt(KMazeShuangChaLing.HEIGHT)
            var npcString = ""
            if i == 0 {
                npcString = bossString1
                print("boss坐标：\(x), \(y)")
            } else {
                npcString = monsterString
            }
            if let rd = maze[x, y].rd {
                if let number = rd.npcLists[npcString] {
                    rd.npcLists[npcString] = number + 1
                } else {
                    rd.npcLists[npcString] = 1
                }
            }
        }
        let zeroRoom = TheRoomEngine.instance.fakeRooms.last!
        zeroRoom.linkedRooms[Directions.East] = d
        addLinkedRoom(.West, roomID: zeroRoom.roomID)
    }
    
    var mazeID = TheDungeonEngine.instance.generateMaze(width: KMazeShuangChaLing.WIDTH, height: KMazeShuangChaLing.HEIGHT, name: "双叉岭")
}
