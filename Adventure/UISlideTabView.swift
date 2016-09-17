//
//  UISlideTabView.swift
//  Adventure
//
//  Created by 苑青 on 16/7/21.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

//框架的基本原理：
//每个view可以包含子view，子view可动态加入也可在初始化时加入，子view的布局由refresh函数实现，在该函数内，应调用任何继承自自定义view的子view的refresh函数
class UISlideTabView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    private var slideViews = Dictionary<String, UIView>()
    private var tags = [Frameable]()//标签组，只用于标签数据的存放
    private var tagView = UIView()//标签栏
    private var currentView:UIView?
 
    func addView(view: UIView, name: String) {
        slideViews[name] = view
        addSubview(view)
        view.hidden = true
        let l = UIButton()
        l.setTitle(name, forState: .Normal)
        l.addTarget(self, action: #selector(UISlideTabView.tagTouched(_:)), forControlEvents: .TouchUpInside)
        tagView.addSubview(l)
        tags.append(l)
        refresh()
    }
    
    override func refresh(){
        let buttonHeight = frame.height * 0.1
        tagView.anchorAndFillEdge(.Bottom, xPad: 0, yPad: 0, otherSize: buttonHeight)//底部按钮
        tagView.groupAndFill(group: .Horizontal, views: tags, padding: 3)
        for view in slideViews.values {
            view.alignAndFillHeight(align: .AboveCentered, relativeTo: tagView, padding: 0, width: frame.width)
            view.refresh()
        }
    }
    
    init(subView: UIView, viewName: String, rect: CGRect){
        super.init(frame: rect)
        addSubview(tagView)
        currentView = subView
        addView(subView, name: viewName)
        subView.hidden = false//第一个view一定可见
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tagTouched(sender: UIButton){
        let title = sender.titleLabel!.text!
        if let view = slideViews[title] {
            if view !== currentView {
                currentView?.hidden = true
                currentView = view
                currentView?.hidden = false
            }
        }
    }
}

extension UIView {
    func refresh(){
        
    }
}