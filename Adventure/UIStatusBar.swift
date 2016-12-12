//
//  UIStatusBar.swift
//  Adventure
//
//  Created by Eric on 16/11/14.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

///状态条，使用方法：无，自动监视玩家的condition
class UIStatusBar: UIView, StatusUpdateDelegate {
    var icons = [UIConditionIcon]()
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        backgroundColor = UIColor.white
        TheWorld.instance.statusUpdateHandler.append(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func statusDidUpdate(_ creature: KCreature, type: CreatureStatusUpdateType, information: AnyObject?) {
        guard creature is KUser else { return }
        switch type {
        case .applyCondition:
            //插入图标
            if let condition = information as? KCondition {
                print("\(condition.name) added")
                if let image = condition.imageName {
                    let imageControl = UIConditionIcon(cond: condition, image: UIImage(named: image))
                    addSubview(imageControl)
                    icons.append(imageControl)
                    refresh()
                }
            }
        default:
            break
        }
    }
    
    override func refresh() {
        if icons.isEmpty == false {
            groupAndFill(group: .horizontal, views: icons, padding: 0)
            icons.forEachEnumerated(){
                (index, image) in
                image.scaleImageFrameToWidth(width: image.height)
            }
        }
    }
}

class UIConditionIcon: UIImageView, WithHeartBeat {
    private var condition: KCondition
    var cooldownLayer: CAShapeLayer?
    var conditionLastTime:Int
    func makeOneHeartBeat() {
        //计算layer的覆盖度
        let percent = Double(100 * condition.duration) / Double(conditionLastTime)
        //print("\(condition.name) percent : \(percent)")
        if percent == 0 {
            TheWorld.unregHeartBeat(self)
            let view = superview
            removeFromSuperview()
            view?.refresh()
        }
    }
    
    init(cond: KCondition, image: UIImage?) {
        condition = cond
        conditionLastTime = cond.duration
        super.init(image: image)
        if conditionLastTime != 0 {
            TheWorld.regHeartBeat(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refresh() {
        if cooldownLayer == nil {
            cooldownLayer = CAShapeLayer()
            cooldownLayer?.bounds = bounds
            cooldownLayer?.backgroundColor = UIColor.gray.withAlphaComponent(0.5).cgColor
            cooldownLayer?.anchorPoint = CGPoint.zero
            layer.addSublayer(cooldownLayer!)
        }
    }
}
