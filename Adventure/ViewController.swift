//
//  ViewController.swift
//  Adventure
//
//  Created by 苑青 on 16/4/23.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler, DisplayMessageDelegate, WKNavigationDelegate, UITextViewDelegate {

    //@IBOutlet weak var webView: WKWebView!
    var webView:WKWebView?
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
        //let configuretion = WKWebViewConfiguration()
//        
//        // Webview的偏好设置
//        configuretion.preferences = WKPreferences()
//        configuretion.preferences.minimumFontSize = 10
//        configuretion.preferences.javaScriptEnabled = true
//        // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
//        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = false
//        
//        // 通过js与webview内容交互配置
//        configuretion.userContentController = WKUserContentController()
//        
//        // 添加一个JS到HTML中，这样就可以直接在JS中调用我们添加的JS方法
//        let script = WKUserScript(source: "function showAlert() { alert('在载入webview时通过Swift注入的JS方法'); }",
//                                  injectionTime: .AtDocumentStart,// 在载入时就添加JS
//            forMainFrameOnly: true) // 只添加到mainFrame中
//        configuretion.userContentController.addUserScript(script)

        
        
        // 添加一个名称，就可以在JS通过这个名称发送消息：
        // window.webkit.messageHandlers.AppModel.postMessage({body: 'xxx'})
        //configuretion.userContentController.addScriptMessageHandler(self, name: "OOXX")
        // Do any additional setup after loading the view, typically from a nib.
        
       
//        self.webView!.addObserver(self, forKeyPath: "title", options: .New, context: nil)
//        self.webView!.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
          //let rect = CGRect(x: view.bounds.origin.x, y: view.bounds.origin.y + 15, width: view.bounds.size.width, height: view.bounds.size.height - 15)
        //txtView = UITextView(frame: rect)
        //view.addSubview(txtView!)
//        webView = WKWebView(frame: rect)
//        self.webView!.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
//        webView!.loadHTMLString(msg, baseURL: NSURL(string: "clear"))
//        self.view.addSubview(self.webView!);
        TheWorld.instance.displayMessageHandler.append(self)
        timer = NSTimer.scheduledTimerWithTimeInterval(1,
                                                       target:self,selector:#selector(ViewController.tickDown(_:)),
                                                       userInfo:nil,repeats:true)
//        webView?.navigationDelegate = self
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
    
//    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
//        guard let web = webView else { print ("error: webview is nil");return}
//        if !(web.loading) {
//            TheRoomEngine.instance.move(TheWorld.ME, toRoomWithRoomID: 0)
//        }
//    }

    func displayMessage(message:String){
        allMsg.appendAttributedString(NSAttributedString(string: "*"+message+"*"))
        txtView.attributedText = allMsg
//        guard let web = webView else { return }
//        if web.loading { return }
//        let js = "document.body.innerHTML += '\(message)'"
//        web.evaluateJavaScript(js, completionHandler: nil)
//        let rect = CGRect(x: view.bounds.origin.x, y: 100000, width: view.bounds.size.width, height: 10)
//        web.scrollView.scrollRectToVisible(rect, animated: true)
    }
    
    func clearAllMessage(){
        allMsg = NSMutableAttributedString(string: "")
    
        txtView.attributedText = allMsg
//        guard let web = webView else { return }
//        if web.loading { return }
//        web.loadHTMLString(msg, baseURL: NSURL(string: "clear"))
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
       // decisionHandler(WKNavigationActionPolicy.Cancel)
        if navigationAction.request.URL?.absoluteString == "clear"
            { decisionHandler(.Allow) }
        else {
            let actString = navigationAction.request.URL?.absoluteString
            let type = navigationAction.navigationType
            if let str = actString {
                if type == .LinkActivated {
                    //判断点击类型
                    let objectId = str.substringFromIndex(str.startIndex.advancedBy(2))
                    switch str[str.startIndex] {
                    case "d":
                        //是方向
                        if let startRoom = TheWorld.ME.environment as? KRoom {
                            TheRoomEngine.instance.moveFrom(startRoom, throughStringDicrection: objectId, ob: TheWorld.ME)
                        }
                    default:
                        break
                    }
                }                
            }
            decisionHandler(.Cancel) }
    }
    
}

