//
//  WorldMessageBoardView.swift
//  Adventure
//
//  Created by 苑青 on 16/5/13.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

class WorldMessageBoardView: UITextView, CircleMenuDelegate {

    let circle:CircleMenu!
    let items: [(position: Directions, color: UIColor)] = [
        (.North, UIColor(red:0.19, green:0.57, blue:1, alpha:0.8)),
        (.NEast, UIColor(red:0.22, green:0.74, blue:0, alpha:0.8)),
        (.East, UIColor(red:0.96, green:0.23, blue:0.21, alpha:0.8)),
        (.SEast, UIColor(red:0.51, green:0.15, blue:1, alpha:0.8)),
        (.South, UIColor(red:1, green:0.39, blue:0, alpha:0.8)),
        (.SWest, UIColor(red:0.5, green:0.39, blue:0.5, alpha:0.8)),
        (.West, UIColor(red:1, green:0.39, blue:0.8, alpha:0.8)),
        (.NWest, UIColor(red:0, green:0.39, blue:0.6, alpha:0.8)),
        ]
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        circle = CircleMenu(
            frame: CGRectMake(0, 0, 40, 40),
            normalIcon:"icon_menu",
            selectedIcon:"icon_close",
            buttonsCount: 8,
            duration: 4,
            distance: 80)
        super.init(frame: frame, textContainer: textContainer)
        backgroundColor = UIColor.blackColor()
        font = UIFont.Font(.Avenir, type: .Regular, size: 20)
        createMenu()
    }
    
    required init?(coder aDecoder: NSCoder) {
        circle = nil
        super.init(coder: aDecoder)
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touches.count == 1 {
            let t = touches.first!
            let point = t.locationInView(self)
            circle.frame = CGRectMake(point.x - 20, point.y - 20, 40, 40)
            circle.onTap()
        }
    }
    
    func createMenu(){
        circle.delegate = self
        circle.layer.cornerRadius = circle.frame.size.width / 2.0
        self.addSubview(circle)
        circle.hidden = true
    }

    var inventoryIndex:Int = 0
    func circleMenu(circleMenu: CircleMenu, willDisplay button: CircleMenuButton, atIndex: Int) {
        if atIndex == 0 {inventoryIndex = 0}
        button.backgroundColor = items[atIndex].color
        button.hidden = true
        if let room = TheWorld.ME.environment as? KRoom {
            //先设置方向
            if room.exits.contains(items[atIndex].position) {
                button.setTitle(items[atIndex].position.chineseString, forState: .Normal)
                button.hidden = false
                button.gameDirection = items[atIndex].position
                button.gameObject = nil
            } else {//空闲的方向显示人物和物体
                //人物
                guard let inv = room._entities else {
                    return
                }
                while (inventoryIndex < inv.count) {
                    var addable = true
                    if inv[inventoryIndex] is KUser { addable = false }
                    else if let npc = inv[inventoryIndex] as? KNPC {
                        if !npc.visible { addable = false }
                    }
                    if addable {
                        button.setTitle(inv[inventoryIndex].name[0...1], forState: .Normal)
                        button.hidden = false
                        button.gameObject = inv[inventoryIndex]
                        button.gameDirection = nil
                        inventoryIndex += 1
                        break
                    }
                    inventoryIndex += 1
                }
            }
        }else{
            button.setTitle("test", forState: .Normal)
        }
    }
    
    func circleMenu(circleMenu: CircleMenu, buttonDidSelected button: CircleMenuButton, atIndex: Int) {
        if let direct = button.gameDirection {
            //点击了方向
            let user = TheWorld.ME
            if user.isGhost { return }
            if user.isBusy {
                tellPlayer("你正忙着呢。", usr: user)
                return
            }
            if let room = user.environment as? KRoom {
                TheRoomEngine.instance.moveFrom(room, through: direct, ob: user)
            }
        }
    }
}
