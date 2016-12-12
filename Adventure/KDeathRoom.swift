//
//  KDeathRoom.swift
//  Adventure
//
//  Created by 苑青 on 16/5/4.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KDeathRoom: KRoom {
    
    class override  var NAME:String { return "阴阳界" }
    
    required init(){
        super.init(name: KColors.HIW + KDeathRoom.NAME + KColors.NOR)
        describe = "隐约北方现出一座黑色城楼，光线太暗，看不大清楚。许多亡魂正\n哭哭啼啼地列队前进，因为一进鬼门关就无法再回阳间了。周围尺\n高的野草随风摇摆，草中发出呼呼的风声。\n";
        isOutDoor = false;
        hasWindow = false;
        addLinkedRoom(.Outside, roomID: 1)
        let cui = KCui_Death()
        if accept(cui) == false {
            fatalError()
        }
    }
    
    required init(k: KObject) {
        assert(k is KDeathRoom)
        super.init(k: k)
    }
    
    required init(roomDescribe d: KRoomDescribe) {
        super.init(roomDescribe: d)
    }
}
