//
//  KBusyCondition.swift
//  Adventure
//
//  Created by 苑青 on 16/4/27.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KBusyCondition: KCondition
{
    static let NAME = "定身";
    init(time: Int){
        super.init(name: KBusyCondition.NAME, duration: time)
        imageName = "busy"
    }
    
    required init(k: KObject) {
        guard k is KBusyCondition else {
            fatalError("Cloning KBusyCondition with unkown object")
        }
        super.init(k: k)

    }
}
