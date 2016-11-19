//
//  UICombatListView.swift
//  Adventure
//
//  Created by Eric on 16/10/21.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

//用于显示对战的对手和对手的情况（血量，debuff等）
class UICombatListView: UIView, StatusUpdateDelegate {

    var rivalList = [ProgressButton]()//对手列表，用按钮的进度表示血量
    var buttonGroupView = UIView()
    
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        addSubview(buttonGroupView)
        TheWorld.instance.statusUpdateHandler.append(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refresh() {
        buttonGroupView.fillSuperview()
        if rivalList.isEmpty == false {
            buttonGroupView.groupAndFill(group: .vertical, views: rivalList, padding: 0)
            for button in rivalList {
                button.refresh()
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func statusDidUpdate(_ creature: KCreature, type: CreatureStatusUpdateType, information: AnyObject?) {
        switch type {
        case .addRival:
            if creature !== TheWorld.ME { return }
            let rival = information as! KCreature
            let newButton = ProgressButton(with: UIColor.red)
            newButton.setTitleColor(UIColor.white, for: .normal)
            newButton.setTitle(rival.name, for: .normal)
            newButton.object = rival
            var per:CGFloat = CGFloat(rival.kee * 100) / CGFloat(rival.maxKee)
            per = max(0.1, min(100, per))
            newButton.currentProgress = per
            buttonGroupView.addSubview(newButton)
            rivalList.append(newButton)
            refresh()
        case .removeRival:
            if creature !== TheWorld.ME { return }
            let rival = information as! KCreature
            for button in rivalList {
                if button.object === rival{
                    rivalList.removeFirst(button)
                    button.removeFromSuperview()
                    break
                }
            }
            refresh()
        case .kee:
            for button in rivalList{
                if button.object === creature {
                    //该生物在列表中
                    var per:CGFloat = CGFloat(creature.kee * 100) / CGFloat(creature.maxKee)
                    per = max(0.1, min(100, per))
                    button.currentProgress = per
                }
            }
        default:
            break
        }
    }
}
