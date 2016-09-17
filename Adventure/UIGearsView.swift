//
//  UIGearsView.swift
//  Adventure
//
//  Created by 苑青 on 16/7/29.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

///人物装备图示面板
class UIGearsView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    init(){
        super.init(frame: CGRectMake(0, 0, 100, 100))
        backgroundColor = UIColor.grayColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
