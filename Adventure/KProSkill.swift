//
//  KProSkill.swift
//  Adventure
//
//  Created by Eric on 16/11/3.
//  Copyright © 2016年 Eric. All rights reserved.
//
// 专业技能类
import Foundation

///配方结构
struct STRecipe {
    var name:String
    ///配方，键为材料名，值为所需数量
    var ingredients: [String: Int]
    ///生产的结果，内容是该物品的类名
    var outCome: String
    var outComeDescribe: String //产品描述
    ///生产的条件，为某件物品的名称，需要该物品存在才可制造
    var condition = ""
}

class KProSkill : KObject {
    required init(k: KObject) {
        guard let pros = k as? KProSkill else {
            fatalError("Init KProSKill with unkown object")
        }
        owner = pros.owner
        level = pros.level
        subLevel = pros.subLevel
        for r in pros.recipes {
            recipes.append(r)
        }
        super.init(k: k)
    }
    
    override init(name: String){
        super.init(name: name)
    }
    
    override func clone() -> KObject{
        return  KProSkill(k: self)
    }
    
    weak var owner: KUser?//只有玩家会专业技能
    var level = 1
    var subLevel = 0
    //已学会的配方，从配方库拷贝
    var recipes = [STRecipe]()
    
    func improve(increment: Int) {
        guard let owner = self.owner else { return }
        var realAmount = increment
        let wiz = owner.wiz / 2
        let count = owner.learnedSkills.count
        if wiz < count {
            realAmount /= count - wiz
        }
        subLevel += realAmount
        if subLevel > (level + 1) * (level + 1) {
            level += 1
            tellPlayer(KColors.HIC + "你的" + name + "进步了！\n" + KColors.NOR, usr: owner)
            subLevel = 0
        }
    }
    
    ///制造某件东西的调用
    @discardableResult func produce(from recipeName: String) -> Bool{
        guard let producer = owner else { return false}
        if let rp = recipes.first(where: {$0.name == recipeName}) {
            if rp.condition.isBlank == false {//检查制造条件
                if let env = producer.environment {
                    let conditionObject = env._entities!.first(where: {$0.name == rp.condition})
                    if conditionObject == nil {
                        return notifyFail(KColors.Red + "需要" + rp.condition + KColors.NOR, to: producer)
                    }
                } else {
                    return notifyFail("你当前不在任何地方", to: producer)
                }
            }
            //检查材料
            for ingre in rp.ingredients {
                if let ent = producer.findEntity(withName: ingre.key) {
                    if ent.amount < ingre.value {
                        return notifyFail("\(ingre.key)的数量不够。", to: producer)
                    }
                }
            }
            
            let type = NSClassFromString(rp.outCome) as! KItem.Type
            let real = type.init()
            tellPlayer("你制造了\(real.name)", usr: producer)
            if  real.moveTo(producer) {
                //减少材料，这里要先将物品拿出来，减少数量，再放回去
                for ingre in rp.ingredients {
                    let ent = producer.findEntity(withName: ingre.key)!
                    let preEnv = ent.environment!
                    ent.moveTo(TheWorld.VOIDROOM)
                    ent.amount -= ingre.value
                    if ent.amount != 0 {
                        ent.moveTo(preEnv)
                    } else {
                        TheWorld.VOIDROOM.remove(ent)
                    }
                }
                return true
            } else { return notifyFail("物品传输失败", to: producer) }//todo:身上过重时提示玩家
        }
        return notifyFail("没有这个配方", to: producer)
    }

    func calculateProductNumber(recipe: STRecipe) -> Int {
        if let person = owner {
            guard recipes.contains(where: {$0.name == recipe.name}) else { return 0 }
            var number = 0
            for ingre in recipe.ingredients {
                //计算材料数量
                let iname = ingre.key
                if let ingEnt = person.findEntity(withName: iname) {
                    if ingEnt.amount < ingre.value {
                        return 0
                    }
                    let inumber = ingEnt.amount / ingre.value
                    if number == 0 {
                        number = inumber
                    } else {
                        number = min(number, inumber)
                    }
                } else {
                    return 0
                }
            }
            return number
        }
        return 0
    }
}
