//
//  OpenImageSelectionOption.swift
//  PassengerApp
//
//  Created by ADMIN on 16/05/17.
//  Copyright © 2017 V3Cube. All rights reserved.
//

import UIKit
import AVFoundation
import CropViewController

class OpenImageSelectionOption: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate, MyBtnClickDelegate {
    
    typealias ImageUploadCompletionHandler = (_ isImageUpload:Bool) -> Void
    typealias ImageSelectedCompletionHandler = (_ isImageSelected:Bool) -> Void
    
    var uv:UIViewController!

    let generalFunc = GeneralFunctions()
    
    var overlayView:UIView!
    var selectionAreaView:UIView!
    
    var loadingDialog:NBMaterialLoadingDialog!
    
    var imageUploadCompletionHandler:ImageUploadCompletionHandler!
    var imageSelectedCompletionHandler:ImageSelectedCompletionHandler!
    
    var prescriptionUpload = false
    var selectedFileData:Data!
    
    init(uv: UIViewController) {
        self.uv = uv
        super.init()
    }
    
    func setImageSelectionHandler(imageSelectedCompletionHandler:@escaping ImageSelectedCompletionHandler){
        self.imageSelectedCompletionHandler = imageSelectedCompletionHandler
    }
    
    func show(imageUploadCompletionHandler:@escaping ImageUploadCompletionHandler){
        
        self.imageUploadCompletionHandler = imageUploadCompletionHandler
        
        let chooseImageOptionView = self.generalFunc.loadView(nibName: "ChooseImageOptionView")
        
        chooseImageOptionView.alpha = 0
        chooseImageOptionView.frame = CGRect(x:0, y: Application.screenSize.height - 210, width: Application.screenSize.width, height: 220)
        let overlayView = UIView()
        overlayView.frame = CGRect(x:0, y: 0, width: self.uv.view.frame.width, height: Application.screenSize.height)
        overlayView.backgroundColor = UIColor.black
        overlayView.alpha = 0.4
        self.overlayView = overlayView
        
        //self.uv.view.addSubview(overlayView)
        
        //self.uv.view.addSubview(overlayView)
        chooseImageOptionView.layer.shadowOpacity = 0.5
        chooseImageOptionView.layer.shadowOffset = CGSize(width: 0, height: 3)
        chooseImageOptionView.layer.shadowColor = UIColor.black.cgColor
        chooseImageOptionView.layer.cornerRadius = 14
        
        self.selectionAreaView = chooseImageOptionView
        
       // self.uv.view.addSubview(chooseImageOptionView)
        let currentWindow = Application.window
        if(self.uv == nil){
            currentWindow?.addSubview(overlayView)
            currentWindow?.addSubview(chooseImageOptionView)
        }else if(self.uv.navigationController != nil){
            self.uv.navigationController?.view.addSubview(overlayView)
            self.uv.navigationController?.view.addSubview(chooseImageOptionView)
            // self.uv.navigationController?.navigationBar.layer.zPosition = -1
        }else{
            self.uv.view.addSubview(overlayView)
            self.uv.view.addSubview(chooseImageOptionView)
        }
    
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            overlayView.alpha = 0.4
            chooseImageOptionView.alpha = 1
        })
       
        (chooseImageOptionView.subviews[0]).layer.shadowOpacity = 0.7
        (chooseImageOptionView.subviews[0]).layer.shadowOffset = CGSize.zero
        (chooseImageOptionView.subviews[0]).layer.shadowColor = UIColor.lightGray.cgColor
        
         (((chooseImageOptionView.subviews[0]).subviews[0]).subviews[1] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CAMERA")
        
        let cameraTapGue = UITapGestureRecognizer()
        cameraTapGue.addTarget(self, action: #selector(self.cameraTapped))
        ((chooseImageOptionView.subviews[0]).subviews[0]).isUserInteractionEnabled = true
        ((chooseImageOptionView.subviews[0]).subviews[0]).addGestureRecognizer(cameraTapGue)
        
        (chooseImageOptionView.subviews[0]).subviews[1].layer.shadowOpacity = 0.7
        (chooseImageOptionView.subviews[0]).subviews[1].layer.shadowOffset = CGSize.zero
        (chooseImageOptionView.subviews[0]).subviews[1].layer.shadowColor = UIColor.lightGray.cgColor
        ((chooseImageOptionView.subviews[0]).subviews[1].subviews[1] as! MyLabel).text = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_GALLERY")
        
        let gallaryTapGue = UITapGestureRecognizer()
        gallaryTapGue.addTarget(self, action: #selector(self.gallaryTapped))
        ((chooseImageOptionView.subviews[0]).subviews[1]).isUserInteractionEnabled = true
        ((chooseImageOptionView.subviews[0]).subviews[1]).addGestureRecognizer(gallaryTapGue)
        
        ((chooseImageOptionView.subviews[1]) as! MyButton).setButtonTitle(buttonTitle: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"))
        ((chooseImageOptionView.subviews[1]) as! MyButton).clickDelegate = self
        
        let CameraView:UIView = chooseImageOptionView.viewWithTag(100) as! UIView
        let galleryView:UIView = chooseImageOptionView.viewWithTag(200) as! UIView
        let stackView = chooseImageOptionView.viewWithTag(16) as! UIStackView

        if  Application.screenSize.width <= 320 {
            if let myConstraint = stackView.constraintWith(identifier: "StackHeight"){
                chooseImageOptionView.frame = CGRect(x:0, y: Application.screenSize.height - 190, width: Application.screenSize.width, height: 200)
                myConstraint.constant = 100
                chooseImageOptionView.setNeedsLayout()
                chooseImageOptionView.layoutSubviews()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            CameraView.addShadowWithCornerRadius(cornerRadius: 10, .lightGray, fillColor: .white)
            galleryView.addShadowWithCornerRadius(cornerRadius: 10, .lightGray, fillColor: .white)
        }
    }
    
    func myBtnTapped(sender: MyButton) {
        if(self.overlayView == nil || self.selectionAreaView == nil){
            return
        }
        self.overlayView!.removeFromSuperview()
        self.selectionAreaView!.removeFromSuperview()
    }
    
    @objc func closeSlectionView(){
        if(self.overlayView == nil || self.selectionAreaView == nil){
            return
        }
        self.overlayView!.removeFromSuperview()
        self.selectionAreaView!.removeFromSuperview()
    }
    
    @objc func cameraTapped(){
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized, .notDetermined: callCamera() // Do your stuff here i.e. callCameraMethod()
        case .denied: alertToEncourageCameraAccessInitially(message: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CAMERA_REQUIRE_TXT"))
        default: alertToEncourageCameraAccessInitially(message: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CAMERA_REQUIRE_TXT"))
        }
    }
    
    func alertToEncourageCameraAccessInitially(message:String) {
        let alert = UIAlertController(
            title: self.generalFunc.getLanguageLabel(origValue: "", key: "IMPORTANT"),
            message: message , //"Camera access required for capturing photos!",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT"), style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_ALLOW_CAMERA_TXT"), style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }))
        self.uv.present(alert, animated: true, completion: nil)
    }
    
    func callCamera() {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            
            if(self.uv.isKind(of: PrescriptionUV.self)){
                (self.uv as! PrescriptionUV).imgSelection = true
            }
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.sourceType = .camera
            
            imagePickerController.delegate = self
            
            //            imagePickerController.allowsEditing = true
            
            self.uv.present(imagePickerController, animated: true, completion: nil)
        }else{
            
            generalFunc.setError(uv: self.uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOT_SUPPORT_CAMERA_TXT"))
        }

    }
    
    @objc func gallaryTapped(){
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)){
            
            if(self.uv.isKind(of: PrescriptionUV.self)){
                (self.uv as! PrescriptionUV).imgSelection = true
            }
            
            let imagePickerController = UIImagePickerController()
            
            imagePickerController.sourceType = .photoLibrary
            
            imagePickerController.delegate = self
            
//            imagePickerController.allowsEditing = true
            
            self.uv.present(imagePickerController, animated: true, completion: nil)
        }else{
            generalFunc.setError(uv: self.uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_NOT_SUPPORT_GALLARY_TXT"))
        }
        
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        
        var selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        selectedImage = selectedImage.correctlyOrientedImage()
        
        
        if(selectedImage.size.width < Utils.ImageUpload_MINIMUM_WIDTH || selectedImage.size.height < Utils.ImageUpload_MINIMUM_HEIGHT){
            self.generalFunc.setError(uv: self.uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MIN_RES_IMAGE"))
            return
        }
        
        
        picker.dismiss(animated: true, completion: {
            if(self.prescriptionUpload == true ){
                
                self.selectedFileData = selectedImage.jpegData(compressionQuality: 1.0)!
                
                if(self.imageSelectedCompletionHandler != nil){
                    self.imageSelectedCompletionHandler(true)
                }
                
                self.closeSlectionView()

            }else{
                DispatchQueue.main.async() {
                    let cropViewController = CropViewController(image: selectedImage)
                    cropViewController.delegate = self
                    cropViewController.customAspectRatio = CGSize(width: 1024, height: 1024)
                    
                    cropViewController.aspectRatioLockEnabled = true
                    cropViewController.aspectRatioPickerButtonHidden = true
                    cropViewController.resetAspectRatioEnabled = false
                    cropViewController.showActivitySheetOnDone = false
                    
                    cropViewController.cancelButtonTitle = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_CANCEL_TXT")
                    cropViewController.doneButtonTitle = self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_DONE")
                    self.uv.present(cropViewController, animated: true, completion: nil)
                }
            }
           
        })
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        cropViewController.dismiss(animated: true, completion: {
            DispatchQueue.main.async() {
                if(image.size.width < Utils.ImageUpload_MINIMUM_WIDTH || image.size.height < Utils.ImageUpload_MINIMUM_HEIGHT){
                    self.generalFunc.setError(uv: self.uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: "LBL_MIN_RES_IMAGE"))
                    return
                }else{
                    
                    
                    self.requestUploadImage(image: image.correctlyOrientedImage().cropTo(size: CGSize(width: Utils.ImageUpload_DESIREDWIDTH, height: Utils.ImageUpload_DESIREDHEIGHT)))
                }
            }
        })
    }
    
    func requestUploadImage(image:UIImage){
    
        let userProfileJson = (GeneralFunctions.getValue(key: Utils.USER_PROFILE_DICT_KEY) as! String).getJsonDataDict().getObj(Utils.message_str)
        let SITE_TYPE_DEMO_MSG = userProfileJson.get("SITE_TYPE_DEMO_MSG")
        
//        if let SITE_TYPE = GeneralFunctions.getValue(key: Utils.SITE_TYPE_KEY) as? String{
//            if(SITE_TYPE == "Demo"){
//                self.generalFunc.setError(uv: self.uv, title: "", content: SITE_TYPE_DEMO_MSG)
//                return
//            }
//        }
        
        if let SITE_TYPE = GeneralFunctions.getValue(key: Utils.SITE_TYPE_KEY) as? String{
            if(SITE_TYPE == "Demo" && userProfileJson.get("vEmail") == "rider@gmail.com"){
                self.generalFunc.setError(uv: self.uv, title: "", content: SITE_TYPE_DEMO_MSG)
                return
            }
        }
        
        myImageUploadRequest(image: image)
    }
    
    func myImageUploadRequest(image:UIImage){
        let myUrl = URL(string: CommonUtils.webservice_path)
        
        let request = NSMutableURLRequest(url:myUrl!);
        request.httpMethod = "POST"
        
        let parameters = [
            "type"  : "uploadImage",
            "MemberType"    : Utils.appUserType,
            "iMemberId"    : GeneralFunctions.getMemberd()
        ]
        
        let exeWebServerUrl = ExeServerUrl(dict_data: parameters, currentView: self.uv.view, isOpenLoader: true)
        exeWebServerUrl.currInstance = exeWebServerUrl
        exeWebServerUrl.uploadImage(image:image, completionHandler: { (response) -> Void in
            
            if(response != ""){
                let dataDict = response.getJsonDataDict()
                
                if(dataDict.get("Action") == "1"){
                    GeneralFunctions.saveValue(key: Utils.USER_PROFILE_DICT_KEY, value: response as AnyObject)
                    
                    self.closeSlectionView()
                    
                    if(self.imageUploadCompletionHandler != nil){
                        self.imageUploadCompletionHandler(true)
                    }
                }else{
                    self.generalFunc.setError(uv: self.uv, title: "", content: self.generalFunc.getLanguageLabel(origValue: "", key: dataDict.get("message")))
                }
                
            }else{
                self.generalFunc.setError(uv: self.uv)
            }
        })
        
        
    }
}
