//
//  MiscEnums.swift
//  Adventure
//
//  Created by 苑青 on 16/4/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

//用户的命令，所有玩家使用的命令都在这里
struct UserCommands: OptionSet {
    var rawValue: UInt
    static let none = UserCommands(rawValue: 0)
    static let inventory = UserCommands(rawValue: 1<<0)
    static let showStatus = UserCommands(rawValue: 1<<1)
    static let all: UserCommands = [.inventory, .showStatus]
    
    var chineseStrings: [String] {
        switch self {
        case UserCommands.none:
            return []
        case UserCommands.inventory:
            return ["物品"]
        case UserCommands.showStatus:
            return ["状态"]
        default:
            var returnValue:[String] = []
            if self.contains(.inventory) { returnValue += UserCommands.inventory.chineseStrings }
            if self.contains(.showStatus) { returnValue += UserCommands.showStatus.chineseStrings }
            return returnValue
        }
    }
    
    init(rawValue: UInt){
        self.rawValue = rawValue
    }
    
    init(string:String){
        switch string {
        case "物品":
            rawValue = UserCommands.inventory.rawValue
        case "状态":
            rawValue = UserCommands.showStatus.rawValue
        default:
            rawValue = ItemCommands.none.rawValue
        }
    }
}

struct ItemCommands: OptionSet {
    let rawValue: UInt
    static let none = ItemCommands(rawValue: 0)
    static let observe = ItemCommands(rawValue: 1<<0)
    static let get = ItemCommands(rawValue: 1<<1)
    static let stole = ItemCommands(rawValue: 1<<2)
    static let harving = ItemCommands(rawValue: 1<<3)
    static let equip = ItemCommands(rawValue: 1<<4)
    static let unequip = ItemCommands(rawValue: 1<<5)
    static let drop = ItemCommands(rawValue: 1<<6)
    static let getAll = ItemCommands(rawValue: 1<<7)
    
    var chineseStrings: [String] {
        switch self {
        case ItemCommands.none:
            return [""]
        case ItemCommands.observe:
            return ["观察"]
        case ItemCommands.get:
            return ["拾取"]
        case ItemCommands.stole:
            return ["偷窃"]
        case ItemCommands.harving:
            return ["采集"]
        case ItemCommands.equip:
            return ["装备"]
        case ItemCommands.unequip:
            return ["卸载"]
        case ItemCommands.drop:
            return ["丢弃"]
        case ItemCommands.getAll:
            return ["拿取全部"]
        default:
            var returnValue:[String] = []
            if self.contains(.observe) { returnValue += ItemCommands.observe.chineseStrings }
            if self.contains(.get) { returnValue += ItemCommands.get.chineseStrings }
            if self.contains(.stole) { returnValue += ItemCommands.stole.chineseStrings }
            if contains(.harving) { returnValue += ItemCommands.harving.chineseStrings }
            if contains(.drop) { returnValue += ItemCommands.drop.chineseStrings }
            if contains(.equip) { returnValue += ItemCommands.equip.chineseStrings }
            if contains(.unequip) { returnValue += ItemCommands.unequip.chineseStrings }
            if contains(.getAll) {  returnValue += ItemCommands.getAll.chineseStrings }
            return returnValue
        }
    }
    
    init(rawValue: UInt){
        self.rawValue = rawValue
    }
    
    init(string:String){
        switch string {
        case "观察":
            rawValue = ItemCommands.observe.rawValue
        case "拾取":
            rawValue = ItemCommands.get.rawValue
        case "偷窃":
            rawValue = ItemCommands.stole.rawValue
        case "装备":
            rawValue = ItemCommands.equip.rawValue
        case "卸载" :
            rawValue = ItemCommands.unequip.rawValue
        case "丢弃" :
            rawValue = ItemCommands.drop.rawValue
        case "拿取全部" :
            rawValue = ItemCommands.getAll.rawValue
        default:
            rawValue = ItemCommands.none.rawValue
        }
    }
}

