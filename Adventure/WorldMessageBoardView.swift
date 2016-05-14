//
//  WorldMessageBoardView.swift
//  Adventure
//
//  Created by 苑青 on 16/5/13.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

class WorldMessageBoardView: UITextView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        textColor = UIColor.greenColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
