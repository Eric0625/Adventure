//
//  KPanguanBi.swift
//  Adventure
//
//  Created by 苑青 on 16/5/1.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation

class KPanguanBi:KSword {
    required init(){
        super.init()
        weight = 1000
        value = 1000
        name = "判官笔"
        describe = "一根笔头尖细，笔把粗圆的判官笔。"
        damage = 20
    }
    
    required init(k: KObject) {
        guard k is KPanguanBi else {
            fatalError("Cloning KPanguanBi with unkown object")
        }
        super.init(k: k)
    }
    
    override func clone() -> KObject {
        return KPanguanBi(k: self)
    }
}