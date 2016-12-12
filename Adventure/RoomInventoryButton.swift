//
//  RoomInventoryButton.swift
//  显示在房间内物体区块中的按钮，代表一个物体
//  Adventure
//
//  Created by 苑青 on 16/7/18.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

class RoomInventoryButton: UIButton, StatusUpdateDelegate {
    unowned var entity: KEntity
    let dropDown = DropDown()
    init(ent: KEntity, rect: CGRect){
        entity = ent
        super.init(frame: rect)
        if let npc = ent as? KNPC {//todo 用图标表示状态而不是文字
            var link = npc.name + (npc.isInFighting ? KColors.HIR + "<战斗中>" + KColors.NOR : "")
            link += npc.isGhost ? "<鬼魂>" : ""
            setTitle(link, for: UIControlState())
        } else {
            self.setTitle(ent.name, for: UIControlState())
        }
        // The view to which the drop down will appear on
        dropDown.anchorView = self // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically
        if let npc = ent as? KNPC {
            dropDown.dataSource = npc.availableCommands
        } else if let item = ent as? KItem {
            dropDown.dataSource = item.availableCommands
        }
        dropDown.selectionAction = itemSeleted
        TheWorld.instance.statusUpdateHandler.append(self)
    }
    
    deinit{
        print("button \(entity.name) destroied")
    }
    
    required init?(coder aDecoder: NSCoder) {
        entity = KEntity(name: "default")
        super.init(coder: aDecoder)
    }
    
    func update(){
        //战斗中加在标题中太长了，暂时删除
//        if let creature = entity as? KCreature {
//            if creature.isInFighting {
//                setTitle(entity.name + "<战斗中>", for: .normal)
//            } else {
//                setTitle(entity.name, for: .normal)
//            }
//        } else {
//            setTitle(entity.name, for: .normal)
//        }
        setTitle(entity.name, for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //let dropDown = DropDown()
        dropDown.bottomOffset = CGPoint(x: 0, y:dropDown.anchorView!.plainView.bounds.height)
        _ = dropDown.show()
    }
    
    func itemSeleted(_ index: Int, item:String){
        if let npc = entity as? KNPC {
            npc.processNPCCommand(item)
        } else if let it = entity as? KItem {
            it.processCommand(item)
        }
    }
    
    func statusDidUpdate(_ creature: KCreature, type: CreatureStatusUpdateType, information: AnyObject?) {
        
    }
}

