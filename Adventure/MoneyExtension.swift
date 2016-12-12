//
//  Money_t.swift
//  Adventure
//
//  Created by 苑青 on 16/4/29.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation
extension Int {
    var gold: Int { return self / 10000 }
    var silver: Int { return (self - self.gold * 10000) / 100 }
    var coin: Int { return self - self.gold * 10000 - self.silver * 100 }
    var toCoin: Int { return self }
    var toSilver: Int { return self / 100 }
    var toGold: Int { return self.gold }
    var moneyString: String {
        var message = ""
        let gold = self.gold
        let silver = self.silver
        let coin = self.coin
        if gold != 0 {
            message = "\(gold)金"
        }
        if silver != 0 {
            message += "\(silver)银"
        }
        if coin != 0 {
            message += "\(coin)铜"
        }
        return message
    }
}
