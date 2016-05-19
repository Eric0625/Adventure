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
    let msg = "*<style type*=\"text/css\">body {background-color: black; color:green} a{text-decoration:none} .red {color: darkred}" + ".orange {color: orange} .green {color: green} " + ".black{color: black} .mag {color: magenta} .cyn {color: cyan} .hig {color:limegreen}" + ".hiy {color:yellow} .hir{color:red} .hiw{color:white} .wht{color:whitesmoke} .purple{color:purple}" + ".chatmsg{color:lightslategray } .hic{color:lightseagreen} .blu{color:mediumblue}" + ".hib{color:#0000f0} .yel{color:olive} .hip{color:magenta} .pink{color:pink}" + "</style><body></body>"
    var timer:NSTimer!
    
    func createTextView() {
        // 1. Create the text storage that backs the editor
        let attrs = [NSFontAttributeName : UIFont.preferredFontForTextStyle(UIFontTextStyleBody), NSForegroundColorAttributeName: UIColor.greenColor()]
        let attrString = NSAttributedString(string: msg, attributes: attrs)
        txtStorage = DynamicTextStorage()
        txtStorage.appendAttributedString(attrString)
        
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
        view.addSubview(txtView)
        txtView.textColor = UIColor.greenColor()
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
        let m = NSMutableAttributedString(attributedString: KColors.green(message))
        let pattern = "<color "
        NSRegularExpression
         m.setAttributes([NSForegroundColorAttributeName: UIColor.blueColor()], range: NSMakeRange(2, 7))
       m.setAttributes([NSForegroundColorAttributeName: UIColor.redColor()], range: NSMakeRange(0, 15))
        allMsg.appendAttributedString(m)
        txtView.attributedText = allMsg
    }
    
    func clearAllMessage(){
        allMsg = NSMutableAttributedString(string: "")
        txtView.attributedText = allMsg
   }
    
}

