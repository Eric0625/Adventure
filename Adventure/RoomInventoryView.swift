//
//  RoomInventoryView.swift
//  Adventure
//
//  Created by 苑青 on 16/7/17.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

class RoomInventoryView: UIView {
    
    var buttons: [RoomInventoryButton]?
    weak var room: KRoom?
    
    func groupButtons(){
        if buttons?.isEmpty == false {
            var frames = [Frameable]()
            for b in buttons!{
                frames.append(b)
            }
            groupAndFill(group: .Horizontal, views: frames, padding: 5)
        }
    }
    
    func changeRoom(room:KRoom){
        self.room = room
        removeSubviews()
        buttons?.removeAll()
        if let inv = room._entities {
            if buttons == nil {
                buttons = [RoomInventoryButton]()
            }
            for ent in inv {
                if ent === TheWorld.ME { continue }
                if let npc = ent as? KNPC {
                    if npc.visible  == false {
                        continue
                    }
                }
                let b = RoomInventoryButton(ent: ent, rect: CGRectMake(0, 0, 10, 10))
                buttons?.append(b)
                addSubview(b)
            }
        }
        groupButtons()
    }
    
    func addEntity(entity:KEntity){
        if buttons == nil {
            buttons = [RoomInventoryButton]()
        }
        let b = RoomInventoryButton(ent: entity, rect: CGRectMake(0, 0, 10, 10))
        buttons!.append(b)
        addSubview(b)
        groupButtons()
    }
    
    func updateEntity(ent:KEntity){
        if buttons == nil { return }
        for b in buttons! {
            if b.entity === ent {
                b.update()
                break
            }
        }
    }
    
    func removeEntity(ent: KEntity){
        if buttons == nil {return }
        for b in buttons! {
            if b.entity == ent {
                b.removeFromSuperview()
                buttons!.removeObject(b)
                break
            }
        }
        groupButtons()
    }
}