struct NPCCommands {
    static let observe = "观察"
    static let apprentice = "拜师"
    static let ask = "打听"
    static let give = "给"
    static let kill = "击杀"
    static let trade = "交易"
    static var normalCmds: [String] {
        get {
            return [observe, apprentice, ask, give, kill]
        }
    }
    //        case NPCCommands.None:
    //            return []
    //        case NPCCommands.Stole:
    //            return ["偷窃"]
    //        case NPCCommands.Tame:
    //            return ["驯服"]
    //        case NPCCommands.Target:
    //            return ["选取"]
    //        case NPCCommands.Trade:
    //            return ["交易"]

}
//struct NPCCommands: OptionSet {
//    typealias RawValue = UInt
//    var rawValue: NPCCommands.RawValue
//    static let None = NPCCommands(rawValue: 0)
//    static let Observe = NPCCommands(rawValue: 1<<0)
//    static let Ask = NPCCommands(rawValue: 1<<1)
//    static let Give = NPCCommands(rawValue: 1<<2)
//    static let Kill = NPCCommands(rawValue: 1<<3)
//    static let Stole = NPCCommands(rawValue: 1<<4)
//    static let Tame = NPCCommands(rawValue: 1<<5)
//    static let Target = NPCCommands(rawValue: 1<<6)
//    static let Apprentice = NPCCommands(rawValue: 1<<7)
//    static let Trade = NPCCommands(rawValue: 1<<8)
//    static let Normal: NPCCommands = [.Target, .Observe, .Tame, .Stole, .Kill, .Ask, .Give]
//    
//    var chineseStrings: [String] {
//        switch self {
//        case NPCCommands.Observe:
//            return ["观察"]
//        case NPCCommands.Apprentice:
//            return ["拜师"]
//        case NPCCommands.Ask:
//            return ["打听"]
//        case NPCCommands.Give:
//            return ["给"]
//        case NPCCommands.Kill:
//            return ["击杀"]
//        case NPCCommands.None:
//            return []
//        case NPCCommands.Stole:
//            return ["偷窃"]
//        case NPCCommands.Tame:
//            return ["驯服"]
//        case NPCCommands.Target:
//            return ["选取"]
//        case NPCCommands.Trade:
//            return ["交易"]
//        default:
//            //可能有多个命令组合而成
//            var returnValue:[String] = []
//            if self.contains(.Observe) { returnValue += NPCCommands.Observe.chineseStrings }
//            if self.contains(.Apprentice) { returnValue += NPCCommands.Apprentice.chineseStrings }
//            if self.contains(.Ask) { returnValue += NPCCommands.Ask.chineseStrings }
//            if self.contains(.Give) { returnValue += NPCCommands.Give.chineseStrings }
//            if self.contains(.Kill) { returnValue += NPCCommands.Kill.chineseStrings }
//            if self.contains(.Stole) { returnValue += NPCCommands.Stole.chineseStrings }
//            if self.contains(.Tame) { returnValue += NPCCommands.Tame.chineseStrings }
//            if self.contains(.Target) { returnValue += NPCCommands.Target.chineseStrings }
//            if self.contains(.Trade) { returnValue += NPCCommands.Trade.chineseStrings }
//            return returnValue
//        }
//    }
//    
//    init(rawValue: UInt){
//        self.rawValue = rawValue
//    }
//    
//    init(string:String){
//        switch string {
//        case "观察":
//            rawValue = NPCCommands.Observe.rawValue
//        case "拜师":
//            rawValue = NPCCommands.Apprentice.rawValue
//        case "打听":
//            rawValue = NPCCommands.Ask.rawValue
//        case "给":
//            rawValue = NPCCommands.Give.rawValue
//        case "击杀":
//            rawValue = NPCCommands.Kill.rawValue
//        case "偷窃":
//            rawValue = NPCCommands.Stole.rawValue
//        case "驯服":
//            rawValue = NPCCommands.Tame.rawValue
//        case "选取":
//            rawValue = NPCCommands.Target.rawValue
//        case "交易":
//            rawValue = NPCCommands.Trade.rawValue
//        default:
//            rawValue = ItemCommands.none.rawValue
//        }
//    }
//    
//    
//}

