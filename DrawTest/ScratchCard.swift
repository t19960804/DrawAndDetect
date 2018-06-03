//
//  ScratchCard.swift
//  DrawTest
//
//  Created by Asabulu International on 2018/5/15.
//  Copyright © 2018年 asa. All rights reserved.
//

import UIKit
//刮刮卡代理协议
@objc protocol ScratchCardDelegate {
    @objc optional func scratchBegan(point: CGPoint)
    @objc optional func scratchMoved(progress: Float)
    @objc optional func scratchEnded(point: CGPoint)
}
class ScratchCard: UIView {
    
//////////////////////////////////////////////
    //涂层
    var scratchMask: ScratchMask!
    //底层券面图片
    var couponImageView: UIImageView!
    
    //刮刮卡代理对象
    weak var delegate: ScratchCardDelegate?
        {
        didSet
        {
            scratchMask.delegate = delegate
        }
    }
    
    public init(frame: CGRect, couponImage: UIImage, maskImage: UIImage,
                scratchWidth: CGFloat = 35, scratchType: CGLineCap = .square) {
        super.init(frame: frame)
        

//        let childFrame = CGRect(x: 0, y: 10, width: 414,
//                                height: 649)
//        let childFrame = CGRect(x: 10, y: 20, width: 393,
//                                height: 619)
        let couponFrame = CGRect(x: 10, y: 20, width: 393,
                                height: 619)
        let maskFrame = CGRect(x: 10, y: 20, width: 393,
                                height: 619)
        
        //添加底层券面
        couponImageView = UIImageView(frame: couponFrame)
        couponImageView.image = couponImage
        self.addSubview(couponImageView)
        
        //添加涂层
        scratchMask = ScratchMask(frame: maskFrame)
        scratchMask.image = maskImage
        scratchMask.lineWidth = scratchWidth
        scratchMask.lineType = scratchType
        self.addSubview(scratchMask)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
