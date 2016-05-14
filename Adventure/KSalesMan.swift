//
//  KSalesMan.swift
//  Adventure
//
//  Created by 苑青 on 16/4/30.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KSalesMan: KHuman {
    required init(k: KObject) {
        guard let salesMan = k as? KSalesMan else {
            fatalError("Init KSalesMan with unkown object")
        }
        carriedMoney = salesMan.carriedMoney
        goods = salesMan.goods //goods是引用，真实货物在entities里
        super.init(k: k)
    }
    
    override init(name: String) {
        super.init(name: name)
        //selfCapacity = Int.max //商人负重无限
        availableCommands.insert(.Trade)
    }
    
    required convenience init(){
        self.init(name: "普通商人")
    }
    
    override func clone() -> KObject{
        return  KSalesMan(k: self)
    }
    
    var carriedMoney = 10000
    private(set) var goods = Set<KItem>()
    override var allCapacity: Int { return super.allCapacity }
    
    func canTrade() -> Bool {
        if isGhost || isInFighting || isBusy || environment != TheWorld.ME.environment {
            return false
        }
        return true
    }
    
    func addGoods(commodity: KItem){
        if commodity.moveTo(self) {
            goods.insert(commodity)
        }
    }
    
    func buy(item: KItem) -> Bool {
        if !canTrade() { return false }
        let value = item.sellValue
        if carriedMoney < value { return false }
        if item.moveTo(self) == false {
            return notifyFail("商人无法获得这件物品。", to: TheWorld.ME)
        }
        carriedMoney -= value
        TheWorld.willUpdateUserInfo()
        TheWorld.ME.money += value
        TheWorld.didUpdateUserInfo()
        goods.insert(item)
        return true
    }
    
    func sell(item: KItem) -> Bool {
        if canTrade() == false {return false}
        if !goods.contains(item) {return false}
        let value = item.sellValue
        if TheWorld.ME.money < value { return notifyFail("你的钱不够。", to: TheWorld.ME)}
        if item.moveTo(TheWorld.ME) == false { return notifyFail("你不能获得这件物品。", to: TheWorld.ME)}
        carriedMoney += value
        TheWorld.willUpdateUserInfo()
        TheWorld.ME.money -= value
        goods.remove(item)
        TheWorld.didUpdateUserInfo()
        return true
    }
}