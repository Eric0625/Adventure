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
    
    init()
    {
        super.init(frame: CGRectMake(0, 0, 100, 100))
        self.backgroundColor = UIColor.whiteColor()
        addSubview(health)
        addSubview(force)
        addSubview(sen)
        addSubview(combatExp)
        addSubview(age)
        addSubview(damage)
        addSubview(defense)
        age.text = "年龄:" + TheWorld.ME.age.toString
        combatExp.text = "武学:" + TheWorld.ME.combatExp.toString
        damage.text = "伤害:" + TheWorld.ME.damage.toString
        defense.text = "防御:" + TheWorld.ME.armor.toString
        force.text = "内力:" + formatLifeProperty(.Force)
        health.text = "气血:" + formatLifeProperty(.Kee)
        sen.text = "精神:" + formatLifeProperty(.Sen)
        
        TheWorld.instance.statusUpdateHandler.append(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refresh(){
        let height = frame.height / 7
        health.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: height)
        force.alignAndFillWidth(align: .UnderCentered, relativeTo: health, padding: 0, height: height)
        sen.alignAndFillWidth(align: .UnderCentered, relativeTo: force, padding: 0, height: height)
        combatExp.alignAndFillWidth(align: .UnderCentered, relativeTo: sen, padding: 0, height: height)
        age.alignAndFillWidth(align: .UnderCentered, relativeTo: combatExp, padding: 0, height: height)
        damage.alignAndFillWidth(align: .UnderCentered, relativeTo: age, padding: 0, height: height)
        defense.alignAndFillWidth(align: .UnderCentered, relativeTo: damage, padding: 0, height: height)
    }
    
    func cutZeroesAtTail(input: String) -> String {
        let range = input.regMatch("\\.*(0+)$", range: NSMakeRange(0, input.length))
        if range.isEmpty == false {
            return input[0..<range[0].range.location]
        }
        return input
    }
    
    //todo:根据百分比加上颜色
    func formatLifeProperty(type: DamageType) -> String{
        let amout = TheWorld.ME.lifeProperty[type]!
        let amoutMax = TheWorld.ME.lifePropertyMax[type]!
        var per:Double = 0
        if amoutMax > 0 {
            per = (Double(amout) * 100 / Double(amoutMax))
        }
        let s = cutZeroesAtTail(String(format: "%.2f", per))
        
        return "\(amout)/\(amoutMax)(\(s)%)"
    }
    
    func statusDidUpdate(creature: KCreature, type: UserStatusUpdateType, oldValue: AnyObject?) {
        if creature !== TheWorld.ME { return }
        switch type {
        case .Age:
            age.text = "年龄:" + TheWorld.ME.age.toString
        case .CombatExp:
            combatExp.text = "武学:" + TheWorld.ME.combatExp.toString
        case .Damage:
            damage.text = "伤害:" + TheWorld.ME.damage.toString
        case .Defense:
            defense.text = "防御:" + TheWorld.ME.armor.toString
        case .Force, .MaxForce:
            force.text = "内力:" + formatLifeProperty(.Force)
        case .Kee, .MaxKee:
            health.text = "气血:" + formatLifeProperty(.Kee)
        case .Sen, .MaxSen:
            sen.text = "精神:" + formatLifeProperty(.Sen)
        case .Target:
            break
        default:
            break
        }
    }
}
