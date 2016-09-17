//
//  SkillView.swift
//  Adventure
//
//  Created by 苑青 on 16/7/25.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit


class StringTableViewCell: UITableViewCell, ConfigurableCell {
    
    typealias T = String
    
    func configure(string: T, isPrototype: Bool) {
        textLabel?.text = string
    }
    
    static func estimatedHeight() -> CGFloat {
        return 32
    }
}


class SkillView: UIView, StatusUpdateDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    var buttons = [Frameable]()
    var buttonsRowView = UIView()
    var skillView: UITableView
    var tableDirector: TableDirector

    init(){

        skillView = UITableView()
        tableDirector = TableDirector(tableView: skillView)
        tableDirector.register(StringTableViewCell.self)
        let b = UIButton()
        b.setTitle("打坐", forState: .Normal)
        buttonsRowView.addSubview(b)
        buttons.append(b)
        super.init(frame: CGRectMake(0, 0, 100, 100))
        addSubview(skillView)
        addSubview(buttonsRowView)
        for skill in TheWorld.ME.learnedSkills.values {
            var status = " "
            if TheWorld.ME.mappedSkills.values.contains(skill) {
                status += "□"
            } else { status += "  " }
            let skillDesc = "\(skill.name): \(skill.level)/\(skill.subLevel)\(status)"
            let row = TableRow<String, StringTableViewCell>(item: skillDesc)
            tableDirector += row
        }
        backgroundColor = UIColor.blueColor()
    }
    
    override func refresh() {
        let buttonHeight = frame.height * 0.1
        buttonsRowView.anchorAndFillEdge(.Bottom, xPad: 0, yPad: 0, otherSize: buttonHeight)//底部按钮
        buttonsRowView.groupAndFill(group: .Horizontal, views: buttons, padding: 3)
        skillView.alignAndFillHeight(align: .AboveCentered, relativeTo: buttonsRowView, padding: 0, width: frame.width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func statusDidUpdate(creature: KCreature, type: UserStatusUpdateType, oldValue: AnyObject?) {
        if creature !== TheWorld.ME { return }
    }
}
