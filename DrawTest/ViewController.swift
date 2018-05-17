//
//  ViewController.swift
//  DrawTest
//
//  Created by Asabulu International on 2018/5/3.
//  Copyright © 2018年 asa. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ScratchCardDelegate {
    
    
    @IBOutlet weak var pictureView: UIImageView!
   
    @IBAction func chooseImage(_ sender: UIBarButtonItem) {
        chooseImg()
    }
    @IBAction func clear(_ sender: UIButton) {
        createNewMask()
    }
    @IBAction func calculate(_ sender: UIButton) {
        
       
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
       
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
        let scratchCard = ScratchCard(frame: CGRect(x:0, y:20, width:400, height:700),
                                      couponImage: pictureView.image!,
                                      maskImage: UIImage(named: "gray.jpg")!.alpha(0.7))
        //设置代理
        scratchCard.delegate = self
        self.view.addSubview(scratchCard)
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
