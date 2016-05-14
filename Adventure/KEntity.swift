//
//  KEntity.swift
//  Adventure
//
//  Created by 苑青 on 16/4/24.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

/// 实体，具备重量以及容纳另一个实体的能力
class KEntity: KObject, Comparable{
    
    required init(k: KObject){
        guard let ent = k as? KEntity else {
            fatalError("Cloning KEntity with unkown object")
        }
        _weight = ent._weight
        if let ents = ent._entities {
            _entities = deepCopy(ents)
//            _entities = [KEntity]()
//            for entity in ents{
//                //这里的新实体虽然继承了旧实体的环境参数，但我们明白它不是任何环境的一部分，所以不需要moveto来减去原环境的重量
//                //也不需要修改current capacity，因为从克隆中继承了
//                let newItem = KEntity(k: entity)
//                _entities!.append(newItem)
//            }
        }
        selfCapacity = ent.selfCapacity
        usedCapacity = ent.usedCapacity
        environment = nil //此物体在虚空中
        super.init(k: k)
    }
    
    override init(name: String) {
        super.init(name: name)
    }
   
    override func clone() -> KObject{
        return  KEntity(k: self)
    }
    
    //MARK: Variables
    private var _weight = Int.max
    private(set) var _entities: [KEntity]?
    /// 自身容量，默认为0，如果是容器则应设置此容量
    var selfCapacity = Int.min
    var usedCapacity = 0
    weak var environment:KEntity?
    var weight:Int{
        get{ return _weight + usedCapacity }
        set{ _weight = newValue }
    }
    /// getter属性，计算当前容器的容量
    var allCapacity: Int {
        if let env = environment {
            let envcapa = env.allCapacity - env.usedCapacity
            return min(envcapa, selfCapacity)//返回的是自身的容量以及环境的剩余容量中较小的一个
        } else {
            return selfCapacity
        }
    }
    
    //MARK:Functions
    func accept(ent: KEntity) -> Bool {
        if ent === self { return false }
        if ent.environment === self {return false}
        //暂时减去ent所在环境的ent重量，这是防止下面检查capacity时会附加ent重量
        if let e = ent.environment {
            e.usedCapacity -= ent.weight
        }
        
        var env:KEntity? = ent //对嵌套的检查，如果已经是ent容器的容器，则不需要检查负重
        while env != nil {
            if env === self { break }
            env = env!.environment
        }
        if (env == nil)
        {
            let c = allCapacity
            if ent.weight > c
            {
                if let e = ent.environment {
                    e.usedCapacity += ent.weight
                }
                return notifyFail("这样东西对你而言太重了！\n", to: self)
            }
            if (usedCapacity + ent.weight > c)
            {
                if let e = ent.environment {
                    e.usedCapacity += ent.weight
                }
                return notifyFail("你的负荷过多！\n", to: self)
            }
        }
        if let e = ent.environment {
            e.usedCapacity += ent.weight
        }
        if _entities == nil {
            _entities = [KEntity]()
        }
        _entities!.append(ent)
        _entities!.sortInPlace(){$0 < $1}
        
        ent.environment = self
        env = self
        repeat
        {
            env!.usedCapacity += ent.weight
            env = env!.environment
        } while (env != nil)
        return true;
    }
    
    func moveTo(ent: KEntity) -> Bool {
        if ent === self { return false }
        if ent === environment {return false}
        let temp = environment
        guard ent.accept(self) else {
            return false
        }
        temp?.remove(self)
        return true
    }
    
    /// 该功能不改变物体的environment变量
    func remove(ent: KEntity) -> Bool {
        if ent === self { return false }
        guard _entities != nil else {
            return false
        }
        
        guard let indexOfEnt = _entities!.indexOf({$0 === ent}) else {
            return false
        }
        
        _entities!.removeAtIndex(indexOfEnt)
        usedCapacity -= ent.weight
        var env = environment
        while env != nil {
            env!.usedCapacity -= ent.weight
            env = env!.environment
        }
        
        if _entities!.count == 0 {
            _entities = nil
        }
        return true
    }
    
    func givePlayerBrief(){}
    
    func moveAllInventoryItemTo(destEnv env:KEntity){
        if env === self { return }
        if _entities != nil{
            for item in _entities! {
                item.moveTo(env)
            }
        }
    }
}

extension Int{
    var G: Int {return self}
    var KG: Int {return self * 1000.G}
    var T: Int{ return self * 1000.KG }
}

//MARK:全局比较函数
func < (left: KEntity, right:KEntity) -> Bool {
    switch left {
    case let x where x is KUser:
        if right is KUser { return left.name < right.name }
        return false
    case let x where x is KNPC:
        switch right {
        case let y where y is KUser:
            return true
        case let y where y is KNPC:
            return x.name < y.name
        default:
            return false
        }
    case let x where x is KItem:
        switch right {
        case let y where y is KUser:
            return false
        case let y where y is KNPC:
            return false
        case let y where y is KItem:
            return x.name < y.name
        default:
            return true
        }
    default:
        if right is KUser ||
            right is KNPC || right is KItem {
            return true
        }
        return left.name < right.name
    }
}
    