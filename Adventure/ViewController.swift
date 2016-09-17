//
//  ViewController.swift
//  Adventure
//
//  Created by 苑青 on 16/4/23.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, DisplayMessageDelegate, UITextViewDelegate, RoomInfoUpdateDelegate, StatusUpdateDelegate {


    var roomDescribeView:WorldMessageBoardView!
    var txtStorage: DynamicTextStorage!
    var buttonGroupView: UIView = UIView()
    var statusButton: UIButton = UIButton()
    var inventoryButton: UIButton = UIButton()
    var observeButton:UIButton = UIButton()
    var roomView:UILabel = UILabel()
    var scrollView:UITextView = UITextView()
    
    var roomInventoryView:RoomInventoryView = RoomInventoryView()
    var statusView = PersonalPanel()
    
   // var allMsg:NSMutableAttributedString = NSMutableAttributedString(string: "")
    var timer:NSTimer!
    let containerView : UIView = UIView()
    
    func createDescView() {
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
        roomDescribeView = WorldMessageBoardView(frame: newTextViewRect, textContainer: container)
        roomDescribeView.delegate = self
        roomDescribeView.editable = false
        roomDescribeView.selectable = false
        containerView.addSubview(roomDescribeView)
        roomDescribeView.createMenu(containerView)
    }
    
    //创建基本界面框架
    func createFramework(){
        //容器框架
        containerView.clipsToBounds = true
        containerView.backgroundColor = UIColor(red: 61/255.0, green: 61/255.0, blue: 61/255.0, alpha: 1.0)
        view.addSubview(containerView)
        createDescView()
        createButtons()
        //顶部房间名称区块，暂时用UILabel
        containerView.addSubview(roomView)
        roomView.text = "房间名"
        roomView.textAlignment = .Center
        roomView.backgroundColor = UIColor(red: 78/255.0, green: 102/255.0, blue: 131/255.0, alpha: 1.0)
    
        containerView.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.layoutManager.allowsNonContiguousLayout = false
        scrollView.editable = false
        scrollView.selectable = false
        
        containerView.addSubview(roomInventoryView)
        
        containerView.addSubview(statusView)

    }
    
    func inventoryButtonPressed(){
        presentViewController(UIGearInventoryViewController(), animated: true, completion: nil)
    }
    //创建界面上按钮
    func createButtons(){
        containerView.addSubview(buttonGroupView)
        statusButton.setTitle("菜  单", forState: .Normal)
        statusButton.backgroundColor = UIColor.brownColor()
        buttonGroupView.addSubview(statusButton)
        inventoryButton.setTitle("背  包", forState: .Normal)
        inventoryButton.backgroundColor = UIColor.purpleColor()
        inventoryButton.addTarget(self, action: #selector(ViewController.inventoryButtonPressed), forControlEvents: .TouchUpInside)
        buttonGroupView.addSubview(inventoryButton)
        observeButton.setTitle("地  图", forState: .Normal)
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
        let roomDescHeight = view.frame.height * 0.2
        let roomInventoryHeight = view.frame.height * 0.05
        let statusHeight = view.frame.height * 0.35
        buttonGroupView.anchorAndFillEdge(.Bottom, xPad: 0, yPad: 0, otherSize: buttonHeight)//底部按钮
        buttonGroupView.groupAndFill(group: .Horizontal, views: [statusButton, inventoryButton, observeButton], padding: 0)
        statusView.alignAndFillWidth(align: .AboveCentered, relativeTo: buttonGroupView, padding: 0, height: statusHeight)//人物状态
        statusView.refresh()
        roomView.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: buttonHeight)//房间名
        roomDescribeView.alignAndFillWidth(align: .UnderCentered, relativeTo: roomView, padding: 0, height: roomDescHeight)//房间描述
        roomInventoryView.alignAndFillWidth(align: .UnderCentered, relativeTo: roomDescribeView, padding: 0, height: roomInventoryHeight)//房间内可互动物体
        roomInventoryView.groupButtons()
        scrollView.alignBetweenVertical(align: Align.UnderCentered, primaryView: roomInventoryView, secondaryView: statusView, padding: 0, width: view.frame.width)//滚动显示夹在上下固定高度的区块中间，高度不定
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createFramework()
        TheWorld.instance.displayMessageHandler.append(self)
        TheWorld.instance.roomInfoHandler.append(self)
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
        scrollView.textStorage.appendAttributedString(processColorfulString(message))
        scrollView.scrollRectToVisible(CGRectMake(0, scrollView.contentSize.height - 10, scrollView.contentSize.width, 10), animated: false)
    }
    
    func clearAllMessage(){
        scrollView.attributedText = NSMutableAttributedString(string: "")
    }
    
    //发生时机：进入房间，房间内人物走动，拾取物品，物品消失/产生
    func processRoomInfo(room: KRoom, entity: KEntity?, type: RoomInfoUpdateType) {
        switch type {
        case .NewRoom:
            roomView.attributedText = processColorfulString(room.name)
            roomDescribeView.attributedText = processColorfulString(room.getLongDescribe())
            roomInventoryView.changeRoom(room)
        case .NewEntity:
            if let r = roomInventoryView.room {
                if r === room {
                    roomInventoryView.addEntity(entity!)
                }
            }
        case .RemoveEntity:
            if let r = roomInventoryView.room {
                if r === room {
                    roomInventoryView.removeEntity(entity!)
                }
            }
        case .UpdateEntity:
            if let r = roomInventoryView.room {
                if r === room {
                    roomInventoryView.updateEntity(entity!)
                }
            }
        }
    }
    
    func statusDidUpdate(creature: KCreature, type: UserStatusUpdateType, oldValue: AnyObject?) {
        
    }
    
}

