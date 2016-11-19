//
//  ProgressButton.swift
//  Adventure
//
//  Created by Eric on 16/10/9.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

typealias actionClosure = (_ sender: ProgressButton)->() //按钮的函数调用
//可显示进度的按钮，用法：设置currentProgress和setColor即可
class ProgressButton: UIButton {
    
    var currentProgress: CGFloat = 100{ //100为满
        didSet{
            drawCurrentProgress()
        }
    }
    var action: actionClosure? = nil //链接到按钮上的外部函数调用
    var object:KObject? //用于链接
    
    private var currentBackgroundColor: UIColor = UIColor.yellow.withAlphaComponent(0.5) //进度条的颜色，私有变量，仅可通过setColor设置，透明度永远为0.5
    private var rectLayer: CALayer! = nil
    private var viewCenter: CGPoint {
        return CGPoint(x:bounds.width/2, y: bounds.height/2)
    }

    init(with color: UIColor){
        super.init(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        self.addTarget(self, action: #selector(ProgressButton.activate(sender:)), for: .touchUpInside)
        createRectLayer()
        createShadow()
        setColor(color: color)
    }
    
    init(frame: CGRect, color: UIColor) {
    
        super.init(frame: frame)
        //self.addTarget(self, action: "activate:", forControlEvents: .TouchUpInside)
        createRectLayer()
        createShadow()
        setColor(color: color)
    }
    
    convenience init(size: CGSize, color: UIColor) {
        self.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height), color: color)
    }
    
    required init?(coder aDecoder: NSCoder) {
        currentBackgroundColor = UIColor.white.withAlphaComponent(0.5)
        super.init(coder: aDecoder)
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        drawCurrentProgress()
    }
 
    override func refresh() {
        drawCurrentProgress()
    }
    
    func activate(sender: ProgressButton) {
        self.action?(sender)
    }
    
    // MARK: - Private methods
    func drawCurrentProgress() {
        let percent = 100 / currentProgress
        let rect = CGRect(x: bounds.x, y: bounds.y, w: bounds.width / percent, h: bounds.height)
        rectLayer.backgroundColor = currentBackgroundColor.cgColor
        rectLayer.bounds = rect
    }
    
    //创建进度条层，该层用于显示进度条
    private func createRectLayer() {
        let percent = 100 / currentProgress
        let rect = CGRect(x: bounds.x, y: bounds.y, w: bounds.width / percent, h: bounds.height)        
        rectLayer = CAShapeLayer()
        rectLayer.bounds = rect
        rectLayer.anchorPoint = CGPoint.zero
        rectLayer.backgroundColor = currentBackgroundColor.cgColor
        layer.addSublayer(rectLayer)
    }
    
    private func createShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 2
        self.contentHorizontalAlignment = .left
        self.backgroundColor = UIColor.white
        self.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        self.setTitleColor(UIColor.red, for: .normal)
    }
    
    func setColor(color: UIColor){
        currentBackgroundColor = color.withAlphaComponent(0.5)
    }
}
