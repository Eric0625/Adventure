//
//  UIPersonalView.swift
//  Adventure
//
//  Created by 苑青 on 16/7/22.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

///用于显示人物的各种状态数据
class UIPersonalView: UISlideTabView {

    var mainStatusView = StatusView()
    var skillView = SkillView()
    init(){
        super.init(subView: mainStatusView, viewName: "基本", rect: CGRectMake(0, 0, 100, 100))
        addView(skillView, name: "技能")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
