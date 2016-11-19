//
//  KArmor.swift
//  Adventure
//
//  Created by 苑青 on 16/4/30.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KArmor: KEquipment{
    var armor = 0
    ///描述中增加防御值
    override var describe: String {
        set(desc) { super.describe = desc}
        get {
            var desc = super.describe + KColors.HIG + "护甲：\(armor)" + KColors.NOR
            if isEquipped { return desc }
            desc += "\n装备后：\n"
            var delta = armor
            //获取同部位装备信息
            if let eqp = TheWorld.ME.getEquippedItem(definedEquipPosition) as? KArmor{
                delta = armor - eqp.armor
            }
            if delta > 0 {
                desc += KColors.HIG + "护甲＋" + delta.toString + KColors.NOR
            } else if delta == 0 {
                desc += "护甲不变"
            } else {
                desc += KColors.HIR + "护甲－" + abs(delta).toString + KColors.NOR
            }
            //在此加入装备前后的特效区别
            return desc
        }
    }
    
    required init(k: KObject) {
        guard let ar = k as? KArmor else {
            fatalError("Init KArmor with unkown object")
        }
        armor = ar.armor
        super.init(k: k)
    }
    
    override init(name: String){
        super.init(name: name)
    }
    
    required convenience init(){
        self.init(name: "普通防具")
    }
    
    override func clone() -> KObject{
        return  KArmor(k: self)
    }
}
