//
//  DamageEnums.swift
//  Adventure
//
//  Created by 苑青 on 16/4/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

enum DamageType{
    case Kee, Sen, Force
    static let AllValues = [Kee, Sen, Force]
}

enum DamageActionType{
    case Ci
    case Za
    case Ge
    case Zhua
    case Pi
    case Kan
    case Zhang//掌伤
    case Nei//内伤
    case Chou//抽伤
    case Yu//淤伤
    case Default
}