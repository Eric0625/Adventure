//
//  InventoryView.swift
//  Adventure
//
//  Created by 苑青 on 16/7/29.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit
class ItemCell: UITableViewCell{
    var entity:KEntity?
}

class UIInventoryView: UIView,UITableViewDataSource, UITableViewDelegate {

    //布局：左侧物品列表，右侧上方物品描述，下方操作按钮，最下方切换物品类型以及返回
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    //以下为物品列表所用的数据源和delegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier="identifier";
        var cell:ItemCell? = tableView.dequeueReusableCellWithIdentifier(identifier) as? ItemCell;
        if(cell == nil){
            cell = ItemCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier);
        }
        if let inv = TheWorld.ME._entities {
            cell?.textLabel?.text = inv[indexPath.row].name
            cell?.entity = inv[indexPath.row]
        } else {
            cell?.textLabel?.text = "无物品"
        }
        //cell?.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator;
        return cell!;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let inv = TheWorld.ME._entities {
            return inv.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? ItemCell
        if cell != nil {
            if let ent = cell?.entity {
                itemDescView.text = ent.describe
                if let item = ent as? KItem {
                    let itemStrings = item.availableCommands.chineseStrings
                    for i in 0..<itemStrings.count {
                        let button = itemCommands[i] as! UIButton
                        button.setTitle("\(i)", forState: .Normal)
                        button.hidden = false
                    }
                }
            }
        }
    }
    
    
    var itemListView = UITableView()
    var itemDescView = UITextView()
    var commandsGroupView = UIView()
    var itemCommands = [Frameable]()
    var tagsGroupView = UIView()
    var itemTags = [Frameable]()

    init(){
        
        super.init(frame: CGRectMake(0, 0, 100, 100))
        itemListView.delegate = self
        itemListView.dataSource = self
        backgroundColor = UIColor.yellowColor()
        addSubview(itemListView)
        addSubview(itemDescView)
        addSubview(commandsGroupView)
        addSubview(tagsGroupView)
        for _ in 1...10 {
            let button = UIButton()
            //button.hidden = true
            itemCommands.append(button)
            commandsGroupView.addSubview(button)
        }
        var button = UIButton()
        itemTags.append(button)
        button.setTitle("全", forState: .Normal)
        button.showsTouchWhenHighlighted = true
        tagsGroupView.addSubview(button)
        button = UIButton()
        itemTags.append(button)
        button.setTitle("装", forState: .Normal)
        button.showsTouchWhenHighlighted = true
        tagsGroupView.addSubview(button)
        button = UIButton()
        itemTags.append(button)
        button.setTitle("材", forState: .Normal)
        button.showsTouchWhenHighlighted = true
        tagsGroupView.addSubview(button)
        button = UIButton()
        itemTags.append(button)
        button.setTitle("杂", forState: .Normal)
        button.showsTouchWhenHighlighted = true
        tagsGroupView.addSubview(button)
        button = UIButton()
        itemTags.append(button)
        button.setTitle("❌", forState: .Normal)
        button.showsTouchWhenHighlighted = true
        button.addTarget(self, action: #selector(UIInventoryView.returnButtonPressed), forControlEvents: .TouchUpInside)
        tagsGroupView.addSubview(button)
        tagsGroupView.backgroundColor = UIColor.blackColor()
        commandsGroupView.backgroundColor = UIColor.cyanColor()
        itemListView.backgroundColor = UIColor.blueColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refresh() {
        let tagHeight = frame.height / 10
        let itemListWidth = frame.width * 0.3
        tagsGroupView.anchorAndFillEdge(.Bottom, xPad: 0, yPad: 0, otherSize: tagHeight)
        tagsGroupView.groupAndFill(group: Group.Horizontal, views: itemTags, padding: 10)
        itemListView.alignAndFillHeight(align: Align.AboveMatchingLeft, relativeTo: tagsGroupView, padding: 0, width: itemListWidth)
        itemDescView.align(Align.ToTheRightMatchingTop, relativeTo: itemListView, padding: 0, width: frame.width - itemListWidth, height: itemListView.frame.height / 2)
        commandsGroupView.align(.ToTheRightMatchingBottom, relativeTo: itemListView, padding: 0, width: frame.width - itemListWidth, height: itemListView.frame.height / 2)
        commandsGroupView.groupAndFill(group: .Horizontal, views: itemCommands, padding: 0)
    }
    
    func returnButtonPressed(){
        if let vc = window?.rootViewController {
            vc.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
}
