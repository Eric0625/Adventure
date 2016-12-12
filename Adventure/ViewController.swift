//
//  ViewController.swift
//  Adventure
//
//  Created by 苑青 on 16/4/23.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit
import WebKit
import SQLite

class ViewController: UIViewController, DisplayMessageDelegate, UITextViewDelegate, RoomInfoUpdateDelegate, StatusUpdateDelegate {


    var roomDescribeView:UIRoomDescView!//房间描述窗口
    //var txtStorage: DynamicTextStorage!
    var buttonGroupView = UIView()//菜单等常用按钮
    var statusButton = UIButton()//“菜单”
    var observeButton = UIButton()//"地图"
    var roomView = UILabel()//房间抬头标题
    var scrollView = UITextView()//中部滚动窗口
    
    var roomInventoryView = RoomInventoryView()//房间中物品、人物选择栏
    var personalPanel = PersonalPanel()//人物血量、姓名、内力等显示面板
    var combatListView = UICombatListView()//战斗对手列表面板
   // var allMsg:NSMutableAttributedString = NSMutableAttributedString(string: "")
    var timer:Timer!
    let containerView : UIView = UIView()//界面主容器
    
    //创建描述房间的区块
    func createDescView() {
        // 1. Create the text storage that backs the editor
        //let attrString = NSAttributedString()
        //txtStorage = DynamicTextStorage()
        //txtStorage.appendAttributedString(attrString)
        
        let newTextViewRect = view.bounds
        
        // 2. Create the layout manager
        let layoutManager = NSLayoutManager()
        // 3. Create a text container
        let containerSize = CGSize(width: newTextViewRect.width, height: CGFloat.greatestFiniteMagnitude)
        let container = NSTextContainer(size: containerSize)
        container.widthTracksTextView = true
        layoutManager.addTextContainer(container)
        //txtStorage.addLayoutManager(layoutManager)
        
        // 4. Create a UITextView
        roomDescribeView = UIRoomDescView()
        roomDescribeView.backgroundColor = UIColor.black
        roomDescribeView.delegate = self
        roomDescribeView.isEditable = false
        roomDescribeView.isSelectable = false
        containerView.addSubview(roomDescribeView)
        //roomDescribeView.createMenu(containerView)
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
        roomView.textAlignment = .center
        roomView.backgroundColor = UIColor(red: 78/255.0, green: 102/255.0, blue: 131/255.0, alpha: 1.0)
    
        containerView.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.black
        scrollView.layoutManager.allowsNonContiguousLayout = false
        scrollView.isEditable = false
        scrollView.isSelectable = false
        
        containerView.addSubview(roomInventoryView)
        
        containerView.addSubview(personalPanel)
        
        containerView.addSubview(combatListView)

    }
    
    //创建界面上按钮
    func createButtons(){
        containerView.addSubview(buttonGroupView)
        statusButton.setTitle("菜  单", for: .normal)
        statusButton.backgroundColor = UIColor.brown
        buttonGroupView.addSubview(statusButton)
        observeButton.setTitle("地  图", for: .normal)
        observeButton.backgroundColor = UIColor.gray
        observeButton.addTarget(self, action: #selector(ViewController.mapButtonTapped), for: .touchUpInside)
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
        let personalHeight = view.frame.height * 0.15
        buttonGroupView.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: buttonHeight)//底部按钮
        buttonGroupView.groupAndFill(group: .horizontal, views: [statusButton, observeButton], padding: 0)
        personalPanel.alignAndFillWidth(align: .aboveCentered, relativeTo: buttonGroupView, padding: 0, height: personalHeight)//人物状态
        personalPanel.refresh()
        roomView.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: buttonHeight)//房间名
        if TheWorld.ME.isInFighting == true {
            combatListView.isHidden = false
            roomDescribeView.isHidden = true
            combatListView.alignAndFillWidth(align: .underCentered, relativeTo: roomView, padding: 0, height: roomDescHeight)//房间描述
            combatListView.refresh()
            roomInventoryView.alignAndFillWidth(align: .underCentered, relativeTo: combatListView, padding: 0, height: roomInventoryHeight)//房间内可互动物体
        } else {
            combatListView.isHidden = true
            roomDescribeView.isHidden = false
            roomDescribeView.alignAndFillWidth(align: .underCentered, relativeTo: roomView, padding: 0, height: roomDescHeight)//房间描述
            roomInventoryView.alignAndFillWidth(align: .underCentered, relativeTo: roomDescribeView, padding: 0, height: roomInventoryHeight)//房间内可互动物体
        }
        roomInventoryView.groupButtons()
        scrollView.alignBetweenVertical(align: Align.underCentered, primaryView: roomInventoryView, secondaryView: personalPanel, padding: 0, width: view.frame.width)//滚动显示夹在上下固定高度的区块中间，高度不定
    }
    
    func testDB() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        print(path)
        let db = try! Connection("\(path)/data.db")
        let users = Table("users")
        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let email = Expression<String>("email")
        do {
        try db.run(users.create { t in
            t.column(id, primaryKey: true)
            t.column(name)
            t.column(email, unique: true)
        })
        } catch {
            return
        }
        // CREATE TABLE "users" (
        //     "id" INTEGER PRIMARY KEY NOT NULL,
        //     "name" TEXT,
        //     "email" TEXT NOT NULL UNIQUE
        // )
        
        let insert = users.insert(name <- "Alice", email <- "alice@mac.com")
        let rowid = try? db.run(insert)
        // INSERT INTO "users" ("name", "email") VALUES ('Alice', 'alice@mac.com')
        
        for user in try! db.prepare(users) {
            print("id: \(user[id]), name: \(user[name]), email: \(user[email])")
            // id: 1, name: Optional("Alice"), email: alice@mac.com
        }
        // SELECT * FROM "users"
        
        let alice = users.filter(id == rowid!)
        
        _ = try! db.run(alice.update(email <- email.replace("mac.com", with: "me.com")))
        // UPDATE "users" SET "email" = replace("email", 'mac.com', 'me.com')
        // WHERE ("id" = 1)
        
        _ = try! db.run(alice.delete())
        // DELETE FROM "users" WHERE ("id" = 1)
        
        _ = try! db.scalar(users.count) // 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //读取文件的代码
