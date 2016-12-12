//
//  KGaoXiaolinMaze.swift
//  Adventure
//
//  Created by 苑青 on 2016/11/27.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

///小树林迷宫，出口连接清风山迷宫，清风山连接清风寨，聚义厅为最终boss房间，内有密室，救出高小姐后从后山秘道直接滑到山脚，连接稻田回庄
class KGaoXiaolinMaze: KRoom {
    static let WIDTH = 3
    static let HEIGHT = 3
    
    required init(k: KObject) {
        assert(k is KGaoXiaolinMaze)
        super.init(k: k)
    }
    
    required init(roomDescribe d: KRoomDescribe) {
        super.init(roomDescribe: d)
        let maze = TheDungeonEngine.instance.mazes[mazeID]
        //50个怪，1个boss
        let describes = [
            "小林中树木密密麻麻，看不到一个人影。\n",
            "你向前走着，却感到好象有人暗中盯着你。\n",
            "小林中光线昏暗，却偶尔能听到有人说着什么。\n"
        ]
        let maxMonsterNumber = 2
        for y in 0..<KGaoXiaolinMaze.HEIGHT {
            for x in 0..<KGaoXiaolinMaze.WIDTH {
                let currentPoint = TheRoomEngine.instance.fakeRooms.count
                let rd = KRoomDescribe(name: "小树林(\(x),\(y))", id: "双叉岭地下城", ignoreIndex: true)
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
            let x = randomInt(KGaoXiaolinMaze.WIDTH)
            let y = randomInt(KGaoXiaolinMaze.HEIGHT)
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
        //入口
        let zeroRoom = maze[0, 0].rd!
        zeroRoom.linkedRooms[.West] = d
        addLinkedRoom(.East, roomID: zeroRoom.roomID)
        //出口
        let exitRoom = maze.cells.last!.rd!
        TheRoomEngine.instance.linkRoom(exitRoom.roomID, roomid2: TheRoomEngine.instance.roomIndex["高-山路"]!, direction: .East)
    }
    
    var mazeID = TheDungeonEngine.instance.generateMaze(width: KGaoXiaolinMaze.WIDTH, height: KGaoXiaolinMaze.HEIGHT, name: "小树林")
}
