//
//  RoomInventoryButton.swift
//  显示在房间内物体区块中的按钮，代表一个物体
//  Adventure
//
//  Created by 苑青 on 16/7/18.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

class RoomInventoryButton: UIButton {
    var entity: KEntity
    let dropDown = DropDown()
    init(ent: KEntity, rect: CGRect){
        entity = ent
        super.init(frame: rect)
        if let npc = ent as? KNPC {//todo 用图标表示状态而不是文字
            var link = npc.name + (npc.isInFighting ? KColors.HIR + "<战斗中>" + KColors.NOR : "")
            link += npc.isGhost ? "<鬼魂>" : ""
            setTitle(link, forState: .Normal)
        } else {
            self.setTitle(ent.name, forState: .Normal)
        }
        // The view to which the drop down will appear on
        dropDown.anchorView = self // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        if let npc = ent as? KNPC {
            dropDown.dataSource = npc.availableCommands.chineseStrings
        } else if let item = ent as? KItem {
            dropDown.dataSource = item.availableCommands.chineseStrings
        }
        dropDown.selectionAction = itemSeleted
    }
    
    required init?(coder aDecoder: NSCoder) {
        entity = KEntity(name: "default")
        super.init(coder: aDecoder)
    }
    
    func update(){
        setTitle(entity.name, forState: .Normal)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //let dropDown = DropDown()
        dropDown.bottomOffset = CGPoint(x: 0, y:dropDown.anchorView!.plainView.bounds.height)
        dropDown.show()
    }
    
    func itemSeleted(index: Int, item:String){
        if entity.environment !== TheWorld.ME.environment {
            notifyFail("\(entity.name)已经不在这里了。", to: TheWorld.ME)
            return
        }
        if let npc = entity as? KNPC {
            npc.processUserCommand(NPCCommands(string: item))
        } else if let it = entity as? KItem {
            it.processCommand(ItemCommands(string: item))
        }
    }
}

