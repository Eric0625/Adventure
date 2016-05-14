//
//  MiscEnums.swift
//  Adventure
//
//  Created by 苑青 on 16/4/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

struct ItemCommands: OptionSetType {
    var rawValue: UInt
    static let None = ItemCommands(rawValue: 0)
    static let Observe = ItemCommands(rawValue: 1<<0)
    static let Get = ItemCommands(rawValue: 1<<1)
    static let Stole = ItemCommands(rawValue: 1<<2)
    static let Normal:ItemCommands = [.Observe, .Get]
    
    var chineseString: String {
        switch self {
        case ItemCommands.None:
            return ""
        case ItemCommands.Observe:
            return "观察"
        case ItemCommands.Get:
            return "拾取"
        case ItemCommands.Stole:
            return "偷窃"
        default:
            return "未知物品命令"
        }
    }
    
    init(rawValue: UInt){
        self.rawValue = rawValue
    }
    
    init(string:String){
        switch string {
        case "观察":
            rawValue = ItemCommands.Observe.rawValue
        case "拾取":
            rawValue = ItemCommands.Get.rawValue
        case "偷窃":
            rawValue = ItemCommands.Stole.rawValue
        default:
            rawValue = ItemCommands.None.rawValue
        }
    }
}

struct NPCCommands: OptionSetType {
    typealias RawValue = UInt
    var rawValue: NPCCommands.RawValue
    static let None = NPCCommands(rawValue: 0)
    static let Observe = NPCCommands(rawValue: 1<<0)
    static let Ask = NPCCommands(rawValue: 1<<1)
    static let Give = NPCCommands(rawValue: 1<<2)
    static let Kill = NPCCommands(rawValue: 1<<3)
    static let Stole = NPCCommands(rawValue: 1<<4)
    static let Tame = NPCCommands(rawValue: 1<<5)
    static let Target = NPCCommands(rawValue: 1<<6)
    static let Apprentice = NPCCommands(rawValue: 1<<7)
    static let Trade = NPCCommands(rawValue: 1<<8)
    static let Normal: NPCCommands = [.Target, .Observe, .Tame, .Stole, .Kill, .Ask, .Give]
    
    var chineseString: String {
        switch self {
        case NPCCommands.Observe:
            return "观察"
        case NPCCommands.Apprentice:
            return "拜师"
        case NPCCommands.Ask:
            return "打听"
        case NPCCommands.Give:
            return "给"
        case NPCCommands.Kill:
            return "击杀"
        case NPCCommands.None:
            return ""
        case NPCCommands.Stole:
            return "偷窃"
        case NPCCommands.Tame:
            return "驯服"
        case NPCCommands.Target:
            return "选取"
        case NPCCommands.Trade:
            return "交易"
        default:
            return "未知NPC命令"
        }
    }
    
    init(rawValue: UInt){
        self.rawValue = rawValue
    }
    
    init(string:String){
        switch string {
        case "观察":
            rawValue = NPCCommands.Observe.rawValue
        case "拜师":
            rawValue = NPCCommands.Apprentice.rawValue
        case "打听":
            rawValue = NPCCommands.Ask.rawValue
        case "给":
            rawValue = NPCCommands.Give.rawValue
        case "击杀":
            rawValue = NPCCommands.Kill.rawValue
        case "偷窃":
            rawValue = NPCCommands.Stole.rawValue
        case "驯服":
            rawValue = NPCCommands.Tame.rawValue
        case "选取":
            rawValue = NPCCommands.Target.rawValue
        case "交易":
            rawValue = NPCCommands.Trade.rawValue
        default:
            rawValue = ItemCommands.None.rawValue
        }
    }
}

enum Gender
{
    case 男性, 女性, 中性
    
    func thirdPersonPronounce() -> String {
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
    case Peace
    case Aggressive
    case Defend
}

enum SkillType
{
    case Unarmed,
    Dodge,
    Parry,
    Sword,
    Axe,
    Stick,
    Whip,
    Blade,
    Force,
    None
}

enum ItemType
{
    case Food
    case Equipment
    case Beverage
    case Material
    case Currency
    case Item
}

enum EquipType
{
    case OneHandedWeapon,
    TwoHandedWeapon,
    HeavyArmor,
    LeatherArmor,
    HeadArmor,
    Shield,
    Necklace,
    Ring,
    Waist,
    Shoes,
    Pant,
    Cloth,
    Glove,
    Pauldron,
    Off_hand,//副手
    NONE
}

enum EquipPosition
{
    case LeftHand,
    RightHand,
    Head,
    Neck,
    LeftRing,
    RightRing,
    Waist,
    Foot,
    Leg,
    Body,
    Glove,
    Shoudler,
    NONE
};

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
}