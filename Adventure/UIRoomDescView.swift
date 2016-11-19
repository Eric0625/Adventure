//
//  UIRoomDescView.swift
//  Adventure
//
//  Created by Eric on 16/10/20.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

class UIRoomDescView: UITextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //获取点击信息，这里主要处理人物的行走，因为是房间描述，以后也可能加入别的处理，但主要问题是attributetext只能有一种属性，所以在使用了颜色后，很难加入别的属性
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            var touchPoint = touch.location(in: self)
            touchPoint.x -= textContainerInset.left;
            touchPoint.y -= textContainerInset.top;
            let index = layoutManager.characterIndex(for: touchPoint, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
            if index < text.length{
                var range = NSRange()
                //通过颜色判断点击的内容
                //获取点击字符属性的范围（比如点击了“东北”的东，此时获取整个“东北”的范围）
                if let attributeValue = attributedText.attribute(NSForegroundColorAttributeName, at: index, effectiveRange: &range) as? UIColor {
                    switch attributeValue {
                    case KColors.toUIColor(input: KColors.HIW)!:
                        let tappedExitString = attributedText.attributedSubstring(from: range).string //获取到整个sub string（按颜色分割）
                        if let direct = Directions.fromString(str: tappedExitString){
                            _ = TheWorld.ME.walkRoom(bydirect: direct)
                        }
                    default:
                        break
                    }
                    
                    
                }
            }
        }
    }

}
