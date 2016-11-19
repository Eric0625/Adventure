//
//  StatusView.swift
//  Adventure
//
//  Created by 苑青 on 16/7/20.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

//显示人物的基础数值，如生命，内力等
class StatusView: UIView, StatusUpdateDelegate {
    var health = UILabel()
    var force = UILabel()
    var sen = UILabel()
    var combatExp = UILabel()
    var age = UILabel()
    var damage = UILabel()
    var defense = UILabel()
    var attributes = UILabel()
    
    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.backgroundColor = UIColor.white
        addSubview(health)
        addSubview(force)
        addSubview(sen)
        addSubview(combatExp)
        addSubview(age)
        addSubview(damage)
        addSubview(defense)
        addSubview(attributes)
        let user = TheWorld.ME
        age.text = "年龄:" + TheWorld.ME.age.toString
        combatExp.text = "武学:" + TheWorld.ME.combatExp.toString
        damage.text = "伤害:" + TheWorld.ME.damage.toString
        defense.text = "防御:" + TheWorld.ME.armor.toString
        force.text = "内力:" + TheWorld.ME.formatLifeProperty(.force)
        health.text = "气血:" + TheWorld.ME.formatLifeProperty(.kee)
        sen.text = "精神:" + TheWorld.ME.formatLifeProperty(.sen)
        attributes.text = "力量:\(user.str)胆识:\(user.cor)悟性:\(user.wiz)容貌:\(user.per)福缘:\(user.kar)口才:\(user.spe)"
        TheWorld.instance.statusUpdateHandler.append(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refresh(){
        let height = frame.height / 8
        health.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: height)
        force.alignAndFillWidth(align: .underCentered, relativeTo: health, padding: 0, height: height)
        sen.alignAndFillWidth(align: .underCentered, relativeTo: force, padding: 0, height: height)
        combatExp.alignAndFillWidth(align: .underCentered, relativeTo: sen, padding: 0, height: height)
        age.alignAndFillWidth(align: .underCentered, relativeTo: combatExp, padding: 0, height: height)
        damage.alignAndFillWidth(align: .underCentered, relativeTo: age, padding: 0, height: height)
        defense.alignAndFillWidth(align: .underCentered, relativeTo: damage, padding: 0, height: height)
        attributes.alignAndFillWidth(align: .underCentered, relativeTo: defense, padding: 0, height: height)
    }
    
    func statusDidUpdate(_ creature: KCreature, type: CreatureStatusUpdateType, information: AnyObject?) {
        if creature !== TheWorld.ME { return }
        switch type {
        case .age:
            age.text = "年龄:" + TheWorld.ME.age.toString
        case .combatExp:
            combatExp.text = "武学:" + TheWorld.ME.combatExp.toString
        case .damage:
            damage.text = "伤害:" + TheWorld.ME.damage.toString
        case .defense:
            defense.text = "防御:" + TheWorld.ME.armor.toString
        case .force, .maxForce:
            force.text = "内力:" + TheWorld.ME.formatLifeProperty(.force)
        case .kee, .maxKee:
            health.text = "气血:" + TheWorld.ME.formatLifeProperty(.kee)
        case .sen, .maxSen:
            sen.text = "精神:" + TheWorld.ME.formatLifeProperty(.sen)
        case .target:
            break
        default:
            break
        }
    }
}
