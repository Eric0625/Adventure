//
//  DamageEnums.swift
//  Adventure
//
//  Created by 苑青 on 16/4/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

enum DamageType{
    case kee, sen, force
    static let AllValues = [kee, sen, force]
}

enum DamageActionType{
    case ci
    case za
    case ge
    case zhua
    case pi
    case kan
    case zhang//掌伤
    case nei//内伤
    case chou//抽伤
    case yu//淤伤
    case `default`
}
