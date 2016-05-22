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
    var allMsg:NSMutableAttributedString = NSMutableAttributedString(string: "")
    var timer:NSTimer!
    
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
        view.addSubview(txtView)
    }
    
    override func viewDidLayoutSubviews() {
        txtView.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTextView()
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
        allMsg.appendAttributedString(m)
        let store = txtView.textStorage as! DynamicTextStorage
        store.appendAttributedString(m)
        //txtView.attributedText = allMsg
        txtView.scrollRectToVisible(CGRectMake(0, txtView.contentSize.height - 10, txtView.contentSize.width, 10), animated: false)
    }
    
    func clearAllMessage(){
        allMsg = NSMutableAttributedString(string: "")
        txtView.attributedText = allMsg
    }
    
    
}

