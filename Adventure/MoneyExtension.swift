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
}
