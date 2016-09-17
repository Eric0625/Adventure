//
//  UIGearInventoryView.swift
//  Adventure
//
//  Created by 苑青 on 16/7/29.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

//整合了装备图示和物品的面板
class UIGearInventoryView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var gearView = UIGearsView()
    var invView = UIInventoryView()
    
    init(){
        super.init(frame: CGRectMake(0, 0, 100, 100))
        backgroundColor = UIColor.blueColor()
        addSubview(gearView)
        addSubview(invView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refresh() {
        let gearHeight = frame.height * 0.4
        gearView.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: gearHeight)
        gearView.refresh()
        invView.alignAndFillHeight(align: .UnderCentered, relativeTo: gearView, padding: 0, width: frame.width)
        invView.refresh()
    }
}
