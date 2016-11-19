//
//  UIProfessionView.swift
//  Adventure
//
//  Created by Eric on 16/11/3.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

fileprivate class RecipeCell: UITableViewCell{
    var recipe:STRecipe?
}

///人物专业技能面板
class UIProfessionView: UIView, UITableViewDataSource, UITableViewDelegate, DisplayMessageDelegate, StatusUpdateDelegate{

    var buttons = [UIButton]()
    var buttonsRowView = UIView()//显示专业按钮的行
    var buttonProduce = ProgressButton(with: UIColor.green)
    var recipeList = UITableView() //制造清单
    var recipeDescView = UITextView() //配方说明
    var productView = UITextView() //产品说明
    var currentSkill: KProSkill!
    
    init(){
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
        TheWorld.instance.displayMessageHandler.append(self)
        TheWorld.instance.statusUpdateHandler.append(self)
        addSubview(recipeDescView)
        recipeDescView.backgroundColor = UIColor.black
        recipeDescView.isEditable = false
        addSubview(recipeList)
        addSubview(productView)
        productView.isEditable = false
        buttonProduce.setTitle("制  造", for: .normal)
        buttonProduce.setTitle("无法制造", for: .disabled)
        buttonProduce.setBackgroundColor(UIColor.gray, forState: .disabled)
        buttonProduce.addTarget(self, action: #selector(UIProfessionView.produceButtonTapped), for: .touchUpInside)
        buttonProduce.showsTouchWhenHighlighted = true
        buttonProduce.contentHorizontalAlignment = .center
        buttonProduce.isEnabled = false
        addSubview(buttonProduce)
    
        //初始化专业按钮，如果只有一个专业那么不显示
        currentSkill = TheWorld.ME.proSkills[0]//这是由UIPlayerView里的逻辑保证的，只要初始化了就一定有专业
        if TheWorld.ME.proSkills.count > 1 {
            for skill in TheWorld.ME.proSkills {
                let b = UIButton()
                b.setTitle(skill.name, for: .normal)
                buttonsRowView.addSubview(b)
                buttons.append(b)
                b.addTarget(self, action: #selector(UIProfessionView.skillButtonTapped(sender:)), for: .touchUpInside)
            }
            addSubview(buttonsRowView)
        }
        
        recipeList.delegate = self
        recipeList.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier="identifier";
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? RecipeCell
        if(cell == nil){
            cell = RecipeCell(style: UITableViewCellStyle.value1, reuseIdentifier: identifier)
        }
        let recipe = currentSkill.recipes[indexPath.row]
        //确定该配方可制造的数量
        let number = currentSkill.calculateProductNumber(recipe: recipe)
        var displayText = recipe.name
        if number > 0 {
            displayText += "(\(number))"
        }
        cell?.textLabel?.text = displayText
        cell?.recipe = recipe
        return cell!

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentSkill.recipes.count
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func renderRecipeDescView(with recipe:STRecipe) {
        var desc = recipe.name + "\n" + recipe.outComeDescribe
        desc += "\n需要：\n"
        var canProduce = true
        for ingre in recipe.ingredients {
            //计算材料数量
            let iname = ingre.key
            var color = KColors.HIG
            if let ingEnt = TheWorld.ME.findEntity(withName: iname) {
                if ingEnt.amount < ingre.value {
                    color = KColors.HIR
                    canProduce = false
                }
            } else {
                canProduce = false
                color = KColors.HIR
            }
            desc += iname + "：" + color + ingre.value.toString + "\n" + KColors.NOR
        }
        recipeDescView.attributedText = processFormattedString(desc)
        buttonProduce.isEnabled = canProduce
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RecipeCell{
            if let recipe = cell.recipe {
                renderRecipeDescView(with: recipe)
            }
        }
    }
    
    override func refresh() {
        let tagHeight = frame.height / 10
        let recipeListWidth = frame.width * 0.35
        if TheWorld.ME.proSkills.count > 1 {
            buttonsRowView.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: tagHeight)
            buttonsRowView.groupAndFill(group: .horizontal, views: buttons, padding: 10)
            buttonProduce.alignAndFillWidth(align: .aboveCentered, relativeTo: buttonsRowView, padding: 0, height: tagHeight)
        } else {
            buttonProduce.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: tagHeight)
        }
        recipeList.alignAndFillHeight(align: .aboveMatchingLeft, relativeTo: buttonProduce, padding: 0, width: recipeListWidth)
        recipeDescView.align(.toTheRightMatchingTop, relativeTo: recipeList, padding: 0, width: frame.width - recipeListWidth, height: recipeList.frame.height / 2)
        productView.align(.toTheRightMatchingBottom, relativeTo: recipeList, padding: 0, width: frame.width - recipeListWidth, height: recipeList.frame.height / 2)
        //commandsGroupView.groupAndFill(group: .horizontal, views: itemCommands, padding: 0)
    }
    
    func produceButtonTapped(){
        if let cell = recipeList.cellForRow(at: recipeList.indexPathForSelectedRow!) as? RecipeCell {
            if let recipe = cell.recipe {
                canDisplay = true
                currentSkill.produce(from: recipe.name)
                canDisplay = false
            }
        }
        
    }
    
    func skillButtonTapped(sender: UIButton) {
        if let name = sender.currentTitle {
            if name != currentSkill.name {
                if let skill = TheWorld.ME.proSkills.first(where: {$0.name == name}) {
                    currentSkill = skill
                    recipeList.reloadData()
                    recipeDescView.text = ""
                }
            }
        }
    }
    
    var canDisplay = false
    func displayMessage(_ message: String) {
        if canDisplay {
            let banner = UIBanner(title: "物品制造", subtitle: message, image: UIImage(named: "Icon"),   backgroundColor: UIColor.gray)
            banner.dismissesOnTap = true
            banner.show(duration: 2.0)
        }
    }
    
    func clearAllMessage() {
        //dummy function
    }
    
    func statusDidUpdate(_ creature: KCreature, type: CreatureStatusUpdateType, information: AnyObject?) {
        if creature !== currentSkill.owner { return }
        switch type {
        case .dropItem, .getItem:
            let selected = recipeList.indexPathForSelectedRow
            recipeList.reloadData()
            if let index = selected {
                recipeList.selectRow(at: index, animated: false, scrollPosition: .none)
                tableView(recipeList, didSelectRowAt: index)
            }
        default:
            break
        }
    }
}
