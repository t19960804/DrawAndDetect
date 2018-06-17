//
//  ViewController.swift
//  DrawTest
//
//  Created by Asabulu International on 2018/5/3.
//  Copyright © 2018年 asa. All rights reserved.
//
//
import UIKit
import TesseractOCR


class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ScratchCardDelegate,G8TesseractDelegate{
    
    //將ScratchCard宣告在外部供調用\G8TesseractDelegate
    var scratchCard : ScratchCard?
    var detectscratchCard : ScratchCard?
    
    var snapShotImage = UIImage()
    
    var selectedImage = UIImage()
    //Outlet
    @IBOutlet weak var clear: UIButton!
    @IBOutlet weak var calculate: UIButton!
    //辨識
    @IBAction func detectImg(_ sender: UIBarButtonItem) {
        
        
        
        snapShotImage =  (scratchCard?.snapshot(of: CGRect(
            x:(scratchCard?.scratchMask.returnValue().smallestX)!,
            y:(scratchCard?.scratchMask.returnValue().smallestY)!,
            width:((scratchCard?.scratchMask.returnValue().xMinus)! ),
            height:((scratchCard?.scratchMask.returnValue().yMinus)!))))!

        
        
        
//        //创建刮刮卡组件
//
//        detectscratchCard = ScratchCard(frame: CGRect(x:0, y:47,
//                    width:((scratchCard?.scratchMask.returnValue().xMinus)! + 50.0),
//                    height:((scratchCard?.scratchMask.returnValue().yMinus)! + 50.0)),
//                    couponImage: UIImage(named: "dark-gray.jpg")!.alpha(0.99),
//                    maskImage: snapShotImage)
//        //设置代理
//        detectscratchCard?.delegate = self
//        detectscratchCard?.couponImageView.image = snapShotImage
//
//        self.view.addSubview(detectscratchCard!)
        
        //取得截圖並且辨識
        
        detect(Image: snapShotImage)
        
    }
    @IBOutlet weak var pictureView: UIImageView!
  
    @IBAction func chooseImage(_ sender: UIBarButtonItem) {
        chooseImg()
    }
    @IBAction func clear(_ sender: UIButton) {
        if detectscratchCard != nil{
            self.detectscratchCard?.removeFromSuperview()
            print("remove success")
        }
        createNewMask()
    }
    @IBAction func calculate(_ sender: UIButton) {
        //使用ScratchCard裡的scratchMask變數的calculate()方法計算面積
        scratchCard?.scratchMask.calculate()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customButton(Button: clear)
        customButton(Button: calculate)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func chooseImg()
    {
        //新增UIImagePickerControllerDelegate/UINavigationControllerDelegate協定
        let photoPickerViewController:UIImagePickerController = UIImagePickerController()
        photoPickerViewController.sourceType = UIImagePickerControllerSourceType.photoLibrary//來源為相簿
        photoPickerViewController.delegate = self
        self.present(photoPickerViewController, animated: true, completion: nil)//開啟相簿
        }
        //選完相片後自動調用
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
        {
            //獲得相片
            selectedImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
            
            picker.dismiss(animated: true, completion: nil)//關閉相簿
            createNewMask()
           
        }
    func createNewMask()
    {

        //创建刮刮卡组件
        scratchCard = ScratchCard(frame: CGRect(x:0, y:47, width:414, height:639),
                                  couponImage: selectedImage,
                                  maskImage: UIImage(named: "dark-gray.jpg")!.alpha(0.99))
        //设置代理
        scratchCard?.delegate = self
        
        
        self.view.addSubview(scratchCard!)
    }
    
    func detect(Image image : UIImage)
    {

        if  let tesseract = G8Tesseract(language:"eng")
        {
            tesseract.delegate = self
            
            
            tesseract.image = image.g8_blackAndWhite()
            

            tesseract.recognize()
            
            print("text:\((tesseract.recognizedText)!)")
        }
        else
        {
            print("none")
        }

        
    }
    //自訂按鈕格式
    func customButton(Button button : UIButton)
    {
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.shadowRadius = 6
    }
    
    //Resize圖片
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width:size.width * heightRatio, height:size.height * heightRatio)
        } else {
            newSize = CGSize(width:size.width * widthRatio,  height:size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
   
}
    //擴充alpha方法
    extension UIImage
    {
        func alpha(_ value:CGFloat) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
        }
        
        
    }
//截圖
extension UIView {
    
    
    
    func snapshot(of rect: CGRect? = nil) -> UIImage? {
        // snapshot entire view
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // if no `rect` provided, return image of whole view
        
        guard let image = wholeImage, let rect = rect else { return wholeImage }
        
        // otherwise, grab specified `rect` of image
        
        let scale = image.scale
        let scaledRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }
}
