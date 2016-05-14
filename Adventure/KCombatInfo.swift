//
//  CombatInfo.swift
//  Adventure
//
//  Created by 苑青 on 16/4/26.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

struct CombatInfo
{
    var allRounds, parrys, dodges, hits, guardings, pozhans: Int//战斗统计数据
    var keeDamage, senDamage:Double
    var lastDamage, counterAttackDamage, maxDamage:Double
    var rival:KCreature?
    init()
    {
        allRounds = 0
        parrys = 0
        dodges = 0
        hits = 0
        guardings = 0
        pozhans = 0
        rival = nil
        keeDamage = 0
        senDamage = 0
        lastDamage = 0
        counterAttackDamage = 0
        maxDamage = 0
    }
    
    mutating func clearAll() {
        allRounds = 0
        parrys = 0
        dodges = 0
        hits = 0
        guardings = 0
        pozhans = 0
        rival = nil
        keeDamage = 0
        senDamage = 0
        lastDamage = 0
        counterAttackDamage = 0
        maxDamage = 0
    }
    
}
//    public KCreature _rival;
//    public double _keeDamage, _senDamage;
//    public double _lastDamage, _counterAttackDamage, _maxDamage;
//    public void clearAll()
//    {
//    _allRounds = _parrys = _dodges = _hits = _guardings = _pozhans = 0;
//    _keeDamage = _senDamage = _lastDamage = _counterAttackDamage = _maxDamage = 0;
//    _rival = null;
//    }
//    
//    public KFightingInfo() : base("战斗统计数据物件")
//    {
//    
//    }
//    
//    public override object Clone()
//    {
//    return (KFightingInfo)base.Clone();
//    }
