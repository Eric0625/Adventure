//
//  TheDungeonEngine.swift
//  Adventure
//
//  Created by 苑青 on 2016/11/20.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

///地下城引擎，负责生成迷宫，提供迷宫房间，提供地图
class TheDungeonEngine {
    //MARK: Singleton
    fileprivate init(){
        DEBUG("dungeon engine inited")
        //loadResources()
    }
    static var instance: TheDungeonEngine {
        struct Singleton {
            static let _instance = TheDungeonEngine()
        }
        return Singleton._instance
    }
    private(set) var mazes = [Maze]()

    ///生成一个迷宫，返回该迷宫编号
    func generateMaze(width:Int, height:Int, name:String) -> Int{
        let newMaze = Maze(w: width, h: height, name: name)
        mazes.append(newMaze)
        return mazes.count - 1
    }
    
    func getMazeRoom(mazeNO:Int, x:Int, y:Int) -> MazeCell {
        return mazes[mazeNO][x, y]
    }
}

///迷宫类，每个都代表一个迷宫
///入口在左上角，出口在右下角，坐标轴原点在左上角，横坐标为x，宽度，纵坐标为y，高度
class Maze {
    let name:String
    var cells: [MazeCell]
    let width: Int
    let height: Int
    init(w:Int, h:Int, name:String) {
        cells = Array(repeating: MazeCell(), count: w * h)
        width = w
        height = h
        self.name = name
        //开始生成迷宫
        generate(x: 0, y: 0)
    }
    
    private func generate(x:Int, y:Int) {
        self[x, y].visited = true
        var next = randomInt(999999)
        for i in 0..<4 {
            next = (next + i) % 4
            //print("x is \(x), y is \(y), i is \(i), next is \(next % 4)")
            switch next {
            case 0://北面的墙
                if y - 1 < 0 { break }
                if self[x, y - 1].visited { break }
                self[x, y].top = false
                self[x, y - 1].bottom = false
                generate(x: x, y: y - 1)
            case 1://东面的墙
                if x + 1 >= width { break }
                if self[x + 1, y].visited { break }
                self[x, y].right = false
                self[x + 1, y].left = false
                generate(x: x + 1, y: y)
            case 2://south
                if y+1 >= height { break }
                if self[x, y + 1].visited { break }
                self[x, y].bottom = false
                self[x, y + 1].top = false
                generate(x: x, y: y + 1)
            case 3://west
                if x - 1 < 0 { break }
                if self[x - 1, y].visited { break }
                self[x, y].left = false
                self[x - 1, y].right = false
                generate(x: x - 1, y: y)
            default:
                break
            }
        }
    }
    
    subscript (x:Int, y:Int) -> MazeCell{
        get {
            assert(x < width && x >= 0)
            assert(y < height && y >= 0)
            return cells[y * width + x]
        }
        set {
            assert(x < width && x >= 0)
            assert(y < height && y >= 0)
            cells[y * width + x] = newValue
        }
    }}

///迷宫的一个房间
struct MazeCell {
    var visited = false
    var left = true
    var right = true
    var top = true
    var bottom = true
    var rd:KRoomDescribe?
}
