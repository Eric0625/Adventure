//
//  KLiBai_City.swift
//  Adventure
//
//  Created by 苑青 on 16/5/2.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KLiBai_City: KHuman {
    required init() {
        super.init(name: "李白")
        chatMsg += ["李白低声长吟道：危楼高百尺，手可摘星辰。\n",
                    "李白低吟道：而来四万八千岁，不与秦汉通人烟。\n",
                    "李白鼓腹而歌：挥手自兹去，萧萧班马鸣。\n",
                    "李白击节而歌：赵客缦湖缨，吴钩霜雪明。银鞍照白马，飒沓如流星。\n",
                    "李白低吟道：夫天地者，万物之逆旅。光阴者，百代之过客。\n",
                    "李白击节而歌：脚着谢公屐，身登青云梯。半壁见海日，空中闻天鸡。\n",
                    "李白吟道：孤帆远影碧空尽，唯见长江天际流。\n",
                    "李白朗声吟道：蜀道之难，难于上青天，侧身西望长咨嗟。\n",
                    "李白低声长吟：红颜弃轩冕，白首卧松云。\n",
                    "李白醉态毕露，朗声长吟：醉看风落帽，舞爱月流人。\n",
                    "李白长吟道：音尘绝，西风残照，汉家陵阙。\n"]
        chatChance = 10
        title = "诗仙"
        mapSkill(KSPutiZhi(level: 10), inType: .Unarmed)
        age = 35
        per = 26 + randomInt(3)
        combatExp = 10
        let p = KPoisonCondition(amount: 10, duration: 50)
        applyCondition(p)
        readyEquips()
        attitude = .Aggressive
    }
    
    required init(k: KObject) {
        assert(k is KLiBai_City)
        super.init(k: k)
    }
    
    override func greeting(usr: KUser) {
        super.greeting(usr)
        if !isInFighting {
            tellRoom("李白说道：这位" + rankRespect(usr) + "， 你好啊。", room:  environment!)
        }
    }
    
    override func clone() -> KObject {
        return KLiBai_City(k: self)
    }
    
    func readyEquips(){
        var k:KEquipment = KPanguanBi()
        k.moveTo(self)
        equip(k)
        k = KCloth()
        k.moveTo(self)
        equip(k)
    }
    
    override func reborn() {
        super.reborn()
        readyEquips()
    }
}