enum Gender
{
    case 男性, 女性, 中性
    
    var thirdPersonPronounce: String {
        switch (self){
        case .男性:
            return "他";
        case .女性:
            return "她";
        case .中性:
            return "它";
        }
    }
}

enum NPCAttitude
{
    case peace
    case aggressive
    case defend
}

enum SkillType: String
{
    case unarmed = "空手格斗"
    case dodge = "躲闪"
    case parry = "招架"
    case sword = "剑法"
    case axe = "斧法"
    case stick = "棍法"
    case whip = "鞭法"
    case blade = "刀法"
    case force = "内功心法"
    case none = "未知"
}

enum ItemType
{
    case food
    case equipment
    case beverage
    case material
    case currency
    case item
}

enum EquipmentType: String
{
    case oneHandedWeapon = "单手武器"
    case twoHandedWeapon = "双手武器"
    case heavyArmor = "重甲"
    case lightArmor = "轻甲"
    case off_hand = "副手"
    case cloth = "布衣"
    case none
}

///数字代表了各部位的排序
enum EquipPosition: Int
{
    case leftHand = 5
    case rightHand = 4
    case head = 0
    case neck = 1
    case leftRing = 11
    case rightRing = 10
    case waist = 7
    case foot = 9
    case leg = 8
    case body = 3
    case glove = 6
    case shoudler = 2
    case none = -1
    
    static func count() -> Int {
        return 12
    }

    ///获取各部位的本地化名称
    var chineseName : String {
        switch self {
        case .body:
            return "上衣"
        case .foot:
            return "足部"
        case .glove:
            return "手套"
        case .head:
            return "头部"
        case .leftHand:
            return "副手"
        case .leftRing:
            return "戒指2"
        case .leg:
            return "腿部"
        case .neck:
            return "颈部"
        case .none:
            return ""
        case .rightHand:
            return "主手"
        case .rightRing:
            return "戒指1"
        case .shoudler:
            return "肩部"
        case .waist:
            return "腰部"
        }
    }
}

enum Directions: String
{
    case East,
    South,
    West,
    North,
    SEast,
    NEast,
    SWest,
    NWest,
    Up
    case Down
    case Inside
    case Outside
    
    var OppositeDirection: Directions{
        switch (self)
        {
        case .East:
            return .West;
        case .South:
            return .North;
        case .West:
            return .East;
        case .North:
            return .South;
        case .SEast:
            return .NWest;
        case .NEast:
            return .SWest;
        case .SWest:
            return .NEast;
        case .NWest:
            return .SEast;
        case .Up:
            return .Down;
        case .Down:
            return .Up;
        case .Inside:
            return .Outside;
        case .Outside:
            return .Inside;
        }
    }
    
    var chineseString: String {
        switch self {
        case .Down:
            return "下"
        case .East:
            return "东"
        case .Inside:
            return "里面"
        case .NEast:
            return "东北"
        case .North:
            return "北"
        case .NWest:
            return "西北"
        case .Outside:
            return "外面"
        case .SEast:
            return "东南"
        case .South:
            return "南"
        case .SWest:
            return "西南"
        case .Up:
            return "上"
        case .West:
            return "西"
        }
    }
    
    static func fromString(str: String) -> Directions? {
        switch str {
        case "西":
            return Directions.West
        case "上":
            return Directions.Up
        case "西南":
            return Directions.SWest
        case "南":
            return Directions.South
        case "东南":
            return Directions.SEast
        case "外面":
            return Directions.Outside
        case "西北":
            return Directions.NWest
        case "北":
            return Directions.North
        case "东北":
            return Directions.NEast
        case "里面":
            return Directions.Inside
        case "东":
            return Directions.East
        case "下":
            return Directions.Down
        default:
            return nil
        }
    }
}
