//
//  UICDButton.swift
//  Adventure
//
//  Created by Eric on 16/10/24.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

///具备显示技能cd情况的按钮，传入cd值，在点击后即可自动恢复，也可在过程中手动改写progress来强制改变冷却速度
///也许还应该加入像wow一样的中途激活时高亮边框
class UICDButton: ProgressButton, WithHeartBeat {

    ///冷却时间，默认无
    var coolDownTime:TimeInterval = 0{
        willSet{
            if coolDownTime == 0 {
                currentCooledTime = newValue //初始化时，如果cooldowntime为0，则说明肯定是可用的，那么就应该同步设置计时值和进度
                currentProgress = 0
            }
        }
        didSet{
            //根据修改过的cd时间计算当前progress
            if coolDownTime != 0 {
                currentProgress = CGFloat(100.0 - 100 * currentCooledTime / coolDownTime)
            } else { currentProgress = 0 }
        }
    }
    
    override init(with color: UIColor) {
        super.init(with: color)
        currentProgress = 0//初始化时cd为0，所以progress也应该为0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///当前已冷却时间，用来记录进程和计算progress
    private var currentCooledTime:TimeInterval = 0
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func makeOneHeartBeat() {
        //步进
        if coolDownTime != 0 {
            currentProgress = CGFloat(100.0 - 100 * currentCooledTime / coolDownTime)
        } else { currentProgress = 100 }
        currentCooledTime += TheWorld.worldInterval
        if currentCooledTime > coolDownTime {
            currentCooledTime = coolDownTime
            currentProgress = 0
            TheWorld.unregHeartBeat(self)//冷却完成，退出心跳循环
        }
    }
    
    override func activate(sender: ProgressButton) {
        //点击时首先监测是否已经cd
        if currentCooledTime >= coolDownTime {
            super.activate(sender: sender) //如果没有cd则呼叫
            if coolDownTime > 0 {
                //有cd，开始计算
                currentCooledTime = 0
                currentProgress = 100
                TheWorld.regHeartBeat(self)
            }
            return
        }
    }
    
    override func drawCurrentProgress() {
        CATransaction.begin()
        CATransaction.disableActions()
        super.drawCurrentProgress()
        CATransaction.commit()
    }
}
