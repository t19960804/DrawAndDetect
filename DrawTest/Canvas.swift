

import UIKit

class Canvas: UIView {

    //畫筆顏色
    var lineColor = UIColor.red
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
    }
    //手只要沒離開畫面，就會一直呼叫這個方法
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //手一滑動，目前滑動到的點
        touchPoint = touches.first?.location(in: self)
        //建立路徑
        path = UIBezierPath()
        //從 startingPoint，到touchPoint畫一條線
        path.move(to: startingPoint)
        path.addLine(to: touchPoint)
        //能從斷點繼續畫
        startingPoint = touchPoint

        draw()
    }
    //著色
    func draw(){
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        //線條顏色
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(shapeLayer)
        //新繪製加入畫好線段的UIView,就會看到畫面上出現了畫出的線段
        self.setNeedsDisplay()
    }
    func clearCanvas(){
        //移除路徑上所有點
        path.removeAllPoints()
        self.layer.sublayers = nil
        self.setNeedsDisplay()
    }
}
