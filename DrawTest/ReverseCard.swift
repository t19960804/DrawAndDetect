

import UIKit
@objc protocol ReverseCardDelegate {
    @objc optional func scratchBegan(point: CGPoint)
    @objc optional func scratchMoved(progress: Float)
    @objc optional func scratchEnded(point: CGPoint)
}
class ReverseCard: UIView {

    //////////////////////////////////////////////
    //涂层
    var reverseMask: ReverseMask!
    //底层券面图片
    var couponImageView: UIImageView!
    
    //刮刮卡代理对象
    weak var delegate: ReverseCardDelegate?
        {
        didSet
        {
            reverseMask.delegate = delegate
        }
    }
    
    public init(frame: CGRect, couponImage: UIImage, maskImage: UIImage,
                scratchWidth: CGFloat = 25, scratchType: CGLineCap = .square) {
        super.init(frame: frame)
        
        
        //        let childFrame = CGRect(x: 0, y: 10, width: 414,
        //                                height: 649)
        let childFrame = CGRect(x:10,
                                y:20,
                                width:393,
                                height:619)
        
        
        //添加底层券面
        couponImageView = UIImageView(frame: childFrame)
        couponImageView.image = couponImage
        self.addSubview(couponImageView)
        
        //添加涂层
        reverseMask = ReverseMask(frame: childFrame)
        reverseMask.image = maskImage
        reverseMask.lineWidth = scratchWidth
        reverseMask.lineType = scratchType
        self.addSubview(reverseMask)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
