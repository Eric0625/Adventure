//
//  InventoryView.swift
//  Adventure
//
//  Created by 苑青 on 16/7/29.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit
fileprivate class ItemCell: UITableViewCell{
    var entity:KEntity?
}

///背包物品面板，左侧物品列表，右侧上方物品描述，下方操作按钮，最下方切换物品类型以及返回
///应支持容器嵌套

class UIInventoryView: UIView,UITableViewDataSource, UITableViewDelegate, StatusUpdateDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    //以下为物品列表所用的数据源和delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier="identifier"
        var cell:ItemCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? ItemCell
        if(cell == nil){
            cell = ItemCell(style: UITableViewCellStyle.value1, reuseIdentifier: identifier)
        }
        if let inv = TheWorld.ME._entities {
            var itemString = inv[indexPath.row].name
            if let item = inv[indexPath.row] as? KEquipment {
                if item.isEquipped {
                    itemString += "＊"
                }
            }
            cell?.textLabel?.adjustsFontSizeToFitWidth = true
            cell?.textLabel?.attributedText = processFormattedString(itemString)
            cell?.entity = inv[indexPath.row]
        } else {
            cell?.textLabel?.text = "无物品"
            cell?.entity = nil
        }
        //cell?.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let inv = TheWorld.ME._entities {
            return inv.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ItemCell {
            currentSelectedItemCell = cell
            if let ent = cell.entity {
                currentIndexOfEntity = TheWorld.ME._entities!.index(of: ent)! //记录下序号，当物品离开玩家时可以顺序移动到下一个物品
                renderDescAndCommandView(with: ent)
            } else {
                commandsGroupView.removeSubviews()
            }
        }
    }
    
    func renderDescAndCommandView(with ent: KEntity) {
        itemDescView.attributedText = processFormattedString(ent.describe)
        commandsGroupView.removeSubviews()
        if let item = ent as? KItem {
            let itemStrings = item.availableCommands.chineseStrings
            var tempButtons = [Frameable]()
            for i in 0..<itemStrings.count {
                let button = itemCommands[i]
                button.setTitle("\(itemStrings[i])", for: .normal)
                button.isHidden = false
                button.object = item
                tempButtons.append(button)
                commandsGroupView.addSubview(button)
            }
            
            if tempButtons.count > 0 {
                commandsGroupView.groupAndFill(group: .horizontal, views: tempButtons, padding: 0)
            }
        }
    }
    
    
    var itemListView = UITableView()
    var itemDescView = UITextView()
    var commandsGroupView = UIView()
    var itemCommands = [ProgressButton]()
    var tagsGroupView = UIView()
    var itemTags = [UIButton]()
    var weightBar = UILabel()//重量
    var coinBar = UILabel()//金钱
    private var currentSelectedItemCell: ItemCell?//当前选中物品
    var currentIndexOfEntity: Int = -1

    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        itemListView.delegate = self
        itemListView.dataSource = self
        backgroundColor = UIColor.yellow
        addSubview(itemListView)
        addSubview(itemDescView)
        itemDescView.isEditable = false
        itemDescView.backgroundColor = UIColor.black
        itemDescView.textColor = KColors.toUIColor(input: KColors.GRN)
        addSubview(commandsGroupView)
        addSubview(tagsGroupView)
        addSubview(weightBar)
        weightBar.backgroundColor = UIColor.darkGray
        weightBar.textColor = UIColor.white
        weightBar.adjustsFontSizeToFitWidth = true
        renderWeight()
        addSubview(coinBar)
        coinBar.backgroundColor = UIColor.darkGray
        coinBar.textAlignment = .right
        coinBar.textColor = UIColor.white
        coinBar.adjustsFontSizeToFitWidth = true
        renderWealth()
        //初始化物品命令按钮，有10个供使用
        for _ in 1...10 {
            let button = ProgressButton(with: UIColor.blue)
            button.currentProgress = 0
            button.action = processCommandButton
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.showsTouchWhenHighlighted = true
            commandsGroupView.addSubview(button)
            button.isHidden = true
            itemCommands.append(button)
            
        }
        var button = UIButton()
        itemTags.append(button)
        button.setTitle("全", for: UIControlState())
        button.showsTouchWhenHighlighted = true
        tagsGroupView.addSubview(button)
        button = UIButton()
        itemTags.append(button)
        button.setTitle("装", for: UIControlState())
        button.showsTouchWhenHighlighted = true
        tagsGroupView.addSubview(button)
        button = UIButton()
        itemTags.append(button)
        button.setTitle("材", for: UIControlState())
        button.showsTouchWhenHighlighted = true
        tagsGroupView.addSubview(button)
        button = UIButton()
        itemTags.append(button)
        button.setTitle("杂", for: UIControlState())
        button.showsTouchWhenHighlighted = true
        tagsGroupView.addSubview(button)
        tagsGroupView.backgroundColor = UIColor.black
        commandsGroupView.backgroundColor = UIColor.brown
        itemListView.backgroundColor = UIColor.blue
        TheWorld.instance.statusUpdateHandler.append(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func refresh() {
        let tagWidth: CGFloat = 32
        let statusHeight = frame.height / 12
        let itemListWidth = frame.width * 0.3
        weightBar.anchorInCorner(.bottomLeft, xPad: 0, yPad: 0, width: frame.width / 2, height: statusHeight)
        coinBar.alignAndFillWidth(align: .toTheRightMatchingTop, relativeTo: weightBar, padding: 0, height: statusHeight)
        tagsGroupView.alignAndFillHeight(align: .aboveMatchingLeft, relativeTo: weightBar, padding: 0, width: tagWidth)
        tagsGroupView.groupAndFill(group: .vertical, views: itemTags, padding: 1)
        itemListView.alignAndFillHeight(align: .toTheRightMatchingTop, relativeTo: tagsGroupView, padding: 0, width: itemListWidth)
        itemDescView.align(.toTheRightMatchingTop, relativeTo: itemListView, padding: 0, width: frame.width - itemListWidth, height: itemListView.frame.height / 2)
        commandsGroupView.align(.toTheRightMatchingBottom, relativeTo: itemListView, padding: 0, width: frame.width - itemListWidth, height: itemListView.frame.height / 2)
        //commandsGroupView.groupAndFill(group: .horizontal, views: itemCommands, padding: 0)
    }
    
    func processCommandButton(button: ProgressButton) {
        //获取命令
        let cmd = ItemCommands(string: button.title(for: .normal)!)
        //能处理命令的一定至少是item
        let item = button.object as! KItem
        item.processCommand(cmd)
    }
    
    func statusDidUpdate(_ creature: KCreature, type: CreatureStatusUpdateType, information: AnyObject?) {
        if creature !== TheWorld.ME { return }
        switch type {
        case .equip :
            let einfo = information as! EquipmentChangeInfo
            for cell in itemListView.visibleCells {
                let iCell = cell as! ItemCell
                if let ent = iCell.entity {
                    if ent === einfo.new {
                        iCell.textLabel?.attributedText = processFormattedString(einfo.new.name + "＊")
                        if iCell === currentSelectedItemCell {
                            renderDescAndCommandView(with: ent)
                        }
                    }
                    if let oldeqp = einfo.old {
                        if oldeqp === ent {
                            iCell.textLabel?.attributedText = processFormattedString(oldeqp.name)
                            if iCell === currentSelectedItemCell {
                                renderDescAndCommandView(with: ent)
                            }
                        }
                    }
                }
            }
        case .unequip :
            let equipment = information as! KEquipment
            for c in itemListView.visibleCells {
                let cell = c as! ItemCell
                if cell.entity === equipment {
                    cell.textLabel?.attributedText = processFormattedString(equipment.name)
                    if cell === currentSelectedItemCell {
                        renderDescAndCommandView(with: equipment)
                    }
                }
            }
        case .dropItem:
            itemListView.reloadData()
            itemDescView.text.removeAll()
            //按顺序选中下一个物品
            let droppedItem = information as! KEntity
            var newSelectedItem:KEntity?
            //如果是当前选中的物品，再去自动选择下一个，否则刷新后再选中当前物品
            if droppedItem === currentSelectedItemCell?.entity {
                if let inv = TheWorld.ME._entities {
                    //如果是最后一个，选择第一个
                    if currentIndexOfEntity > inv.lastIndex(of: inv.last!)! {
                        newSelectedItem = inv.first
                    }else {
                        newSelectedItem = inv[currentIndexOfEntity]//因为物品已经丢弃，直接选中当前index的物品就是下一个物品
                    }
                }
            } else { //不是当前物品被丢弃，刷新后重新选择该物品
                newSelectedItem = currentSelectedItemCell?.entity
            }
            itemListView.reloadData()
            if let item = newSelectedItem {
                //寻找该物品并选中
                if let row = TheWorld.ME._entities!.index(of: item) {
                    let indexpath = IndexPath.init(row: row, section: 0)
                    itemListView.selectRow(at: indexpath, animated: true, scrollPosition: .none)
                    tableView(itemListView, didSelectRowAt: indexpath)
                }
            }
            renderWeight()
        case .getItem:
            //先记住当前物品(如果有的话)，刷新后再选中当前物品（如果当前物品已经不在了，顺延至下一个)
            let newSelectedItem = currentSelectedItemCell?.entity
            var row:IndexPath = IndexPath(row:0, section: 0)
            itemListView.reloadData()
            if newSelectedItem?.environment === TheWorld.ME {
                //当前物品还在，那么继续选中该物品
                if let inv = TheWorld.ME._entities {
                    row = IndexPath(row: inv.index(of: newSelectedItem!)!, section: 0)
                }
            } else {//当前物品不在身上，顺延至下一个
                if let inv = TheWorld.ME._entities {
                    if currentIndexOfEntity < inv.count {//由于物品已经不在，代表其的index也就代表了下一个物品
                        row = IndexPath(row: currentIndexOfEntity, section: 0)
                    }
                }
            }
            itemListView.selectRow(at: row, animated: true, scrollPosition: .none)
            tableView(itemListView, didSelectRowAt: row)
            renderWeight()
        default:
            break
        }
    }
    
    func renderWeight(){
        let per = Double(TheWorld.ME.usedCapacity * 100) / Double(TheWorld.ME.allCapacity)
        var color = KColors.White
        if per > 100 { color = KColors.HIR }
        let pString = color + cutZeroesAtTail(String(format: "%.2f", per)) + KColors.NOR
        let message = KColors.White + (TheWorld.ME.usedCapacity / 1.KG).toString + "公斤（\(pString)%）" + KColors.NOR
        weightBar.attributedText = processFormattedString(message)
    }
    
    func renderWealth(){
        let money = TheWorld.ME.money
        if money == 0 {
            coinBar.text = "身无分文"
        } else {
            var message = ""
            let gold = money.gold
            let silver = money.silver
            let coin = money.coin
            if gold != 0 {
                message = "\(gold)金"
            }
            if silver != 0 {
                message += "\(silver)银"
            }
            if coin != 0 {
                message += "\(coin)铜"
            }
            coinBar.text = message
        }
    }
}
