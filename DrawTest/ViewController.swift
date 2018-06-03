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
    var reverseCard : ReverseCard?
    //Outlet
    @IBOutlet weak var clear: UIButton!
    @IBOutlet weak var calculate: UIButton!
    //辨識
    @IBAction func detectImg(_ sender: UIBarButtonItem) {
        //將pictureView上的原圖用Crop()裁切
        //CGRect(x:最大X點,y:最小Y點,width:最大X點-最小X點,height:最大Y點-最小Y點)
        let resizedImage = self.resizeImage(image:(scratchCard?.couponImageView.image!)!, targetSize: CGSize(width: 414.0, height: 639.0))
        let beCropedImage = crop(image:resizedImage, toRect: CGRect(
            x:((scratchCard?.scratchMask.returnValue().smallestX)!),
            y:((scratchCard?.scratchMask.returnValue().smallestY)!),
            width:(scratchCard?.scratchMask.returnValue().xMinus)!,
            height:(scratchCard?.scratchMask.returnValue().yMinus)!))
        //detect(Image: beCropedImage)
        createReverseMask(Image: beCropedImage)
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
            let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage//獲得相片
            self.pictureView.image = selectedImage//顯示於ImageView
            picker.dismiss(animated: true, completion: nil)//關閉相簿
            createNewMask()
           
        }
    func createNewMask()
    {

        //创建刮刮卡组件
        scratchCard = ScratchCard(frame: CGRect(x:0, y:47, width:414, height:639),
                                  couponImage: pictureView.image!,
                                  maskImage: UIImage(named: "dark-gray.jpg")!.alpha(0.9))
        //设置代理
        scratchCard?.delegate = self
        
        
        self.view.addSubview(scratchCard!)
    }
    //剪裁後新組件
    func createReverseMask(Image image: UIImage)
    {
        
//        //创建刮刮卡组件

//        reverseCard = ReverseCard(frame: CGRect(
//            x:(scratchCard?.scratchMask.returnValue().smallestX)!,
//            y:(scratchCard?.scratchMask.returnValue().smallestY)! + 47.0,
//            width:((scratchCard?.scratchMask.returnValue().xMinus))!,
//            height:((scratchCard?.scratchMask.returnValue().yMinus))!),
//            couponImage: UIImage(named: "dark-gray.jpg")!.alpha(0.9),
//            maskImage:image)
        reverseCard = ReverseCard(frame: CGRect(
            x:0,
            y:47.0,
            width:((scratchCard?.scratchMask.returnValue().xMinus))!,
            height:((scratchCard?.scratchMask.returnValue().yMinus))!),
                                  couponImage: UIImage(named: "dark-gray.jpg")!.alpha(0.9),
                                  maskImage:image)
        
            
        
        //设置代理
        reverseCard?.delegate = self
        
        self.view.addSubview(reverseCard!)
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
