//
//  UIQuestView.swift
//  Adventure
//
//  Created by 苑青 on 2016/11/19.
//  Copyright © 2016年 Eric. All rights reserved.
//

import Foundation
import UIKit
fileprivate class QuestCell: UITableViewCell {
    var quest: STQuestData?
}
class UIQuestView: UIView, UITableViewDataSource, UITableViewDelegate {
    var questListView = UITableView()
    var questDescView = UITextView()
    var deleteQuestButton = UIButton()
    
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        questDescView.isEditable = false
        questDescView.backgroundColor = UIColor.black
        deleteQuestButton.setTitle("删除", for: .normal)
        questListView.dataSource = self
        questListView.delegate = self
        
        addSubview(questListView)
        addSubview(questDescView)
        addSubview(deleteQuestButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(TheWorld.ME.questData.count, 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier="identifier";
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? QuestCell
        if(cell == nil){
            cell = QuestCell(style: UITableViewCellStyle.value1, reuseIdentifier: identifier)
        }
        if TheWorld.ME.questData.isEmpty {
            cell?.textLabel?.text = "无任务"
        } else {
            var index = TheWorld.ME.questData.startIndex
            index = TheWorld.ME.questData.index(index, offsetBy: indexPath.row)
            let (_, quest) = TheWorld.ME.questData[index]
            cell?.quest = quest
            cell?.textLabel?.text = quest.name
            if quest.finished {
                cell?.accessoryType = .checkmark
            } else {
                cell?.accessoryType = .none
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? QuestCell {
            if let quest = cell.quest {
                var text = quest.description
                if quest.finished {
                    text += KColors.YEL + "\n已完成。" + KColors.NOR
                }
                questDescView.attributedText = processFormattedString(text)
            } else {
                questDescView.text = ""
            }
        } else {
            questDescView.text = ""
        }
    }
    
    override func refresh() {
        let buttonHeight = frame.height * 0.1
        let questListWidth = frame.width * 0.4
        deleteQuestButton.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: buttonHeight)//底部按钮
        questListView.alignAndFillHeight(align: .aboveMatchingLeft, relativeTo: deleteQuestButton, padding: 0, width: questListWidth)
        questDescView.alignAndFill(align: .toTheRightCentered, relativeTo: questListView, padding: 0)
    }
}
