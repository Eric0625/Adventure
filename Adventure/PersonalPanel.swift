//
//  PersonalPanel.swift
//  Adventure
//
//  Created by 苑青 on 16/7/22.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

//主界面下方的人物面板，包括一个以进度条方式显示血量的按钮，上面显示人的名字和头衔，以及数字血量（可配置）
//血量条下方为状态条，显示debuff和buff
//还显示8个按钮，用于平时和战斗使用，平时按钮为：行走，飞行，探索，战斗时按钮为：第一行：当前武器对应的技能的招式；第二行：逃跑，内功的招式
class PersonalPanel: UIView,StatusUpdateDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    var title = ProgressButton(with: UIColor.green)
    var powerBar = UIProgressView()//内力、法力条
    var buttons = [UICDButton]()//按钮组
    var buttonGroupView = UIView()//按钮组的容器
    var statusBar: UIStatusBar
    
    private var menuStringss = ["行走", "飞行", "探索", "采集", "挂机"]
    init() {
        statusBar = UIStatusBar()
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        generatePersonalLabel()
        title.addTarget(self, action: #selector(PersonalPanel.titleTapped(button:)), for: .touchUpInside)
        powerBar.progressTintColor = UIColor.yellow
        powerBar.progress = 0.5
        addSubview(title)
        addSubview(powerBar)
        addSubview(statusBar)
        TheWorld.instance.statusUpdateHandler.append(self)
        backgroundColor = UIColor.darkGray
        createButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //创建界面上按钮
    func createButtons(){
        addSubview(buttonGroupView)
        var btn:UICDButton
        for str in menuStringss {
            btn = UICDButton(with: UIColor.white)
            btn.setTitle(str, for: .normal)
            btn.backgroundColor = UIColor.brown
            btn.action = processButtonTap
            buttonGroupView.addSubview(btn)
            buttons.append(btn)
        }
    }
    
    func walk(_ index: Int, item:String){
        print(item)
        //添加出口代码
        if let dir = Directions.fromString(str: item) {
            _ = TheWorld.ME.walkRoom(bydirect: dir)
        } else {
            tellPlayer("没有这个方向", usr: TheWorld.ME)
        }
    }
    
    let popUp = DropDown()
    func processButtonTap(sender: ProgressButton){
        let title = sender.titleLabel!.text!
        switch title {
        case "行走":
            popUp.direction = .top
            popUp.selectionAction = walk
            popUp.anchorView = sender
            //设置方向
            if let room = TheWorld.ME.environment as? KRoom {
                if room.exits.count != 0 {
                    var roomDirections = [String]()
                    for direct in room.exits {
                        roomDirections.append(direct.chineseString)
                    }
                    popUp.dataSource = roomDirections
                } else {
                    //弹出没有出口的提示，todo：灰化行走菜单
                    tellPlayer(KColors.White + "这里没有出口" + KColors.NOR, usr: TheWorld.ME)
                    break
                }
            }else{
                //人物不在任何环境里，弹出虚空提示
                popUp.dataSource = ["1", "2", "3"]
            }
            popUp.topOffset = CGPoint(x: 0, y:-(popUp.anchorView?.plainView.bounds.height)!)
            _ = popUp.show()
        case "逃跑":
            
            if TheWorld.ME.fleeFromFight() == false {
                tellPlayer(KColors.HIY + "你逃跑失败！" + KColors.NOR, usr: TheWorld.ME)
            }
        default:
            break
        }
    }
    
    //生成面板上的字符串：名字＋生命值＋百分比，以及确定面板血量的颜色todo：改为配置
    func generatePersonalLabel() {
        var userString = TheWorld.ME.longName
        if TheWorld.ME.isGhost {
            userString += "<鬼魂>"
        }
        userString += "   " + TheWorld.ME.formatLifeProperty(.kee)
        title.setTitle(userString, for: .normal)
        var per:CGFloat = CGFloat(TheWorld.ME.kee * 100) / CGFloat(TheWorld.ME.maxKee)
        per = max(0.1, min(100, per))
        switch per {
        case 0...35:
            title.setColor(color: UIColor.red)
        case 36...70:
            title.setColor(color: UIColor.yellow)
        case 71...100:
            title.setColor(color: UIColor.green)
        default:
            break
        }
        title.currentProgress = per
    }
    
    override func refresh(){
        statusBar.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: frame.height * 0.2)
        powerBar.alignAndFillWidth(align: .aboveCentered, relativeTo: statusBar, padding: 0, height: 4)
        title.alignAndFillWidth(align: .aboveCentered, relativeTo: powerBar, padding: 0, height: frame.height * 0.5)
        buttonGroupView.alignAndFillHeight(align: Align.aboveMatchingLeft, relativeTo: title, padding: 0, width: frame.width)
        buttonGroupView.groupAndFill(group: .horizontal, views: buttons, padding: 1)
    }
    
    func statusDidUpdate(_ creature: KCreature, type: CreatureStatusUpdateType, information: AnyObject?) {
        if creature !== TheWorld.ME { return }
        switch type {
        case .death, .revive, .kee:
             generatePersonalLabel()
        case .intoFight, .outFight:
            setButtons()
        default:
            break
        }
    }
    
    //根据玩家的战斗状态更新下方的按钮
    func setButtons(){
        if TheWorld.ME.isInFighting {
            for btn in buttons {
                if btn.title(for: .normal) == "行走" {
                    btn.setTitle("逃跑", for: .normal)
                    btn.coolDownTime = 2
                }
            }
        } else {
            for btn in buttons {
                if btn.title(for: .normal) == "逃跑" {
                    btn.setTitle("行走", for: .normal)
                    btn.coolDownTime = 0
                }
            }
        }
    }
    
    //点击了人物血量面板
    func titleTapped(button: ProgressButton){
        findViewController()?.present(UIPlayerViewController(), animated: true, completion: nil)
    }
}
