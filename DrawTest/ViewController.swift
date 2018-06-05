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


class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ScratchCardDelegate,ReverseCardDelegate,G8TesseractDelegate{
    
    //將ScratchCard宣告在外部供調用\G8TesseractDelegate
    var scratchCard : ScratchCard?
    var no2scratchCard : ScratchCard?
    var reverseCard : ReverseCard?
    var snapShotImage = UIImage()
    var selectedImage = UIImage()
    //Outlet
    @IBOutlet weak var clear: UIButton!
    @IBOutlet weak var calculate: UIButton!
    //辨識
    @IBAction func detectImg(_ sender: UIBarButtonItem) {
       
        

        snapShotImage = (scratchCard?.takeSnapshot(
            X:(scratchCard?.scratchMask.returnValue().smallestX)!,
            Y:(scratchCard?.scratchMask.returnValue().smallestY)!,
            Width:((scratchCard?.scratchMask.returnValue().xMinus)! ),
            Height:((scratchCard?.scratchMask.returnValue().yMinus)!)))!
        
//        let cropImage = crop(image: snapShotImage, toRect: CGRect(
//            x:(scratchCard?.scratchMask.returnValue().smallestX)!,
//            y:(scratchCard?.scratchMask.returnValue().smallestY)!,
//            width:(scratchCard?.scratchMask.returnValue().xMinus)!,
//            height:(scratchCard?.scratchMask.returnValue().yMinus)!))
//        print(scratchCard?.scratchMask.returnValue().smallestX)
//        print(scratchCard?.scratchMask.returnValue().smallestY)
        
//        let crop = cropImage(imageToCrop: snapShotImage, toRect: CGRect(
//                        x:(scratchCard?.scratchMask.returnValue().smallestX)!,
//                        y:(scratchCard?.scratchMask.returnValue().smallestY)!,
//                        width:((scratchCard?.scratchMask.returnValue().xMinus)! ),
//                        height:((scratchCard?.scratchMask.returnValue().yMinus)!)))
        
//        let crop = cropImage(imageToCrop: snapShotImage, toRect: CGRect(x: 100, y: 100, width: 800, height: 800))
        
        
        
        //创建刮刮卡组件
         
        scratchCard = ScratchCard(frame: CGRect(x:0, y:47, width:414, height:639),
                                  couponImage: UIImage(named: "dark-gray.jpg")!.alpha(0.99),
                                  maskImage: snapShotImage)
        //设置代理
        scratchCard?.delegate = self
        scratchCard?.couponImageView.image = snapShotImage

        self.view.addSubview(scratchCard!)
        
        //取得截圖並且辨識
        
            //detect(Image: snapShotImage)
    }
    @IBOutlet weak var pictureView: UIImageView!
  
    @IBAction func chooseImage(_ sender: UIBarButtonItem) {
        chooseImg()
    }
    @IBAction func clear(_ sender: UIButton) {
        
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
    //剪裁圖片
    func crop(image : UIImage, toRect: CGRect) -> UIImage
    {
        let cgImage :CGImage = image.cgImage!
        let cropCGImage : CGImage! = cgImage.cropping(to: toRect)
        return UIImage(cgImage: cropCGImage)
        
    }
    func cropImage(imageToCrop:UIImage, toRect rect:CGRect) -> UIImage{
        
        let imageRef:CGImage = imageToCrop.cgImage!.cropping(to: rect)!
        let cropped:UIImage = UIImage(cgImage:imageRef)
        return cropped
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
    func takeSnapshot(X x : CGFloat, Y y : CGFloat,Width width : CGFloat,Height height : CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in:
            CGRect(
                                x:x,
                                y:y,
                                width:width,
                                height:height
                                ), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
