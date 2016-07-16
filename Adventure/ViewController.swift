//
//  ViewController.swift
//  Adventure
//
//  Created by 苑青 on 16/4/23.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, DisplayMessageDelegate, UITextViewDelegate {


    var txtView:WorldMessageBoardView!
    var txtStorage: DynamicTextStorage!
    var buttonGroupView: UIView = UIView()
    var statusButton: UIButton = UIButton()
    var inventoryButton: PopupMenuView = PopupMenuView()
    var observeButton:UIButton = UIButton()
    var roomView:UILabel = UILabel()
    var roomDescribeView:UITextView = UITextView()
    var roomInventoryView:UILabel = UILabel()
    var statusView:UILabel = UILabel()
    
   // var allMsg:NSMutableAttributedString = NSMutableAttributedString(string: "")
    var timer:NSTimer!
    let containerView : UIView = UIView()
    
    func createTextView() {
        // 1. Create the text storage that backs the editor
        //let attrString = NSAttributedString()
        txtStorage = DynamicTextStorage()
        //txtStorage.appendAttributedString(attrString)
        
        let newTextViewRect = view.bounds
        
        // 2. Create the layout manager
        let layoutManager = NSLayoutManager()
        // 3. Create a text container
        let containerSize = CGSize(width: newTextViewRect.width, height: CGFloat.max)
        let container = NSTextContainer(size: containerSize)
        container.widthTracksTextView = true
        layoutManager.addTextContainer(container)
        txtStorage.addLayoutManager(layoutManager)
        
        // 4. Create a UITextView
        txtView = WorldMessageBoardView(frame: newTextViewRect, textContainer: container)
        txtView.delegate = self
        txtView.editable = false
        txtView.selectable = false
        txtView.layoutManager.allowsNonContiguousLayout = false
        containerView.addSubview(txtView)
        txtView.createMenu(containerView)
    }
    
    //创建基本界面框架
    func createFramework(){
        //容器框架
        containerView.clipsToBounds = true
        containerView.backgroundColor = UIColor(red: 61/255.0, green: 61/255.0, blue: 61/255.0, alpha: 1.0)
        view.addSubview(containerView)
        createTextView()
        createButtons()
        //顶部房间名称区块，暂时用UILabel
        containerView.addSubview(roomView)
        roomView.text = "房间名"
        roomView.textAlignment = .Center
        roomView.backgroundColor = UIColor(red: 78/255.0, green: 102/255.0, blue: 131/255.0, alpha: 1.0)
    
        containerView.addSubview(roomDescribeView)
        roomDescribeView.text = "隐约北方现出一座黑色城楼，光线太暗，看不大清楚。许多亡魂正\n哭哭啼啼地列队前进，因为一进鬼门关就无法再回阳间了。周围尺\n高的野草随风摇摆，草中发出呼呼的风声。\n"
    
        containerView.addSubview(roomInventoryView)
        roomInventoryView.text = "房间内可互动物体"
        
        containerView.addSubview(statusView)
        statusView.text = TheWorld.ME.name

    }
    
    //创建界面上按钮
    func createButtons(){
        containerView.addSubview(buttonGroupView)
        statusButton.setTitle("菜  单", forState: .Normal)
        statusButton.backgroundColor = UIColor.brownColor()
        buttonGroupView.addSubview(statusButton)
        //inventoryButton.("物  品", forState: .Normal)
        let menus = ["Most Popular", "Latest", "Trending", "Nearest", "Top Picks"]
        inventoryButton.backgroundColor = UIColor.purpleColor()
        buttonGroupView.addSubview(inventoryButton)
        observeButton.setTitle("观  察", forState: .Normal)
        observeButton.backgroundColor = UIColor.grayColor()
        buttonGroupView.addSubview(observeButton)
    }
    
    override func viewDidLayoutSubviews() {
        //containerView.frame = view.bounds
    }
    
    //界面排序代码，顺序是自下而上排列
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        containerView.fillSuperview()
        let buttonHeight = view.frame.height * 0.03
        let roomDescHeight = view.frame.height * 0.1
        let roomInventoryHeight = view.frame.height * 0.05
        let statusHeight = view.frame.height * 0.1
        buttonGroupView.anchorAndFillEdge(.Bottom, xPad: 0, yPad: 0, otherSize: buttonHeight)//底部按钮
        buttonGroupView.groupAndFill(group: .Horizontal, views: [statusButton, inventoryButton, observeButton], padding: 0)
        statusView.alignAndFillWidth(align: .AboveCentered, relativeTo: buttonGroupView, padding: 0, height: statusHeight)
        roomView.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: buttonHeight)
        roomDescribeView.alignAndFillWidth(align: .UnderCentered, relativeTo: roomView, padding: 0, height: roomDescHeight)
        roomInventoryView.alignAndFillWidth(align: .UnderCentered, relativeTo: roomDescribeView, padding: 0, height: roomInventoryHeight)
        txtView.alignBetweenVertical(align: Align.UnderCentered, primaryView: roomInventoryView, secondaryView: statusView, padding: 0, width: view.frame.width)
