//
//  KTailor.swift
//  Adventure
//
//  Created by Eric on 16/11/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KTailor: KProSkill {
    static let allRecipes = [
        STRecipe(name: "布衣", ingredients: ["粗麻布":5, "粗线":2], outCome: NSStringFromClass(KCloth.self), outComeDescribe: "一件普通的布衣。\n护甲 +1", condition: ""),
        STRecipe(name: "简易布靴", ingredients: ["粗麻布":2, "粗线":1], outCome: NSStringFromClass(KClothBoot1.self), outComeDescribe: "一件普通的布制靴子。\n护甲 +1", condition: "")
    ]
    init(){
        super.init(name: "裁缝")
    }
    
    required init(k: KObject) {
        guard k is KTailor else {
            fatalError("Init KTailor with unkown object")
        }
        super.init(k: k)
    }

}