//        let path = Bundle.main.path(forResource: "city", ofType: "txt")
//        let data = try? Data(contentsOf: URL(fileURLWithPath: path!))
//        let string = String(data: data!, encoding: .utf8)
//        print(string ?? "error")
        //读取数据库
        //testDB()
        createFramework()
        TheWorld.instance.displayMessageHandler.append(self)
        TheWorld.instance.roomInfoHandler.append(self)
        TheWorld.instance.statusUpdateHandler.append(self)
        timer = Timer.scheduledTimer(timeInterval: TheWorld.worldInterval,
                                                       target:self,selector:#selector(ViewController.tickDown(_:)),
                                                       userInfo:nil,repeats:true)
        TheRoomEngine.instance.move(TheWorld.ME, toRoomWithRoomID: TheRoomEngine.instance.roomIndex["高-土路1"]!)
    }

    func tickDown(_ timer: Timer) {
        TheWorld.instance.HeartBeat()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        print(message.body)
    }
    
    func displayMessage(_ message:String){
        scrollView.textStorage.append(processFormattedString(message))
        scrollView.scrollRectToVisible(CGRect(x: 0, y: scrollView.contentSize.height - 10, width: scrollView.contentSize.width, height: 10), animated: false)
    }
    
    func clearAllMessage(){
        scrollView.attributedText = NSMutableAttributedString(string: "")
    }
    
    //发生时机：进入房间，房间内人物走动，拾取物品，物品消失/产生
    func processRoomInfo(_ room: KRoom, entity: KEntity?, type: RoomInfoUpdateType) {
        switch type {
        case .newRoom:
            roomView.attributedText = processFormattedString(room.title)
            roomDescribeView.attributedText = processFormattedString(room.getLongDescribe())
            roomInventoryView.changeRoom(room)
        case .newEntity:
            if let r = roomInventoryView.room {
                if r === room {
                    roomInventoryView.addEntity(entity!)
                }
            }
        case .removeEntity:
            if let r = roomInventoryView.room {
                if r === room {
                    roomInventoryView.removeEntity(entity!)
                }
            }
        case .updateEntity:
            if let r = roomInventoryView.room {
                if r === room {
                    roomInventoryView.updateEntity(entity!)
                }
            }
        }
    }
    
    //当人物状态发生变化时调用，目前使用进出战斗切换界面
    func statusDidUpdate(_ creature: KCreature, type: CreatureStatusUpdateType, information: AnyObject?) {
        if creature !== TheWorld.ME { return }
        switch type {
        case .intoFight, .outFight:
            viewWillLayoutSubviews()
        default:
            break
        }
    }
    
    func mapButtonTapped() {

        if let room = TheWorld.ME.environment as? KRoom {
            if room.dungeonID != -1 {
                let map = UIMapView(m: TheDungeonEngine.instance.mazes[room.dungeonID], frame: CGRect(x: 0, y: 0, width: 200, height: 200))
                PopupContainer.generatePopupWithView(view: map).show()
            }
        }
    }
}

