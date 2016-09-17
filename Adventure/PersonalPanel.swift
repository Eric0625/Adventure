//
//  PersonalPanel.swift
//  Adventure
//
//  Created by 苑青 on 16/7/22.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

//主界面下方的人物面板，包括一个标题栏和一个slideshow
class PersonalPanel: UIView,StatusUpdateDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    var title = UILabel()
    var panel = UIPersonalView()
    
    init(){
        super.init(frame: CGRectMake(0, 0, 100, 100))
        var userString = TheWorld.ME.longName
        if TheWorld.ME.isGhost {
            userString += "<鬼魂>"
        }
        title.text = userString
        title.textAlignment = .Center
        addSubview(title)
        addSubview(panel)
        TheWorld.instance.statusUpdateHandler.append(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refresh(){
        title.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: frame.height/8)
        panel.alignAndFillHeight(align: .UnderCentered, relativeTo: title, padding: 0, width: frame.width)
        panel.refresh()
    }
    
    func statusDidUpdate(creature: KCreature, type: UserStatusUpdateType, oldValue: AnyObject?) {
        if creature !== TheWorld.ME { return }
        switch type {
        case .Death:
            title.text = TheWorld.ME.longName + "<鬼魂>"
        case .Revive:
            title.text = TheWorld.ME.longName
        default:
            break
        }
    }
}
