//
//  MeController.swift
//  redcircle
//
//  Created by zhan on 16/4/5.
//  Copyright © 2016年 zhan. All rights reserved.
//

import UIKit
import Alamofire
import ImagePickerSheetController
import Photos

class MeController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var tableData: NSMutableArray?
    
    var photoData: NSData?
    
    
    override init(style: UITableViewStyle) {
        super.init(style: UITableViewStyle.Grouped)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
        self.title = "我的"
        
        let userDic = NSUserDefaults.standardUserDefaults().objectForKey("USER_INFO")
        let cellModel1 = CellModel()
        cellModel1.title = "手机"
        cellModel1.desc = userDic!["mePhone"] as! String
        
        let cellModel2 = CellModel()
        cellModel2.title = "性别"
        cellModel2.desc = userDic!["sex"] as! String
        
        let cellModel3 = CellModel()
        cellModel3.title = "姓名"
        cellModel3.desc = userDic!["name"] as! String
        
        let cellModel4 = CellModel()
        cellModel4.title = "退出登录"
        cellModel4.desc = ""
        
        let cellModel5 = CellModel()
        cellModel5.title = "头像"
        cellModel5.image = AppDelegate.baseURLString + "/downPhotoByPhone?mePhone=" + (userDic!["mePhone"] as! String)
        let cellModel6 = CellModel()
        cellModel6.title = "红圈"
        cellModel6.desc = ""
        
        let cellModel7 = CellModel()
        cellModel7.title = "朋友圈"
        cellModel7.desc = ""
        
        let cellModel8 = CellModel()
        cellModel8.title = "相册"
        cellModel8.desc = ""
        
        
        
        
        
        
        self.tableData = NSMutableArray()
        
        
        let sectionArray1 = NSMutableArray()
        sectionArray1.addObject(cellModel1)
        sectionArray1.addObject(cellModel3)
        sectionArray1.addObject(cellModel2)
        
        let sectionArray2 = NSMutableArray()
        sectionArray2.addObject(cellModel4)
        
        let sectionArray3 = NSMutableArray()
        sectionArray3.addObject(cellModel5)
        
        let sectionArray4 = NSMutableArray()
        sectionArray4.addObject(cellModel6)
        sectionArray4.addObject(cellModel7)
        sectionArray4.addObject(cellModel8)

        self.tableData?.addObject(sectionArray3)
        self.tableData?.addObject(sectionArray4)
        self.tableData?.addObject(sectionArray1)
        self.tableData?.addObject(sectionArray2)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"userInfoChange",
            name: "USER_INFO_CHANGE", object: nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (self.tableData?.count)!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionArray = self.tableData![section]
        return (sectionArray.count)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellModel = (self.tableData![indexPath.section] as! NSArray)[indexPath.row] as! CellModel
        let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: nil)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = cellModel.title
        cell.detailTextLabel?.text = cellModel.desc
        
        
        
        if(indexPath.section == 0) {
            
            
            let imageView = UIImageView(image: nil)
            cell.contentView.addSubview(imageView)
            cell.accessoryType = UITableViewCellAccessoryType.None

            
            imageView.snp_makeConstraints(closure: { (make) in
                make.centerY.equalTo(cell.contentView)
                make.right.equalTo(cell.contentView).offset(-18)
                make.height.equalTo(60)
                make.width.equalTo(60)
            })
            
            Alamofire.request(.GET, cellModel.image).response { (request, response, data, error) in
                imageView.image = UIImage(data: data!, scale:1)
            }
            
            
            
        }
        
        return cell

    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0) {
            return 80
        } else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath);
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 2) {
            let cellModel = (self.tableData![indexPath.section] as! NSArray)[indexPath.row] as! CellModel
            let modifyController = ModifyController()
            modifyController.subTitle = cellModel.title
            modifyController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(modifyController, animated: true)
        } else if (indexPath.section == 3) {
            let loginController = LoginController()
            let loginNavController = UINavigationController(rootViewController: loginController)
            UIView.transitionFromView(self.view, toView: loginController.view, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromLeft, completion: { (Bool) -> Void in
                ((UIApplication.sharedApplication().delegate) as! AppDelegate).window?.rootViewController = loginNavController
            })
            
            let appDomain = NSBundle.mainBundle().bundleIdentifier
            NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain!)

        } else if(indexPath.section == 0) {
            self.pickPhoto()
        } else if(indexPath.section == 1) {
            let meCircle = MeCircleController()
            if(indexPath.row == 0) {
                meCircle.circleLevel = "2"
            } else if (indexPath.row == 1) {
                meCircle.circleLevel = "1"
            } else if (indexPath.row == 2) {
                meCircle.circleLevel = "0"
            }
            
            
            meCircle.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(meCircle, animated: true)
        }

    }
    
    func userInfoChange () {
        self.viewDidLoad()
        self.tableView.reloadData()
    }
    
    func uploadPhoto() {
        
//        Alamofire.upload(.POST, AppDelegate.baseURLString + "/uploadPhoto", multipartFormData: { multipartFormData -> Void in
//            /**
//             - parameter imageData: NSData representation of your image
//             - parameter name: String of the name to associated with the data in the Content-Disposition HTTP header. To use an HTML example, "image" in the following code: <input type="file" name="image">
//             - parameter fileName: String of the name that you are giving the image file, an example being image.jpeg
//             - parameter mimeType: String of the type of file you are uploading (image/jpeg, image/png, etc)
//             **/
//            multipartFormData.appendBodyPart(data:"15891739884".dataUsingEncoding(NSUTF8StringEncoding)! , name: "name")
//            multipartFormData.appendBodyPart(data: self.photoData!, name: "image", fileName: "file", mimeType: "image/jpeg")
//            multipartFormData.appendBodyPart(data: self.photoData!, name: "image", fileName: "thumbnail", mimeType: "image/jpeg")
//            }, encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .Success(let upload, _, _):
//                    upload.responseJSON { response in
//                        debugPrint(response)
//                    }
//                case .Failure(let encodingError):
//                    print(encodingError)
//                }
//        })
        let fileStr = NSHomeDirectory() + "/Documents/photo_temp.png"
        let fileURL = NSURL(fileURLWithPath: fileStr)
        
        let thumbnailFileStr = NSHomeDirectory() + "/Documents/photo_temp_thumbnail.png"
        let thumbnailFileURL = NSURL(fileURLWithPath: thumbnailFileStr)
        
        let userDic = NSUserDefaults.standardUserDefaults().objectForKey("USER_INFO")
        let mePhone = userDic!["mePhone"] as! String + ".png"
        
//        let fileURL = NSBundle.mainBundle().URLForResource("photo_temp", withExtension: "png")
        Alamofire.upload(
            .POST,
            AppDelegate.baseURLString + "/uploadPhoto",
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(data:  mePhone.dataUsingEncoding(NSUTF8StringEncoding)!, name: "name")
                multipartFormData.appendBodyPart(fileURL: fileURL, name: "file")
                multipartFormData.appendBodyPart(fileURL: thumbnailFileURL, name: "thumbnail")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        
                        self.updateUser()
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
    
    
    
    func updateUser() {
        let userDic = NSUserDefaults.standardUserDefaults().objectForKey("USER_INFO")
        let mePhone = userDic!["mePhone"] as! String
        let parameters = [
            "mePhone": mePhone
        ]
        Alamofire.request(.POST, AppDelegate.baseURLString + "/login", parameters: parameters, encoding: .JSON).responseJSON { response in
            if response.result.isSuccess {
                let userDic = response.result.value as? NSDictionary
                NSUserDefaults.standardUserDefaults().setObject(userDic, forKey: "USER_INFO")
                NSNotificationCenter.defaultCenter().postNotificationName("USER_INFO_CHANGE", object: self)

                self.userInfoChange()
            }
        }
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
                let originalImage = controller.selectedImageAssets[0];

                originalImage .requestContentEditingInputWithOptions(.None, completionHandler: { (contentEditingInput, info) in
                    print(contentEditingInput!.fullSizeImageURL)
                })
                
                let options = PHImageRequestOptions()
                options.resizeMode = PHImageRequestOptionsResizeMode.Exact
                options.deliveryMode = PHImageRequestOptionsDeliveryMode.Opportunistic
                
                PHImageManager.defaultManager().requestImageForAsset(originalImage, targetSize: CGSizeMake(600, 600), contentMode: .AspectFill, options: options, resultHandler: { (image, info) in
                    
                    print(image)
                    
//                    let imageData = UIImagePNGRepresentation(image!)
//                    self.photoData = imageData


                    let filePath:String = NSHomeDirectory() + "/Documents/photo_temp.png"
                    let data:NSData = UIImagePNGRepresentation(image!)!
                    data.writeToFile(filePath, atomically: true)
                    
                    

                })
                
                PHImageManager.defaultManager().requestImageForAsset(originalImage, targetSize: CGSizeMake(120, 120), contentMode: .AspectFill, options: options, resultHandler: { (image, info) in
                    
                    print(image)
                    
                    let filePath:String = NSHomeDirectory() + "/Documents/photo_temp_thumbnail.png"
                    let data:NSData = UIImagePNGRepresentation(image!)!
                    data.writeToFile(filePath, atomically: true)
                    
                    
                    
                })
                
                self.uploadPhoto()

                
                
                
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
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print(image)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print(info)
        

        
        picker.dismissViewControllerAnimated(true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //压缩图片尺寸
        UIGraphicsBeginImageContext(CGSizeMake(600, 600))
        image.drawInRect(CGRect(x: 0, y: 0, width: 600, height: 600))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        let filePath:String = NSHomeDirectory() + "/Documents/photo_temp.png"
        let data:NSData = UIImagePNGRepresentation(newImage)!
        data.writeToFile(filePath, atomically: true)
        
        
        //压缩图片尺寸
        UIGraphicsBeginImageContext(CGSizeMake(120, 120))
        image.drawInRect(CGRect(x: 0, y: 0, width: 120, height: 120))
        let thumbnail: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        let thumbnailFilePath:String = NSHomeDirectory() + "/Documents/photo_temp_thumbnail.png"
        let thumbnailData:NSData = UIImagePNGRepresentation(thumbnail)!
        thumbnailData.writeToFile(thumbnailFilePath, atomically: true)
        
        self.uploadPhoto()

    }
    

}
