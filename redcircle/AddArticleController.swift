//
//  AddArticleController.swift
//  redcircle
//
//  Created by zhan on 16/7/11.
//  Copyright © 2016年 zhan. All rights reserved.
//

import Foundation
import ImagePickerSheetController
import Photos
import SnapKit
import Alamofire


class AddArticleController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var scrollView: UIScrollView!
    var textView: UITextView!
    var collectionView: UICollectionView!
    var imageData : [String]?
    var originalImageArray : [String]?
    var thumbnailImageArray : [String]?
    
    var  heightConstraint: Constraint?
    
    //声明一个闭包
    var myClosure:sendValueClosure?
    //下面这个方法需要传入上个界面的someFunctionThatTakesAClosure函数指针
    func initWithClosure(closure:sendValueClosure?){
        //将函数指针赋值给myClosure闭包，该闭包中涵盖了someFunctionThatTakesAClosure函数中的局部变量等的引用
        myClosure = closure
    }


    override func viewDidLoad() {
        
        
        self.title = "发表心情"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .Done, target: self, action: #selector(AddArticleController.addArticle))
        
        imageData = ["add_article"]
        originalImageArray = []
        thumbnailImageArray = []
        
        scrollView = UIScrollView()
        scrollView.frame = self.view.frame
        scrollView.contentSize = CGSize(width: self.view.frame.height, height: 300)
        scrollView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(scrollView)
        
    
        textView = UITextView()
        textView.backgroundColor = UIColor.clearColor()
        textView.text = "分享您的喜怒哀乐..."
        textView.delegate = self
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout.init());
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "CommandCell")
        collectionView.backgroundColor = UIColor.clearColor()
        
        scrollView.addSubview(textView)
        scrollView.addSubview(collectionView)
    

        textView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).offset(72)
            make.leading.equalTo(self.view).offset(8)
            make.trailing.equalTo(self.view).offset(-8)
            make.height.equalTo(100)
        }
        
        collectionView.snp_makeConstraints { (make) in
            make.top.equalTo(textView.snp_bottom).offset(8)
            make.leading.equalTo(self.view).offset(8)
            make.trailing.equalTo(self.view).offset(-8)
            heightConstraint = make.height.equalTo(300).constraint
        }
        
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(80, 80)
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (self.imageData?.count)!
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let identify:String = "CommandCell"
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            identify, forIndexPath: indexPath) as UICollectionViewCell
        
        
        let imageView = UIImageView()
        
        let addImage = self.imageData![indexPath.row]

        if indexPath.row == (self.imageData?.count)!-1 {
            imageView.image = UIImage(named: addImage)
        } else {
            imageView.image = UIImage(contentsOfFile: addImage)
        }
        
        
        cell.contentView.addSubview(imageView)
        
        imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(cell.contentView).inset(UIEdgeInsetsMake(2, 2, 2, 2))
        }
        
    
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == (self.imageData?.count)!-1 {
            self.pickPhoto()
        }
    }

    
    func addArticle() -> Void {

        let userDic = NSUserDefaults.standardUserDefaults().objectForKey("USER_INFO")
        let mePhone = userDic!["mePhone"] as! String
        let content = self.textView.text
        
        //        let fileURL = NSBundle.mainBundle().URLForResource("photo_temp", withExtension: "png")
        Alamofire.upload(
            .POST,
            AppDelegate.baseURLString + "/addArticle",
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data:  mePhone.dataUsingEncoding(NSUTF8StringEncoding)!, name: "mePhone")
                multipartFormData.appendBodyPart(data:  content.dataUsingEncoding(NSUTF8StringEncoding)!, name: "content")
                
                for index in 0...(self.thumbnailImageArray?.count)!-1 {
                    let fileStr = self.originalImageArray![index]
                    let fileURL = NSURL(fileURLWithPath: fileStr)
                    
                    let thumbnailFileStr = self.thumbnailImageArray![index]
                    let thumbnailFileURL = NSURL(fileURLWithPath: thumbnailFileStr)
                    
                    multipartFormData.appendBodyPart(fileURL: fileURL, name: "sourceList")
                    multipartFormData.appendBodyPart(fileURL: thumbnailFileURL, name: "thumbList")
                
                }
                

            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        
                        self.navigationController?.popViewControllerAnimated(true)
                        
                        //判空
                        if (self.myClosure != nil){
                            //闭包隐式调用someFunctionThatTakesAClosure函数：回调。
                            self.myClosure!(string: "发布成功")
                        }
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        textView.text = ""
    }
    
    
    func pickPhoto() {
        
        let presentImagePickerController: UIImagePickerControllerSourceType -> () = { source in
            let controller = UIImagePickerController()
            controller.delegate = self
            //            controller.allowsEditing = true
            var sourceType = source
            if (!UIImagePickerController.isSourceTypeAvailable(sourceType)) {
                sourceType = .PhotoLibrary
                print("Fallback to camera roll as a source since the simulator doesn't support taking pictures")
            }
            controller.sourceType = sourceType
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
        
        let controller = ImagePickerSheetController(mediaType: .ImageAndVideo)
        controller.addAction(ImagePickerAction(title: NSLocalizedString("拍照", comment: "Action Title"), secondaryTitle: NSLocalizedString("确定选择", comment: "Action Title"), handler: { _ in
            presentImagePickerController(.Camera)
            }, secondaryHandler: { _, numberOfPhotos in
                print("Comment \(numberOfPhotos) photos")
                
                for index in 0...numberOfPhotos-1 {

                    let originalImage = controller.selectedImageAssets[index];
                    
                    originalImage .requestContentEditingInputWithOptions(.None, completionHandler: { (contentEditingInput, info) in
                        print(contentEditingInput!.fullSizeImageURL)
                    })
                    
                    let options = PHImageRequestOptions()
                    options.resizeMode = PHImageRequestOptionsResizeMode.Exact
                    options.deliveryMode = PHImageRequestOptionsDeliveryMode.Opportunistic
                    options.synchronous = true
                    
                    PHImageManager.defaultManager().requestImageForAsset(originalImage, targetSize: CGSizeMake(600, 600), contentMode: .AspectFill, options: options, resultHandler: { (image, info) in
                        
                        print(image)
                        
                        //                    let imageData = UIImagePNGRepresentation(image!)
                        //                    self.photoData = imageData
                        
                        let randomUnique = UtilManager.randomString(32)
                        let filePath:String = NSHomeDirectory() + "/Documents/" + randomUnique 
                        let data:NSData = UIImagePNGRepresentation(image!)!
                        data.writeToFile(filePath, atomically: true)
                        
                        self.originalImageArray?.append(filePath)
                        
                    })
                    
                    PHImageManager.defaultManager().requestImageForAsset(originalImage, targetSize: CGSizeMake(80, 80), contentMode: .AspectFill, options: options, resultHandler: { (image, info) in
                        
                        print(image)
                        
                        let randomUnique = UtilManager.randomString(32)
                        let filePath:String = NSHomeDirectory() + "/Documents/" + randomUnique
                        let data:NSData = UIImagePNGRepresentation(image!)!
                        data.writeToFile(filePath, atomically: true)
                        
                        self.thumbnailImageArray?.append(filePath)
                        self.imageData?.insert(filePath, atIndex: 0)
                        
                    })
                    
                    
                    
                }
                
                self.collectionView.reloadData()

                
        }))
        controller.addAction(ImagePickerAction(title: NSLocalizedString("从相册中选取", comment: "Action Title"), secondaryTitle: NSLocalizedString("从相册中选取", comment: "Action Title"), handler: { _ in
            presentImagePickerController(.PhotoLibrary)
            }, secondaryHandler: { _, numberOfPhotos in
                presentImagePickerController(.PhotoLibrary)
                print("Send \(controller.selectedImageAssets)")
        }))
        
        controller.addAction(ImagePickerAction(title: NSLocalizedString("取消", comment: "Action Title"), style: .Cancel, handler: { _ in
            print("Cancelled")
        }))
        
        presentViewController(controller, animated: true, completion: nil)
    }
    
}