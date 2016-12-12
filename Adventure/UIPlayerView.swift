//
//  UIPlayerView.swift
//  Adventure
//
//  Created by 苑青 on 16/7/22.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

///用于显示人物的各种状态数据，现在是二级界面
class UIPlayerView: UISlideTabView {

    var mainStatusView = StatusView()
    var skillView = SkillView()
    var gearsView = UIGearInventoryView()
    var proView = UIProfessionView()
    var questView = UIQuestView()
    init(){
        super.init(subView: mainStatusView, viewName: "基本", rect: CGRect(x: 0, y: 0, width: 100, height: 100))
        addView(skillView, name: "技能")
        addView(gearsView, name: "物品")
        if TheWorld.ME.proSkills.isEmpty == false {
            addView(proView, name: "专业")
        }
        if TheWorld.ME.questData.isEmpty == false {
            addView(questView, name: "任务")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
