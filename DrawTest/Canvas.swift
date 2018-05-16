

import UIKit

class Canvas: UIView {
    var xPointArrays = [CGFloat]()
    var yPointArrays = [CGFloat]()
    //畫筆顏色
    var lineColor = UIColor.black
    
    //畫筆粗細
    var lineWidth:CGFloat = 10
    //兩點間路徑
    var path:UIBezierPath!
    //觸碰點
    var touchPoint:CGPoint!
    //起始點
    var startingPoint:CGPoint!

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //取得第一個觸碰
        startingPoint = touches.first?.location(in: self)
        xPointArrays.append(startingPoint.x)
        yPointArrays.append(startingPoint.y)
        print("startX:\(startingPoint.x)  startY:\(startingPoint.y)")
    }
    //手只要沒離開畫面，就會一直呼叫這個方法
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //手一滑動，目前滑動到的點
        touchPoint = touches.first?.location(in: self)
        //建立路徑
        path = UIBezierPath()
        //從 startingPoint，到touchPoint畫一條線
        path.move(to: startingPoint)
        path.addLine(to: startingPoint)
        //能從斷點繼續畫
        startingPoint = touchPoint

        draw()
        xPointArrays.append(startingPoint.x)
        yPointArrays.append(startingPoint.y)
        
        print("moveX:\(touchPoint.x)  moveY:\(touchPoint.y)")
        
        
        
    }
    //著色
    func draw(){
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        //線條顏色
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.opacity = 0.1
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
        //新繪製加入畫好線段的UIView,就會看到畫面上出現了畫出的線段
        self.setNeedsDisplay()
    }
    func clearCanvas(){
        //移除路徑上所有點
        xPointArrays.removeAll()
        yPointArrays.removeAll()

        path.removeAllPoints()
        self.layer.sublayers = nil
        self.setNeedsDisplay()
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
}
