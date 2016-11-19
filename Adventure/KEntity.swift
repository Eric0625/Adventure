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
        amount = ent.amount
        stackable = ent.stackable
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
    fileprivate var _weight = Int.max
    fileprivate(set) var _entities: [KEntity]?
    /// 自身容量，默认为0，如果是容器则应设置此容量
    var selfCapacity = Int.min
    var usedCapacity = 0
    var amount = 1 //非堆叠类物品永远是1
    //是否可以堆叠，可堆叠物体在进入同一空间时会融合到一起，操作就是已存在物体的amount＋1，新物体摧毁，因此属性会各异的物体严禁堆叠
    var stackable = false
    weak var environment:KEntity?
    var weight:Int{
        get{ return _weight * amount + usedCapacity }
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
    //接受物体，所有的重量检测和物体融合都在这里
    func accept(_ ent: KEntity) -> Bool {
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
        //检测是否可堆叠物体
        var needAppend = true
        if ent.stackable {
            //先查找是否已存在同类物体
            if let oldEnt = _entities!.first(where: { $0.getNeatName() == ent.getNeatName() }) {
                //已有，旧物体数量增加，传入物体被抛弃
                assert(oldEnt.stackable)
                oldEnt.amount += ent.amount
                needAppend = false
            }
        }
        if needAppend {
            _entities!.append(ent)
            _entities!.sort(){$0 < $1}
            ent.environment = self
        }
        env = self
        repeat
        {
            env!.usedCapacity += ent.weight
            env = env!.environment
        } while (env != nil)
        return true
    }
    
    @discardableResult func moveTo(_ ent: KEntity) -> Bool {
        if ent === self { return false }
        if ent === environment {return false}
        let temp = environment
        guard ent.accept(self) else {
            return false
        }
        temp?.remove(self)
        //这里才算真正移动成功
        if let creatrue = ent as? KCreature {
            TheWorld.didUpdateUserInfo(creatrue, type: .getItem, info: self)
        }

        return true
    }
    
    /// 因为有可能在物体已经移动后再去修改，该功能不改变传入物体的environment变量，仅仅是在自身列表中移除物体的引用并减去重量
    /// 由此，似乎不应该直接调用该功能，因为除了移动物体，没有别的场景需要呼叫该功能
    @discardableResult func remove(_ ent: KEntity) -> Bool {
        if ent === self { return false }
        guard _entities != nil else {
            return false
        }
        
        guard let indexOfEnt = _entities!.index(where: {$0 === ent}) else {
            return false
        }
        
        _entities!.remove(at: indexOfEnt)
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
    ///暂时删除此函数，因为似乎可以用重载describe来实现同样的功能
    ///想不到存在另外一个返回长描述的理由
    //func givePlayerBrief(){}
    
    func moveAllInventoryItemTo(destEnv env:KEntity){
        if env === self { return }
        if _entities != nil{
            for item in _entities! {
                item.moveTo(env)
            }
        }
    }
    
    ///检查当前物体是否在目标物体中（在物体中的容器中也返回真）
    func isContained(in target: KEntity) -> Bool {
        if var env = environment {
            if env === target { return true }
            while env !== target {
                if env.environment == nil { return false }
                env = env.environment!
            }
            return true
        }
        return false
    }
    
    ///根据名称寻找特定物品，深度优先，会在容器中寻找，为简化操作，只寻找第一件满足要求的物品
    func findEntity(withName name:String) -> KEntity? {
        if let inv = _entities {
            for box in inv {
                if box.getNeatName() == name { return box }
                if let ent = box.findEntity(withName: name) {
                    return ent
                }
            }
        }
        return nil
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
    
