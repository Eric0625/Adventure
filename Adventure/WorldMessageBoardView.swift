//
//  WorldMessageBoardView.swift
//  Adventure
//
//  Created by 苑青 on 16/5/13.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

//废弃
class WorldMessageBoardView: UITextView, CircleMenuDelegate {

    let circleMain:CircleMenu!
    ///disable second menu
    //let circleSecond: CircleMenu!

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
        circleMain = CircleMenu(
            frame: CGRect(x: 0, y: 0, width: 5, height: 5),
            normalIcon:"icon_menu",
            selectedIcon:"icon_close",
            buttonsCount: 8,
            duration: 4,
            distance: 55)
//        circleSecond = CircleMenu(
//            frame: CGRect(x: 0, y: 0, width: 40, height: 40),
//            normalIcon:"icon_menu",
//            selectedIcon:"icon_close",
//            buttonsCount: 10,
//            duration: 4,
//            distance: 100)
        super.init(frame: frame, textContainer: textContainer)
        backgroundColor = UIColor.black
        font = UIFont.Font(.Avenir, type: .Regular, size: 20)
        //createMenu()
    }
    
    required init?(coder aDecoder: NSCoder) {
        circleMain = CircleMenu(coder: aDecoder)
        //circleSecond = CircleMenu(coder: aDecoder)
        super.init(coder: aDecoder)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 1 {
            let t = touches.first!
            let point = t.location(in: circleMain.superview!)
            circleMain.frame = CGRect(x: point.x - 20, y: point.y - 20, width: 40, height: 40)
            circleMain.onTap()
//            if circleSecond.buttonsIsShown() {
//                circleSecond.isHidden = true
//                circleSecond.hideButtons(0)
//            }
        }
        super.touchesEnded(touches, with: event)
    }
    
    func createMenu(_ view:UIView){
        circleMain.delegate = self
        circleMain.layer.cornerRadius = circleMain.frame.size.width / 2.0
        view.addSubview(circleMain)
        circleMain.isHidden = true
        //circleMain.setTitle("方向", for: UIControlState())
        
//        circleSecond.delegate = self
//        circleSecond.layer.cornerRadius = circleMain.frame.size.width / 2.0
//        view.addSubview(circleSecond)
//        circleSecond.isHidden = true
    }

    var inventoryIndex:Int = 0
    func circleMainInit(_ button: CircleMenuButton, atIndex: Int){
        if atIndex == 0 {inventoryIndex = 0}
        button.backgroundColor = items[atIndex].color
        button.isHidden = true
        if let room = TheWorld.ME.environment as? KRoom {
            //先设置方向
            if room.exits.contains(items[atIndex].position) {
                button.setTitle(items[atIndex].position.chineseString, for: UIControlState())
                button.isHidden = false
                button.gameDirection = items[atIndex].position
                button.gameObject = nil
            }
        }else{
            button.setTitle("test", for: UIControlState())
        }
    }
    
//    func circleSecondInit(_ button: CircleMenuButton, atIndex: Int){
//        if atIndex >= circleSecond.commands.count {
//            button.isHidden = true
//        } else {
//            button.setTitle(circleSecond.commands[atIndex], for: UIControlState())
//            button.isHidden = false
//        }
//    }
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: CircleMenuButton, atIndex: Int) {
        if circleMenu === circleMain {
            circleMainInit(button, atIndex: atIndex)
        }
//        if circleMenu === circleSecond  {
//            circleSecondInit(button, atIndex: atIndex)
//        }
    }
    
    func circleMainButtonSeleted(_ button:CircleMenuButton, atIndex: Int){
        if let direct = button.gameDirection {
            //点击了方向
            let user = TheWorld.ME
            _ = user.walkRoom(bydirect: direct)
        }
//        } else if let object = button.gameObject {
//            if let touch = button.touchPoint {
//                let point = touch.location(in: circleMain.superview!)
//                circleSecond.frame = CGRect(x: point.x - 20, y: point.y - 20, width: 40, height: 40)
//            }
//            if let npc = object as? KNPC {
//                //点击了npc菜单
//                if npc.environment !== TheWorld.ME.environment {
//                    notifyFail("\(npc.name)已经不在这里了。", to: TheWorld.ME)
//                    return
//                }
//                circleSecond.setTitle(npc.name, for: UIControlState())
//                circleSecond.gameObject = npc
//                circleSecond.commands = npc.availableCommands.chineseStrings
//            } else if let item = object as? KItem {
//                //点击了物品
//                if item.environment !== TheWorld.ME.environment {
//                    notifyFail("\(item.name)已经不在这里了。", to: TheWorld.ME)
//                    return
//                }
//                circleSecond.setTitle(item.name, for: UIControlState())
//                circleSecond.gameObject = item
//                circleSecond.commands = item.availableCommands.chineseStrings
//            }
//            circleSecond.onTap()
//        }
    }
    
//    func circleSecondButtonSelected(_ button: CircleMenuButton, atIndex: Int){
//        if let ent = circleSecond.gameObject as? KEntity , ent.environment !== TheWorld.ME.environment {
//            notifyFail("\(ent.name)已经不在这里了。", to: TheWorld.ME)
//            return
//        }
//        if let npc = circleSecond.gameObject as? KNPC {
//            npc.processUserCommand(NPCCommands(string: button.currentTitle!))
//        } else if let item = circleSecond.gameObject as? KItem {
//            item.processCommand(ItemCommands(string: button.currentTitle!))
//        } else if let user = circleSecond.gameObject as? KUser {
//            //TheWorld.ME.processCommand(
//        }
//    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: CircleMenuButton, atIndex: Int) {
        if circleMenu === circleMain { circleMainButtonSeleted(button, atIndex: atIndex) }
        //if circleMenu === circleSecond { circleSecondButtonSelected(button, atIndex: atIndex) }
    }
    
    func circleMenu(hitCenter circleMenu: CircleMenu) {
        //取消菜单中心是自己的功能，将来可能用于别的
//        if circleMenu === circleMain {
//            //点击的是“自己"
//            circleSecond.setTitle(TheWorld.ME.name, for: UIControlState())
//            circleSecond.frame = circleMain.frame
//            circleSecond.gameObject = TheWorld.ME
//            circleSecond.commands = TheWorld.ME.availableCommands.chineseStrings
//            circleSecond.onTap()
//        }
    }
}
