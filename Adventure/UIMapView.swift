//
//  UIMapView.swift
//  Adventure
//
//  Created by 苑青 on 2016/11/20.
//  Copyright © 2016年 Eric. All rights reserved.
//

import UIKit

class UIMapControl: UIView {

    var maze:Maze?

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: 0, y: 0)
            if let target = maze {
                let lineWidth:CGFloat = 2
                context.setLineCap(.round)
                context.setLineWidth(lineWidth)
                context.setAllowsAntialiasing(true)
                context.setStrokeColor(UIColor.yellow.cgColor)
                context.beginPath()
                let cellNumber = max(target.width, target.height)
                let cellWidth = (frame.size.width - lineWidth * CGFloat((cellNumber + 1))) / CGFloat(cellNumber)
                for y in 0..<target.height {
                    for x in 0..<target.width {
                        let cell = target[x, y]
                        let leftCorner = CGPoint(x: origin.x + (lineWidth + cellWidth) * x.toCGFloat , y: origin.y + (lineWidth + cellWidth) * y.toCGFloat)
                        if cell.top {
                            context.move(to: leftCorner)
                            context.addLine(to: CGPoint(x: leftCorner.x + cellWidth, y:leftCorner.y))
                        }
                        if cell.right {
                            context.move(to: CGPoint(x: leftCorner.x + cellWidth, y:leftCorner.y))
                            context.addLine(to: CGPoint(x: leftCorner.x + cellWidth, y:leftCorner.y + cellWidth))
                        }
                        if cell.bottom {
                            context.move(to: CGPoint(x: leftCorner.x + cellWidth, y:leftCorner.y + cellWidth))
                            context.addLine(to: CGPoint(x: leftCorner.x, y:leftCorner.y + cellWidth))
                        }
                        if cell.left {
                            context.move(to: CGPoint(x: leftCorner.x, y:leftCorner.y + cellWidth))
                            context.addLine(to: leftCorner)
                        }
                    }
                }
                context.strokePath()
                context.beginPath()
                if let room = TheWorld.ME.environment as? KRoom {
                    if let point = room.roomDesc?.dungeonCoordinate {
                        let center = CGPoint(x: origin.x + (lineWidth + cellWidth) * point.x, y: origin.y + (lineWidth + cellWidth) * point.y)
                    //context.move(to: center)
                        context.setStrokeColor(UIColor.red.cgColor)
                        context.setFillColor(UIColor.green.cgColor)
                        context.fillEllipse(in: CGRect(origin: center, size: CGSize(width: cellWidth, height: cellWidth)))
                    }
                }
            }
            context.strokePath()
        }
    }
}

class UIMapView: UIView {
    var map = UIMapControl()
    var title = UILabel()
    override func refresh() {
        title.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: 18)
        map.alignAndFill(align: .underCentered, relativeTo: title, padding: 5)
    }
    
    init(m: Maze, frame: CGRect){
        super.init(frame: frame)
        backgroundColor = UIColor.white
        title.text = m.name
        title.textAlignment = .center
        map.maze = m
        addSubview(map)
        addSubview(title)
        refresh()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