//            //statusButton.anchorInCorner(.BottomLeft, xPad: 0, yPad: 0, width: view.frame.width / 2, height: view.frame.height - txtHeight)
//            //inventoryButton.alignAndFillWidth(align: .ToTheRightMatchingTop, relativeTo: statusButton, padding: 0, height: view.frame.height - txtHeight)
        //txtView.alignAndFillWidth(align: .AboveCentered, relativeTo: buttonGroupView, padding: 0, height: txtHeight)//滚动区域
        //roomDescribeView.alignAndFillWidth(align: .AboveCentered, relativeTo: txtView, padding: 0, height: roomDescHeight)//房间描述
        //roomView.alignAndFillHeight(align: .AboveCentered, relativeTo: roomDescribeView, padding: 0, width: view.frame.width)//房间名
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createFramework()
        TheWorld.instance.displayMessageHandler.append(self)
        timer = NSTimer.scheduledTimerWithTimeInterval(1,
                                                       target:self,selector:#selector(ViewController.tickDown(_:)),
                                                       userInfo:nil,repeats:true)
        TheRoomEngine.instance.move(TheWorld.ME, toRoomWithRoomID: 0)
    }

    func tickDown(timer: NSTimer) {
        TheWorld.instance.HeartBeat()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        print(message.body)
    }
    
    func displayMessage(message:String){
        //处理颜色代码
        var colorInfo = ColorParser()
        let m = NSMutableAttributedString(attributedString: message.color(KColors.colorDictionary["green"]!))
        colorInfo.parseColor(message, from: 0)
        for x in colorInfo.attributes {
            m.setAttributes([NSForegroundColorAttributeName: x.color], range: x.range)
        }
        //删除代码
        repeat{
            let range = m.string.regMatch("^.*?(</color>)", range: NSMakeRange(0, m.string.length))
            if range.isEmpty {break}
            m.replaceCharactersInRange(range[0].rangeAtIndex(1), withString: "")
        }while(true)
        repeat{
            let range = m.string.regMatch("^.*?(<color \\w+>)", range: NSMakeRange(0, m.string.length))
            if range.isEmpty {break}
            m.replaceCharactersInRange(range[0].rangeAtIndex(1), withString: "")
        }while(true)
        //allMsg.appendAttributedString(m)
        let store = txtView.textStorage as! DynamicTextStorage
        store.appendAttributedString(m)
        //txtView.attributedText = allMsg
        txtView.scrollRectToVisible(CGRectMake(0, txtView.contentSize.height - 10, txtView.contentSize.width, 10), animated: false)
    }
    
    func clearAllMessage(){
        txtView.attributedText = NSMutableAttributedString(string: "")
    }
    
    
}

