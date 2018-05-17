//
//  ScratchMask.swift
//  DrawTest
//
//  Created by Asabulu International on 2018/5/15.
//  Copyright © 2018年 asa. All rights reserved.
//

import UIKit

class ScratchMask: UIImageView {
    var xPointArrays = [CGFloat]()
    var yPointArrays = [CGFloat]()
    //代理对象
    weak var delegate: ScratchCardDelegate?
    
    //线条形状
    var lineType:CGLineCap!
    //线条粗细
    var lineWidth: CGFloat!
    
    //觸碰點
    var touchPoint:CGPoint!
    //起始點
    var startingPoint:CGPoint!
    //再绘制线条
    //let path = CGMutablePath()
    var path:UIBezierPath!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //当前视图可交互
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //触摸开始
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        //保存当前点坐标
        startingPoint = touches.first?.location(in: self)
        xPointArrays.append(startingPoint.x)
        yPointArrays.append(startingPoint.y)
        //调用相应的代理方法
        delegate?.scratchBegan?(point: startingPoint!)
        
        
    }
    
    //滑动
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        //手一滑動，目前滑動到的點
        touchPoint = touches.first?.location(in: self)

        //清除两点间的涂层
        eraseMask(fromPoint: startingPoint, toPoint: touchPoint)
        //保存最新触摸点坐标，供下次使用
        
        
        startingPoint = touchPoint
        xPointArrays.append(startingPoint.x)
        yPointArrays.append(startingPoint.y)

        //print("moveX:\(touchPoint.x)  moveY:\(touchPoint.y)")
        print("xPointMoved.count:\(xPointArrays.count)   yPointMoved.count:\(yPointArrays.count)")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //多点触摸只考虑第一点
        guard  touches.first != nil else {
            return
        }
         calculate()
        //调用相应的代理方法
        delegate?.scratchEnded?(point: touchPoint!)
    }
    
    //清除两点间的涂层
    func eraseMask(fromPoint: CGPoint, toPoint: CGPoint) {
        //根据size大小创建一个基于位图的图形上下文
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        
        //先将图片绘制到上下文中
        image?.draw(in: self.bounds)
        
        path = UIBezierPath()
        path.move(to: fromPoint)
        path.addLine(to: toPoint)
       
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(true)
        context.setLineCap(lineType)
        context.setLineWidth(lineWidth)
        context.setBlendMode(.clear) //混合模式设为清除
        context.addPath(path.cgPath)
        context.strokePath()
        
        //将二者混合后的图片显示出来
        image = UIGraphicsGetImageFromCurrentImageContext()
        //结束图形上下文
        UIGraphicsEndImageContext()
    }
    
   
    func calculate()
    {
        let XarraysMax = xPointArrays.sorted(by: >)
        let YarraysMax = yPointArrays.sorted(by: >)
        let XarraysMin = xPointArrays.sorted(by: <)
        let YarraysMin = yPointArrays.sorted(by: <)
        print("XarraysMax:\(XarraysMax[1])")
        print("XarraysMin:\(XarraysMin[1])")
        print("YarraysMax:\(YarraysMax[1])")
        print("YarraysMin:\(YarraysMin[1])")
        print("width:\(XarraysMax[1] - XarraysMin[1])  height:\(YarraysMax[1] - YarraysMin[1])")


    }
    func clear()
    {
        xPointArrays.removeAll()
        yPointArrays.removeAll()
    }
   
    
}

