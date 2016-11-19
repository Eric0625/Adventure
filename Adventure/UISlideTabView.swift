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
    
    fileprivate var slideViews = Dictionary<String, UIView>()
    fileprivate var tags = [Frameable]()//标签组，只用于标签数据的存放
    fileprivate var tagView = UIView()//标签栏
    fileprivate var currentView:UIView?
 
    func addView(_ view: UIView, name: String) {
        slideViews[name] = view
        addSubview(view)
        view.isHidden = true
        let l = UIButton()
        l.setTitle(name, for: UIControlState())
        l.addTarget(self, action: #selector(UISlideTabView.tagTouched(_:)), for: .touchUpInside)
        tagView.addSubview(l)
        tags.insert(l, at: tags.count-1)//添加在关闭按钮之前
        refresh()
    }
    
    override func refresh(){
        let buttonHeight = frame.height * 0.1
        tagView.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: buttonHeight)//底部按钮
        tagView.groupAndFill(group: .horizontal, views: tags, padding: 3)
        for view in slideViews.values {
            view.alignAndFillHeight(align: .aboveCentered, relativeTo: tagView, padding: 0, width: frame.width)
            view.refresh()
        }
    }
    
    init(subView: UIView, viewName: String, rect: CGRect){
        super.init(frame: rect)
        //添加关闭按钮
        let button = UIButton()
        button.setTitle("❌", for: .normal)
        button.addTarget(self, action: #selector(UISlideTabView.closeView), for: .touchUpInside)
        tagView.addSubview(button)
        tags.append(button)
        addSubview(tagView)
        currentView = subView
        addView(subView, name: viewName)
        subView.isHidden = false//第一个view一定可见
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tagTouched(_ sender: UIButton){
        let title = sender.titleLabel!.text!
        if let view = slideViews[title] {
            if view !== currentView {
                currentView?.isHidden = true
                currentView = view
                currentView?.isHidden = false
            }
        }
    }
    
    func closeView(){
        findViewController()?.dismiss(animated: true, completion: nil)
    }
}

///eric's extension of uiview
extension UIView {
    func refresh(){
        
    }
    
    func findViewController() -> UIViewController? {
        var target:UIResponder? = self
        while target != nil {
            target = target?.next
            if target is UIViewController {
                return target as? UIViewController
            }
        }
        return nil
    }
}
