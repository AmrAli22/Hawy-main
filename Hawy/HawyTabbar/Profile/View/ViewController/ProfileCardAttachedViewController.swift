//
//  ProfileCardAttachedViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 03/10/2022.
//

import UIKit

import UIKit
import TLPhotoPicker
import Photos
import BSImagePicker
import CloudKit
import Alamofire
import Combine
import MediaPlayer
import AVFoundation
import AVKit

class ProfileCardAttachedViewController: BaseViewViewController {
    
    @IBOutlet weak var firstContainerView: UIView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var deleteMainImageButtonOutlet: UIButton!
    //@IBOutlet weak var ImageVideo: UIImageView!
    @IBOutlet weak var containerOfVideoView: UIView!
    @IBOutlet weak var videoView: VideoView!
    @IBOutlet weak var deleteVideoButtonOutlet: UIButton!
    @IBOutlet weak var videoViewWidth: NSLayoutConstraint!
    @IBOutlet weak var thumbleCollectionView: UICollectionView! {
        didSet {
            thumbleCollectionView.dataSource = self
            thumbleCollectionView.delegate = self
            
            thumbleCollectionView.register(UINib(nibName: "PickerPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PickerPhotoCollectionViewCell")
            thumbleCollectionView.register(UINib(nibName: "PickerVideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PickerVideoCollectionViewCell")
        }
    }
    
    var cardId: Int?
    var mainImageData: Data?
    var ImageVideoData: Data?
    var videoURL: URL?
    var isPhoto: Bool = false
    var count = 0
    var libraryType: LibraryType?
    
    var imagesdata = [Images]()
    var myImages:[Data]! = [Data]() // 1
    var selectedAssets = [TLPHAsset]() // 2
    var SelectedAssets = [PHAsset]()
    var photoArray = [UIImage]() // 3
    var videoArray: [URL] = [URL]() // 4
    
    var vidioPicker: ImagePicker!
    
    var mainImmage: String?
    var video: String?
    var images: [String]?
    
    var imageess = [String]()
    
    var finalMainImage: String?
    var finalImagesArray: [String] = []
    var finalVideo: String?
    
    var imagesDataAfterUpdate: [UIImage] = []
    
    var player : AVPlayer!
    var avController = AVPlayerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vidioPicker = ImagePicker(presentationController: self, delegate: self)
        containerOfVideoView.isHidden = true
        videoViewWidth.constant = 0
        deleteVideoButtonOutlet.isHidden = true
        deleteMainImageButtonOutlet.isHidden = true
        
        getCardData(id: cardId, userId: HelperConstant.getUserId() ?? 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        firstContainerView.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoView.player?.pause()
    }
    
    func loadVideo(url: String) {
        
        let url = URL(string: url)
        player = AVPlayer(url: url!)
        avController.player = player
        avController.view.frame.size.height = videoView.frame.size.height
        avController.view.frame.size.width = videoView.frame.size.width
        self.videoView.addSubview(avController.view)
        self.player.play()
        
    }
    
    func getCardData(id: Int?, userId: Int?) {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auth/profile/cards/show?id=\(id ?? 0)&user_id=\(userId ?? 0)", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(ShowCardDetailsModel.self, from: response.data!)
                
                if productResponse.message == "Unauthenticated." {
                    
                    let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                        
                        
                        let story = UIStoryboard(name: "Authentication", bundle:nil)
                        let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                        
                    }
                    //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    //alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                if productResponse.code == 200 {
                    print("success")
                    
                    DispatchQueue.main.async {
                        
                        self.mainImage.loadImage(URLS.baseImageURL+(productResponse.item?.mainImage ?? ""))
                        self.imageess = productResponse.item?.images ?? []
                        
                        for data in productResponse.item?.images ?? [] {
                            
//                            let images = self.imageess.flatMap{ (link)->UIImage? in
//                                guard let url = URL(string: link) else {return nil}
//                                guard let imageData = try? Data(contentsOf: url) else {return nil}
//                                return UIImage(data: imageData)
//                            }
//                            self.imagesDataAfterUpdate = images
                            
//                            let imageViewui = UIImageView()
//                            imageViewui.downloadImage(<#T##URL#>, <#T##UIImage?#>)
                            //let image: UIImage = UIImage(data: <#T##Data#>) //(data: data)!
                            //self.imagesDataAfterUpdate.append(image)

                        }
                        DispatchQueue.main.async {
                            
                            
                            
//                            let hh: [()] = self.imageess.map({
//                                if let imageData = try? Data(contentsOf: URL(string: $0)!) {
//
//                                    self.imagesDataAfterUpdate.append(UIImage(data: imageData)) //= UIImage(data: imageData)
//                                }
//                                //return UIImage(data: imageData)
//                            })
//                            print(hh)
//
//                            print(self.imagesDataAfterUpdate)
                            
                            
                        }
                        
                        let images = self.imageess.compactMap{ (link)->UIImage? in
                            guard let url = URL(string: URLS.baseImageURL+link) else {return nil}
                            guard let imageData = try? Data(contentsOf: url) else {return nil}
                            self.myImages.append(imageData)
                            return UIImage(data: imageData)
                        }
                        
                        print(images)
                        
                        self.imagesDataAfterUpdate = images //.append(contentsOf: images) //= images
                        print(self.imagesDataAfterUpdate)
                        
//
//                        let imagess: [UIImage] = self.imageess.map({ (url) in
//
//                            let image = try? Data(contentsOf: URL(string: url)!)
//                            print(image)
//
//                            return UIImage(data: image!)!
//                        })
//                        print(imagess)
//
                        var imagesss: [UIImage] = []

                        self.imageess.forEach({(url) in
                            print(url)
                            //let data = Data(contentsOf: <#T##URL#>)
                            //let img = UIImage(data: <#T##Data#>)
                            //let img = try? Data(contentsOf: URL(string: url)!)
                            //imagesss.append(UIImage(data: img!)!)

                        })
                        print(imagesss)
                        
                        
                        if productResponse.item?.video == "" || productResponse.item?.video == nil {
                            
                            
                            self.videoView.isHidden = true
                            self.videoViewWidth.constant = 0
                            self.containerOfVideoView.isHidden = true
                            self.deleteVideoButtonOutlet.isHidden = true
                            
                        }else {
                            
                            self.videoView.isHidden = false
                            self.videoViewWidth.constant = 100
                            self.containerOfVideoView.isHidden = false
                            self.deleteVideoButtonOutlet.isHidden = false
                            
                            self.videoView.contentMode = .scaleAspectFill
                            self.videoView.player?.isMuted = true
                            self.videoView.repeat = .once
                            
                            self.videoURL = URL(string: productResponse.item?.video ?? "") //URL(string: "\(movieUrl)")
                            
                            self.videoView.url = self.videoURL
                            self.videoView.player?.play()
                            
                            self.loadVideo(url: productResponse.item?.video ?? "")
                            
                        }
                        
//                        if self.videoURL == nil {
//                            self.containerOfVideoView.isHidden = true
//                        }else {
//                            self.containerOfVideoView.isHidden = false
//                        }
                        
                        self.thumbleCollectionView.reloadData()
                    }
                    
                }
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    func remove(index: Int) {
        imagesDataAfterUpdate.remove(at: index)
        
        let indexPath = IndexPath(row: index, section: 0)
        thumbleCollectionView.performBatchUpdates({
            self.thumbleCollectionView.deleteItems(at: [indexPath])
        }, completion: {
            (finished: Bool) in
            self.thumbleCollectionView.reloadItems(at: self.thumbleCollectionView.indexPathsForVisibleItems)
            self.thumbleCollectionView.reloadData()
        })
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addMainImageButtonAction(_ sender: UIButton) {
        
        self.vidioPicker.present(from: sender)
        
    }
    
    @IBAction func deleteMainImageButtonAction(_ sender: Any) {
        mainImage.image = nil
        deleteMainImageButtonOutlet.isHidden = true
    }
    
    @IBAction func addVideoButtonAction(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "".localized, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera".localized, style: .default) { [weak self] (action) in
            guard let self = self else { return }
            self.count = 0
            self.chooseImagePickerAction(source: .camera)
        }
        
        let photoLibAction = UIAlertAction(title: "Video".localized, style: .default) { [weak self] (action) in
            guard let self = self else { return }
            self.count = 0
            self.chooseImagePickerAction(source: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func deleteVideoButtonAction(_ sender: Any) {
        
        videoView.contentMode = .scaleAspectFill
        videoView.player?.isMuted = true
        videoView.repeat = .once

        videoURL = nil
        if videoURL != nil {
            videoView.url = videoURL
            videoView.player?.play()
        }
        videoView.isHidden = true
        videoViewWidth.constant = 0
        containerOfVideoView.isHidden = true
        deleteVideoButtonOutlet.isHidden = true
        
    }
    
    @IBAction func addImageVideoButtonAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera".localized, style: .default) { [weak self] (action) in
            guard let self = self else { return }
            self.count = 1
            self.chooseImagePickerAction(source: .camera)
        }
        
        let photoLibAction = UIAlertAction(title: "Photo Library".localized, style: .default) { [weak self] (action) in
            guard let self = self else { return }
            //self.count = 1
            //self.libraryType = .photo
            //self.chooseImagePickerAction(source: .photoLibrary)
            
            let imagePicker = ImagePickerController()
            imagePicker.settings.selection.max = 3
            imagePicker.settings.selection.unselectOnReachingMax = true
            imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
            imagePicker.albumButton.tintColor = UIColor.green
            imagePicker.cancelButton.tintColor = UIColor.red
            
            self.presentImagePicker(imagePicker, select: { (asset) in
                print(asset.mediaType)
            }, deselect: { (asset) in
                
            }, cancel: { (assets) in
                
            }, finish: { (assets) in
                
                for i in 0..<assets.count {
                    self.SelectedAssets.append(assets[i])
                }
                self.convertAssetsToImages2()
            })
        }
        
        let photoVidAction = UIAlertAction(title: "Video".localized, style: .default) { [weak self] (action) in
            guard let self = self else { return }
            //self.count = 2
            //self.libraryType = .video
            //self.chooseImagePickerAction(source: .photoLibrary)
            
//            let viewController = CustomPhotoPickerViewController()
//            viewController.delegate = self
//            viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
//                self?.showExceededMaximumAlert(vc: picker)
//            }
//            var configure = TLPhotosPickerConfigure()
//            configure.maxSelectedAssets = 1
//            configure.numberOfColumn = 3
//            configure.allowedPhotograph = false
//            configure.allowedVideoRecording = true
//            configure.mediaType = .video
//            viewController.configure = configure
//            viewController.selectedAssets = self.selectedAssets
//            viewController.logDelegate = self
//
//            self.present(viewController, animated: true, completion: nil)
            
            self.chooseImagePickerAction(source: .photoLibrary)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibAction)
        alertController.addAction(photoVidAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
//        guard mainImageData != nil else {
//            ToastManager.shared.showError(message: "Please, select the main image", view: self.view)
//            return
//        }
//        guard myImages.isEmpty == false else {
//            ToastManager.shared.showError(message: "Please, select images", view: self.view)
//            return
//        }
//        
//        guard myImages.count <= 4 else {
//            ToastManager.shared.showError(message: "Please, select only 4 images", view: self.view)
//            return
//        }
        
        //myImages mainImageData videoURL
        
        //let group = DispatchGroup()
        
        if myImages == nil {
            print("my Images is nil")
        }else{
            
            for i in 0 ..< myImages.count {
                //group.enter()
                addImages(imageData: myImages[i])
            }
            
        }
        
        if self.mainImageData == nil {
            print("main Image is nil")
        }else{
            
            addMainImage()
            
        }
        
        if self.videoURL == nil {
            print("video url is nil")
        }else {
            addVideo()
        }
        
//        if mainImageData == nil {
//            print("main Image is nil")
//        }else{
//            addMainImage()
//        }
//
//        if videoURL == nil {
//            print("video url is nil")
//        }else {
//            addVideo()
//        }
        
        //uploadCard()
        //uploadImages()
        //uploadCard()
        
    }
    
}

extension ProfileCardAttachedViewController {
    func chooseImagePickerAction(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = source
            imagePicker.mediaTypes = ["public.movie"]
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension ProfileCardAttachedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.allowsEditing = true
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        videoView.contentMode = .scaleAspectFill
        videoView.player?.isMuted = true
        videoView.repeat = .once
        
        videoURL = info[convertFromUIImagePickerControllerInfoKey(.mediaURL)] as? URL //URL(string: "\(movieUrl)")
        if videoURL != nil {
            videoView.url = videoURL
            videoView.player?.play()
        }
        videoView.isHidden = false
        videoViewWidth.constant = 100
        containerOfVideoView.isHidden = false
        deleteVideoButtonOutlet.isHidden = false
        
        if videoURL == nil {
            containerOfVideoView.isHidden = true
        }else {
            containerOfVideoView.isHidden = false
        }
        
        //myAccountViewModel.updateImage(imageData: userImageData)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value)} )
    }
    
    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}

extension ProfileCardAttachedViewController: TLPhotosPickerViewControllerDelegate {
    
    @IBAction func pickerButtonTap() {
        let viewController = CustomPhotoPickerViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.delegate = self
        viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
            self?.showExceededMaximumAlert(vc: picker)
        }
        var configure = TLPhotosPickerConfigure()
        configure.maxSelectedAssets = 3
        configure.numberOfColumn = 3
        //configure.mediaType = .image
        viewController.configure = configure
        viewController.selectedAssets = self.selectedAssets
        viewController.logDelegate = self

        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func onlyVideoRecording(_ sender: Any) {
        let viewController = CustomPhotoPickerViewController()
        viewController.delegate = self
        viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
            self?.showExceededMaximumAlert(vc: picker)
        }
        var configure = TLPhotosPickerConfigure()
        configure.maxSelectedAssets = 3
        configure.numberOfColumn = 3
        configure.allowedPhotograph = false
        configure.allowedVideoRecording = true
        configure.mediaType = .video
        viewController.configure = configure
        viewController.selectedAssets = self.selectedAssets
        viewController.logDelegate = self

        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func pickerWithCustomCameraCell() {
        let viewController = CustomPhotoPickerViewController()
        viewController.delegate = self
        viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
            self?.showExceededMaximumAlert(vc: picker)
        }
        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        if #available(iOS 10.2, *) {
            configure.cameraCellNibSet = (nibName: "CustomCameraCell", bundle: Bundle.main)
        }
        viewController.configure = configure
        viewController.selectedAssets = self.selectedAssets
        self.present(viewController.wrapNavigationControllerWithoutBar(), animated: true, completion: nil)
    }
    
    @IBAction func pickerWithCustomBlackStyle() {
        let viewController = CustomBlackStylePickerViewController()
        viewController.modalPresentationStyle = .fullScreen
        viewController.delegate = self
        viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
            self?.showExceededMaximumAlert(vc: picker)
        }
        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        viewController.configure = configure
        viewController.selectedAssets = self.selectedAssets
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func pickerWithNavigation() {
        let viewController = PhotoPickerWithNavigationViewController()
        viewController.delegate = self
        viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
            self?.showExceededMaximumAlert(vc: picker)
        }
        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        viewController.configure = configure
        viewController.selectedAssets = self.selectedAssets
        
        self.present(viewController.wrapNavigationControllerWithoutBar(), animated: true, completion: nil)
    }
    
    @IBAction func pickerWithCustomRules() {
        let viewController = PhotoPickerWithNavigationViewController()
        viewController.delegate = self
        viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
            self?.showExceededMaximumAlert(vc: picker)
        }
        viewController.canSelectAsset = { [weak self] asset -> Bool in
            if asset.pixelHeight != 300 && asset.pixelWidth != 300 {
                self?.showUnsatisifiedSizeAlert(vc: viewController)
                return false
            }
            return true
        }
        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        configure.nibSet = (nibName: "CustomCell_Instagram", bundle: Bundle.main)
        viewController.configure = configure
        viewController.selectedAssets = self.selectedAssets
        
        self.present(viewController.wrapNavigationControllerWithoutBar(), animated: true, completion: nil)
    }
    
    @IBAction func pickerWithCustomLayout() {
        let viewController = TLPhotosPickerViewController()
        viewController.delegate = self
        viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
            self?.showExceededMaximumAlert(vc: picker)
        }
        viewController.customDataSouces = CustomDataSources()
        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        configure.groupByFetch = .day
        viewController.configure = configure
        viewController.selectedAssets = self.selectedAssets
        viewController.logDelegate = self
        self.present(viewController, animated: true, completion: nil)
    }
    
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // use selected order, fullresolution image
        self.selectedAssets = withTLPHAssets
        for i in 0..<selectedAssets.count {
            //self.SelectedAssets.append(assets[i])
            //print(selectedAssets[i].phAsset)
            //print(selectedAssets[i].type)
            
            
            
        }
        
        //convertAssetsToImages()
        
        
        //getFirstSelectedImage()
        //exportVideo()
        //iCloud or video
        //getAsyncCopyTemporaryFile()
    }
    
    func convertAssetsToImages2() -> Void {
           
        if SelectedAssets.count != 0 {
            
            //self.myImages.removeAll()
            //self.imagesDataAfterUpdate.removeAll()
            self.videoArray.removeAll()
            
            for i in 0..<SelectedAssets.count {
                
                let manager = PHImageManager.default()
                let option = PHImageRequestOptions()
                let options = PHFetchOptions()
                var thumbnail = UIImage()
                //var thum = URL(string: "")
                //let videoPredicate = NSPredicate(format: //"mediaType = %d", //PHAssetMediaType.video.rawValue)
                //let imagePredicate = NSPredicate(format: //"mediaType = %d", //PHAssetMediaType.image.rawValue)
                //let predicate = //NSCompoundPredicate//(orPredicateWithSubpredicates: //[videoPredicate, imagePredicate])
                //options.predicate = predicate
                option.isSynchronous = true
                
                manager.requestImage(for: SelectedAssets[i], targetSize: CGSize(width: 100, height: 100), contentMode: PHImageContentMode.aspectFill, options: option, resultHandler: { (result, info) -> Void in
                    thumbnail = result!
                })
                //manager.requestAVAsset(forVideo: //SelectedAssets[i], options: nil) { asset, //audioMix, info in
                //    if let asset = asset as? AVURLAsset {
                //        thum = asset.url
                //        self.videoURL = asset.url
                //        print(self.videoURL)
                //        print(thum)
                //        //self.videoArray.append(self.videoURL ?? //URL(fileURLWithPath: "")) //thum! as //URL
                //        //print(self.videoArray)
                //    }
                //}
                
                //self.videoArray.append(self.videoURL ?? URL(fileURLWithPath: "")) //thum! as URL
                //print(self.videoArray)
                
                let data = thumbnail.jpegData(compressionQuality: 0.7)
                let newImage = UIImage(data: data!)
                self.imagesDataAfterUpdate.append(newImage! as UIImage) //.insert(newImage! as UIImage, at: imagesDataAfterUpdate.count) //
                    // This for send images data to another view cntroller for make request
                self.myImages.append(data!)
                
                self.imagesdata.append(Images(image: data))
                
                }
            
                DispatchQueue.main.async {
                  self.thumbleCollectionView.reloadData()
                }
            
            }
                
        print("complete photo array \(self.imagesDataAfterUpdate) complete video array \(self.videoArray)")
        
        }

    
    func convertAssetsToImages() -> Void {
        
        if selectedAssets.count != 0 {
            
            self.myImages.removeAll()
            self.imagesDataAfterUpdate.removeAll()
            self.videoArray.removeAll()
            
            for i in 0..<selectedAssets.count {
                
                let asset = self.selectedAssets[i]
                if asset.type == .video {
                    asset.exportVideoFile(progressBlock: { (progress) in
                        print(progress)
                    }) { (url, mimeType) in
                        print("completion\(url)")
                        print(mimeType)
                        self.videoArray.append(url)
                        print(self.videoArray)
                    }
                }
                
            }
            
            DispatchQueue.main.async {
                self.thumbleCollectionView.reloadData()
            }
            
        }
        
        print("complete photo array \(self.videoArray)")
    }
    
    func exportVideo() {
        if let asset = self.selectedAssets.first, asset.type == .video {
            asset.exportVideoFile(progressBlock: { (progress) in
                print(progress)
            }) { (url, mimeType) in
                print("completion\(url)")
                print(mimeType)
            }
        }
    }
    
    func getAsyncCopyTemporaryFile() {
        if let asset = self.selectedAssets.first {
            asset.tempCopyMediaFile(convertLivePhotosToJPG: false, progressBlock: { (progress) in
                print(progress)
            }, completionBlock: { (url, mimeType) in
                print("completion\(url)")
                print(mimeType)
            })
        }
    }
    
//    func getFirstSelectedImage() {
//        if let asset = self.selectedAssets.first {
//            if asset.type == .video {
//                asset.videoSize(completion: { [weak self] (size) in
//                    self?.label.text = "video file size\(size)"
//                })
//                return
//            }
//            if let image = asset.fullResolutionImage {
//                print(image)
//                self.label.text = "local storage image"
//                self.imageView.image = image
//            }else {
//                print("Can't get image at local storage, try download image")
//                asset.cloudImageDownload(progressBlock: { [weak self] (progress) in
//                    DispatchQueue.main.async {
//                        self?.label.text = "download \(100*progress)%"
//                        print(progress)
//                    }
//                }, completionBlock: { [weak self] (image) in
//                    if let image = image {
//                        //use image
//                        DispatchQueue.main.async {
//                            self?.label.text = "complete download"
//                            self?.imageView.image = image
//                        }
//                    }
//                })
//            }
//        }
//    }
    
    func dismissPhotoPicker(withPHAssets: [PHAsset]) {
        // if you want to used phasset.
        DispatchQueue.main.async {
            self.thumbleCollectionView.reloadData()
        }
    }

    func photoPickerDidCancel() {
        // cancel
    }

    func dismissComplete() {
        // picker dismiss completion
        //convertAssetsToImages()
        
    }

    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        self.showExceededMaximumAlert(vc: picker)
    }
    
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        picker.dismiss(animated: true) {
            let alert = UIAlertController(title: "", message: "Denied albums permissions granted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        let alert = UIAlertController(title: "", message: "Denied camera permissions granted", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        picker.present(alert, animated: true, completion: nil)
    }

    func showExceededMaximumAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "", message: "Exceed Maximum Number Of Selection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showUnsatisifiedSizeAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "Oups!", message: "The required size is: 300 x 300", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
}

extension ProfileCardAttachedViewController: TLPhotosPickerLogDelegate {
    //For Log User Interaction
    func selectedCameraCell(picker: TLPhotosPickerViewController) {
        print("selectedCameraCell")
    }
    
    func selectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        print("selectedPhoto")
    }
    
    func deselectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        print("deselectedPhoto")
    }
    
    func selectedAlbum(picker: TLPhotosPickerViewController, title: String, at: Int) {
        print("selectedAlbum")
    }
}

extension ProfileCardAttachedViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            return videoArray.count
//        }else {
//            return photoArray.count
//        }
        
//        if imageess.isEmpty == true {
//            return photoArray.count
//        }else {
//            return imageess.count
//        }
        return imagesDataAfterUpdate.count
        
        //return photoArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        if SelectedAssets[indexPath.row].mediaType == .video {
//
//            guard let cell = thumbleCollectionView.dequeueReusableCell(withReuseIdentifier: "PickerVideoCollectionViewCell", for: indexPath) as? PickerVideoCollectionViewCell else { return UICollectionViewCell() }
//
//            let item = videoArray[indexPath.row]
//            cell.videoView.contentMode = .scaleAspectFill
//            cell.videoView.player?.isMuted = true
//            cell.videoView.repeat = .loop
//
//            if !videoArray.isEmpty {
//                cell.videoView.url = item
//                cell.videoView.player?.play()
//            }
//
//            return cell
//
//        }else {
//
//            guard let cell = thumbleCollectionView.dequeueReusableCell(withReuseIdentifier: "PickerPhotoCollectionViewCell", for: indexPath) as? PickerPhotoCollectionViewCell else { return UICollectionViewCell() }
//
//            let item = photoArray[indexPath.row]
//            cell.photoImage.image = item
//
//            return cell
//
//        }
        
        guard let cell = thumbleCollectionView.dequeueReusableCell(withReuseIdentifier: "PickerPhotoCollectionViewCell", for: indexPath) as? PickerPhotoCollectionViewCell else { return UICollectionViewCell() }

//        if imageess.isEmpty == true {
//            let item = photoArray[indexPath.row]
//            cell.photoImage.image = item
//        }else {
//            let item = imageess[indexPath.row]
//            photoArray.append(cell.photoImage.image ?? UIImage())
//            cell.photoImage.loadImage(URLS.baseImageURL+(item))
//        }
        
        let item = imagesDataAfterUpdate[indexPath.row]
        cell.photoImage.image = item
        

//        let item = imageess[indexPath.row]
//        photoArray.append(cell.photoImage.image ?? UIImage())
//        cell.photoImage.loadImage(URLS.baseImageURL+(item))
        cell.photoImage.layer.cornerRadius = 12
        cell.photoImage.layer.masksToBounds = true

        cell.DeleteAction = { [weak self] in

            guard let self = self else { return }
            
            //self.remove(index: indexPath.row)
            //self.SelectedAssets.remove(at: indexPath.row)
            //self.myImages.remove(at: indexPath.row)
            
            if let index = self.imagesDataAfterUpdate.firstIndex(of: self.imagesDataAfterUpdate[indexPath.row]) {
                self.remove(index: index)
            }
            
            if let index3 = self.myImages.firstIndex(of: self.myImages[indexPath.row]) {
                self.myImages.remove(at: index3)
            }
//
//            //self.remove(index: indexPath.row)
//            if self.SelectedAssets.isEmpty == false {
//
//                if let index2 = self.SelectedAssets.firstIndex(of: self.SelectedAssets[indexPath.row]) {
//                    self.SelectedAssets.remove(at: index2)
//                }
//
//                //self.SelectedAssets.remove(at: indexPath.row)
//            }
//            if self.myImages.isEmpty == false {
//
//                if let index3 = self.myImages.firstIndex(of: self.myImages[indexPath.row]) {
//                    self.myImages.remove(at: index3)
//                }
//
//                //self.myImages.remove(at: indexPath.row)
//            }
//            if self.imageess.isEmpty == false {
//
//                if let index4 = self.imageess.firstIndex(of: self.imageess[indexPath.row]) {
//                    self.imageess.remove(at: index4)
//                }
//
//                //self.imageess.remove(at: indexPath.row)
//            }
            //self.imageess.remove(at: indexPath.row)

            //self.photoArray.remove(at: indexPath.row)
            //self.thumbleCollectionView.reloadData()

        }

        return cell
        
//        guard let cell = thumbleCollectionView.dequeueReusableCell(withReuseIdentifier: "PickerPhotoCollectionViewCell", for: indexPath) as? PickerPhotoCollectionViewCell else { return UICollectionViewCell() }
//
//        let item = photoArray[indexPath.row]
//        cell.photoImage.image = item
//        cell.photoImage.layer.cornerRadius = 12
//        cell.photoImage.layer.masksToBounds = true
//
//        cell.DeleteAction = { [weak self] in
//
//            guard let self = self else { return }
//            self.remove(index: indexPath.row)
//            self.SelectedAssets.remove(at: indexPath.row)
//            self.myImages.remove(at: indexPath.row)
//            //self.photoArray.remove(at: indexPath.row)
//            //self.thumbleCollectionView.reloadData()
//
//        }
//
//        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90) //(thumbleCollectionView.frame.size.width / 3) - 10
    }
    
}

extension ProfileCardAttachedViewController: ImagePickerDelegate {
    func selectedPickker(image: UIImage?, picker: UIImagePickerController?) {
        switch picker {
        
        case vidioPicker.pickerController:
            
            mainImage.image = image
            mainImageData = mainImage.image?.jpegData(compressionQuality: 0.3)
            print(mainImageData ?? Data())
            deleteMainImageButtonOutlet.isHidden = false
            
        default:
            print("")
        }
        
    }
}

extension ProfileCardAttachedViewController {
    
    func addMainImage() {
        
        let token = HelperConstant.getToken()
        print(token)
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(token ?? "")"
        ]
        
        Hud.showHud(in: self.view)
        AF.upload(multipartFormData: { (multipartFormData) in
            
            if(self.mainImageData != nil ) {
                multipartFormData.append(self.mainImageData ?? Data() , withName: "main_image", fileName: "image.jpg", mimeType: "image/jpg")
            }
        }, to: "https://hawy-kw.com/api/auth/profile/cards/files/add" , headers: headers)
        .validate(statusCode: 200...500)
        .responseJSON { (response) in
            print(response)
            if let data = response.data {
                print(data)
                do {
                    let addPostResponse = try JSONDecoder().decode(UploadImagesAndVideoModel.self, from: data)
                    
                    if addPostResponse.message == "Unauthenticated." {
                        
                        let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                            
                            
                            let story = UIStoryboard(name: "Authentication", bundle:nil)
                            let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                            
                        }
                        //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                        alert.addAction(okAction)
                        //alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    if addPostResponse.code == 200 {
                        
                        self.finalMainImage = addPostResponse.item?.mainImage
                        
                        self.performUploadMainImage(final: self.finalMainImage)
                        
                    }else if let message = addPostResponse.message {
                        print(message)
                    }
                    Hud.dismiss()
                } catch {
                    print(error)
                    Hud.dismiss()
                }
            }
            
        }
        
    }
    
    func addImages(imageData: Data?) {
        
        let token = HelperConstant.getToken()
        print(token)
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(token ?? "")"
        ]
        
        Hud.showHud(in: self.view)
        AF.upload(multipartFormData: { (multipartFormData) in
            
            if imageData != nil {
                multipartFormData.append(imageData ?? Data() , withName: "images[]", fileName: "image.jpg", mimeType: "image/jpg")
            }
            
//            if self.photoArray.isEmpty == false {
//                print(self.photoArray)
//                print(self.myImages)
//                for (image) in self.photoArray {
//
//                    if  let imageData = image.jpegData(compressionQuality: 0.3) {
//                        multipartFormData.append(imageData , withName: "images[]", fileName: "image\(image).jpg", mimeType: "image/jpg")
//                    }
//                }
//            }
            
        }, to: "https://hawy-kw.com/api/auth/profile/cards/files/add" , headers: headers)
        .validate(statusCode: 200...500)
        .responseJSON { (response) in
            print(response)
            if let data = response.data {
                print(data)
                do {
                    let addPostResponse = try JSONDecoder().decode(UploadImagesAndVideoModel.self, from: data)
                    
                    if addPostResponse.message == "Unauthenticated." {
                        
                        let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                            
                            
                            let story = UIStoryboard(name: "Authentication", bundle:nil)
                            let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                            
                        }
                        //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                        alert.addAction(okAction)
                        //alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    if addPostResponse.code == 200 {
                        
                        for image in addPostResponse.item?.images ?? [] {
                            
                            print(image)
                            self.finalImagesArray.append(image)
                            //self.uploadImages(array: [image])
                            
                        }
                        //self.finalImagesArray?.append(addPostResponse.item?.images?.first ?? "")
                        print("final array string: \(self.finalImagesArray)")
                        //self.uploadImages(array: self.finalImagesArray)
                        self.performRequest(array: self.finalImagesArray)
                        
                    }else if let message = addPostResponse.message {
                        print(message)
                    }
                    Hud.dismiss()
                } catch {
                    print(error)
                    Hud.dismiss()
                }
            }
            
        }
        
    }
    
    func addVideo() {
        
        let token = HelperConstant.getToken()
        print(token)
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(token ?? "")"
        ]
        
        Hud.showHud(in: self.view)
        AF.upload(multipartFormData: { (multipartFormData) in
            
            if self.videoURL != nil {
                let timestamp = NSDate().timeIntervalSince1970
                multipartFormData.append(self.videoURL!, withName: "video", fileName: "\(timestamp).mp4", mimeType: "\(timestamp)/mp4")
            }
            
        }, to: "https://hawy-kw.com/api/auth/profile/cards/files/add" , headers: headers)
        .validate(statusCode: 200...500)
        .responseJSON { (response) in
            print(response)
            if let data = response.data {
                print(data)
                do {
                    let addPostResponse = try JSONDecoder().decode(UploadImagesAndVideoModel.self, from: data)
                    
                    if addPostResponse.message == "Unauthenticated." {
                        
                        let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                            
                            
                            let story = UIStoryboard(name: "Authentication", bundle:nil)
                            let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                            
                        }
                        //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                        alert.addAction(okAction)
                        //alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    if addPostResponse.code == 200 {
                        
                        self.finalVideo = addPostResponse.item?.videos
                        print(self.finalVideo)
                        
                        self.performUploadVideo(final: self.finalVideo)
                        
                    }else if let message = addPostResponse.message {
                        print(message)
                    }
                    Hud.dismiss()
                } catch {
                    print(error)
                    Hud.dismiss()
                }
            }
            
        }
        
    }
    
}

extension ProfileCardAttachedViewController {
    
    func uploadCard() {
        
        let token = HelperConstant.getToken()
        print(token)
        
        print(finalImagesArray)
        let parameters: [String: Any] = [
            
            "image_urls" : finalImagesArray,
            "main_image_url" : finalMainImage ?? "",
            "video_url": finalVideo ?? ""
            
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(token ?? "")"
        ]
        
        Hud.showHud(in: self.view)
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                
            }
            
//            if self.photoArray.isEmpty == false {
//                for (image) in self.photoArray {
//
//                    if  let imageData = image.jpegData(compressionQuality: 0.3) {
//                        multipartFormData.append(imageData , withName: "images[]", fileName: "image\(image).jpg", mimeType: "image/jpg")
//                    }
//                }
//            }
//
//            if(self.mainImageData != nil ) {
//                multipartFormData.append(self.mainImageData ?? Data() , withName: "main_image_url", fileName: "image.jpg", mimeType: "image/jpg")
//            }
//
//            if self.videoURL != nil {
//                let timestamp = NSDate().timeIntervalSince1970
//                multipartFormData.append(self.videoURL!, withName: "video", fileName: "\(timestamp).mp4", mimeType: "\(timestamp)/mp4")
//            }
            
        }, to: "https://hawy-kw.com/api/auth/profile/cards/\(cardId ?? 0)/files" , headers: headers)
        .validate(statusCode: 200...500)
        .responseJSON { (response) in
            print(response)
            if let data = response.data {
                print(data)
                do {
                    let addPostResponse = try JSONDecoder().decode(UploadImagesAndVideoModel.self, from: data)
                    
                    if addPostResponse.message == "Unauthenticated." {
                        
                        let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                            
                            
                            let story = UIStoryboard(name: "Authentication", bundle:nil)
                            let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                            
                        }
                        //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                        alert.addAction(okAction)
                        //alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    if addPostResponse.code == 200 {
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            
                            self.navigationController?.popViewController(animated: false)
                            
                        }
                        
                    }else if let message = addPostResponse.message {
                        print(message)
                    }
                    Hud.dismiss()
                } catch {
                    print(error)
                    Hud.dismiss()
                }
            }
            
        }
        
    }
    
    func performUploadMainImage(final: String?) { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auth/profile/cards/\(cardId ?? 0)/files"
        
        let parameters: [String: Any] = [
            
            "main_image_url" : final ?? ""
            
        ]
        
        print(parameters)
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        showIndecator()
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
            .validate(statusCode: 200...500)
        
            .responseJSON { response in
                
                print(parameters)
                print(headers)
                print(response)
                print(response.result)
                
                switch response.result {
                    
                case .success(let JSON):
                    
                    print("Validation Successful with response JSON \(JSON)")
                    
                    guard let data = response.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let forgetPasswordRequest = try decoder.decode(UploadImagesAndVideoModel.self, from: data)
                        print(forgetPasswordRequest)
                        
//                        if forgetPasswordRequest.code == 200 {
//
//                            print("success")
//
//
//                        }
                        
                        if forgetPasswordRequest.message == "Unauthenticated." {
                            
                            let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                                
                                
                                let story = UIStoryboard(name: "Authentication", bundle:nil)
                                let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                                UIApplication.shared.windows.first?.makeKeyAndVisible()
                                
                            }
                            //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                            alert.addAction(okAction)
                            //alert.addAction(cancelAction)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                        if forgetPasswordRequest.code == 200 {
                            
                            
                            print("success")
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                
                                
                                self.navigationController?.popViewController(animated: false)
                                
                            }
                            
                        }else if let message = forgetPasswordRequest.message {
                            print(message)
                        }
                        
                        self.hideIndecator()
                    } catch let error {
                        self.hideIndecator()
                        print(error)
                        
                    }
                    
                case .failure(let error):
                    
                    print("Request failed with error \(error)")
                    
                }
                
            }
        
    }
    
    func uploadMainImage() {
        
        let token = HelperConstant.getToken()
        print(token)
        
        let parameters: [String: Any] = [
            
            "main_image_url" : finalMainImage ?? ""
            
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(token ?? "")"
        ]
        
        Hud.showHud(in: self.view)
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                
            }
            
//            if self.photoArray.isEmpty == false {
//                for (image) in self.photoArray {
//
//                    if  let imageData = image.jpegData(compressionQuality: 0.3) {
//                        multipartFormData.append(imageData , withName: "images[]", fileName: "image\(image).jpg", mimeType: "image/jpg")
//                    }
//                }
//            }
//
//            if(self.mainImageData != nil ) {
//                multipartFormData.append(self.mainImageData ?? Data() , withName: "main_image_url", fileName: "image.jpg", mimeType: "image/jpg")
//            }
//
//            if self.videoURL != nil {
//                let timestamp = NSDate().timeIntervalSince1970
//                multipartFormData.append(self.videoURL!, withName: "video", fileName: "\(timestamp).mp4", mimeType: "\(timestamp)/mp4")
//            }
            
        }, to: "https://hawy-kw.com/api/auth/profile/cards/\(cardId ?? 0)/files" , headers: headers)
        .validate(statusCode: 200...500)
        .responseJSON { (response) in
            print(response)
            if let data = response.data {
                print(data)
                do {
                    let addPostResponse = try JSONDecoder().decode(UploadImagesAndVideoModel.self, from: data)
                    if addPostResponse.code == 200 {
                        
                        
                        
                        
                    }else if let message = addPostResponse.message {
                        print(message)
                    }
                    
                    if addPostResponse.message == "Unauthenticated." {
                        
                        let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                            
                            
                            let story = UIStoryboard(name: "Authentication", bundle:nil)
                            let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                            
                        }
                        //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                        alert.addAction(okAction)
                        //alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    Hud.dismiss()
                } catch {
                    print(error)
                    Hud.dismiss()
                }
            }
            
        }
        
    }
    
    func performRequest(array: [String]) { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auth/profile/cards/\(cardId ?? 0)/files"
        
        let parameters: [String: Any] = [
            
            "image_urls" : array
            
        ]
        
        print(parameters)
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        showIndecator()
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
            .validate(statusCode: 200...500)
        
            .responseJSON { response in
                
                print(parameters)
                print(headers)
                print(response)
                print(response.result)
                
                switch response.result {
                    
                case .success(let JSON):
                    
                    print("Validation Successful with response JSON \(JSON)")
                    
                    guard let data = response.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let forgetPasswordRequest = try decoder.decode(UploadImagesAndVideoModel.self, from: data)
                        print(forgetPasswordRequest)
                        
//                        if forgetPasswordRequest.code == 200 {
//
//                            print("success")
//
//
//                        }
                        
                        if forgetPasswordRequest.code == 200 {
                            
                            
                            print("success")
                            
//                            if self.finalMainImage == nil || self.finalMainImage == "" {
//                                print("main Image is nil")
//                            }else{
//                                self.performUploadMainImage()
//                            }
//
//                            if self.finalVideo == nil || self.finalVideo == "" {
//                                print("video url is nil")
//                            }else {
//                                self.performUploadVideo()
//                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                
                                
                                self.navigationController?.popViewController(animated: false)
                                
                            }
                            
                        }else if let message = forgetPasswordRequest.message {
                            print(message)
                        }
                        
                        if forgetPasswordRequest.message == "Unauthenticated." {
                            
                            let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                                
                                
                                let story = UIStoryboard(name: "Authentication", bundle:nil)
                                let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                                UIApplication.shared.windows.first?.makeKeyAndVisible()
                                
                            }
                            //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                            alert.addAction(okAction)
                            //alert.addAction(cancelAction)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                        self.hideIndecator()
                    } catch let error {
                        self.hideIndecator()
                        print(error)
                        
                    }
                    
                case .failure(let error):
                    
                    print("Request failed with error \(error)")
                    
                }
                
            }
        
    }
    
    func uploadImages(array: [String]) {
        
        let token = HelperConstant.getToken()
        print(token)
        
        let parameters: [String: Any] = [
            
            "image_urls" : array
            
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(token ?? "")"
        ]
        
        Hud.showHud(in: self.view)
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                
            }
            
//            if self.photoArray.isEmpty == false {
//                for (image) in self.photoArray {
//
//                    if  let imageData = image.jpegData(compressionQuality: 0.3) {
//                        multipartFormData.append(imageData , withName: "images[]", fileName: "image\(image).jpg", mimeType: "image/jpg")
//                    }
//                }
//            }
//
//            if(self.mainImageData != nil ) {
//                multipartFormData.append(self.mainImageData ?? Data() , withName: "main_image_url", fileName: "image.jpg", mimeType: "image/jpg")
//            }
//
//            if self.videoURL != nil {
//                let timestamp = NSDate().timeIntervalSince1970
//                multipartFormData.append(self.videoURL!, withName: "video", fileName: "\(timestamp).mp4", mimeType: "\(timestamp)/mp4")
//            }
            
        }, to: "https://hawy-kw.com/api/auth/profile/cards/\(cardId ?? 0)/files" , headers: headers)
        .validate(statusCode: 200...500)
        .responseJSON { (response) in
            print(response)
            if let data = response.data {
                print(data)
                do {
                    let addPostResponse = try JSONDecoder().decode(UploadImagesAndVideoModel.self, from: data)
                    if addPostResponse.code == 200 {
                        
                        
                        
                        
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            
                            
                            self.navigationController?.popViewController(animated: false)
                            
                        }
                        
                    }else if let message = addPostResponse.message {
                        print(message)
                    }
                    
                    if addPostResponse.message == "Unauthenticated." {
                        
                        let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                            
                            
                            let story = UIStoryboard(name: "Authentication", bundle:nil)
                            let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                            
                        }
                        //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                        alert.addAction(okAction)
                        //alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    Hud.dismiss()
                } catch {
                    print(error)
                    Hud.dismiss()
                }
            }
            
        }
        
    }
    
    func performUploadVideo(final: String?) { //url: String, parameters: [String:Any]
        
        let url = "https://hawy-kw.com/api/auth/profile/cards/\(cardId ?? 0)/files"
        
        let parameters: [String: Any] = [
            
            "video_url": final ?? ""
            
        ]
        
        print(parameters)
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        showIndecator()
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers) // //URLEncoding.httpBody
            .validate(statusCode: 200...500)
        
            .responseJSON { response in
                
                print(parameters)
                print(headers)
                print(response)
                print(response.result)
                
                switch response.result {
                    
                case .success(let JSON):
                    
                    print("Validation Successful with response JSON \(JSON)")
                    
                    guard let data = response.data else { return }
                    
                    do {
                        
                        let decoder = JSONDecoder()
                        let forgetPasswordRequest = try decoder.decode(UploadImagesAndVideoModel.self, from: data)
                        print(forgetPasswordRequest)
                        
//                        if forgetPasswordRequest.code == 200 {
//
//                            print("success")
//
//
//                        }
                        
                        if forgetPasswordRequest.code == 200 {
                            
                            
                            print("success")
                            
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                
                                
                                self.navigationController?.popViewController(animated: false)
                                
                            }
                            
                        }else if let message = forgetPasswordRequest.message {
                            print(message)
                        }
                        
                        if forgetPasswordRequest.message == "Unauthenticated." {
                            
                            let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                                
                                
                                let story = UIStoryboard(name: "Authentication", bundle:nil)
                                let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                                UIApplication.shared.windows.first?.makeKeyAndVisible()
                                
                            }
                            //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                            alert.addAction(okAction)
                            //alert.addAction(cancelAction)
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                        
                        self.hideIndecator()
                    } catch let error {
                        self.hideIndecator()
                        print(error)
                        
                    }
                    
                case .failure(let error):
                    
                    print("Request failed with error \(error)")
                    
                }
                
            }
        
    }
    
    func uploadvideo() {
        
        let token = HelperConstant.getToken()
        print(token)
        
        let parameters: [String: Any] = [
            
            "video_url": finalVideo ?? ""
            
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(token ?? "")"
        ]
        
        Hud.showHud(in: self.view)
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
                
            }
            
//            if self.photoArray.isEmpty == false {
//                for (image) in self.photoArray {
//
//                    if  let imageData = image.jpegData(compressionQuality: 0.3) {
//                        multipartFormData.append(imageData , withName: "images[]", fileName: "image\(image).jpg", mimeType: "image/jpg")
//                    }
//                }
//            }
//
//            if(self.mainImageData != nil ) {
//                multipartFormData.append(self.mainImageData ?? Data() , withName: "main_image_url", fileName: "image.jpg", mimeType: "image/jpg")
//            }
//
//            if self.videoURL != nil {
//                let timestamp = NSDate().timeIntervalSince1970
//                multipartFormData.append(self.videoURL!, withName: "video", fileName: "\(timestamp).mp4", mimeType: "\(timestamp)/mp4")
//            }
            
        }, to: "https://hawy-kw.com/api/auth/profile/cards/\(cardId ?? 0)/files" , headers: headers)
        .validate(statusCode: 200...500)
        .responseJSON { (response) in
            print(response)
            if let data = response.data {
                print(data)
                do {
                    let addPostResponse = try JSONDecoder().decode(UploadImagesAndVideoModel.self, from: data)
                    if addPostResponse.code == 200 {
                        
                        
                        
                        
                    }else if let message = addPostResponse.message {
                        print(message)
                    }
                    
                    if addPostResponse.message == "Unauthenticated." {
                        
                        let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                            
                            
                            let story = UIStoryboard(name: "Authentication", bundle:nil)
                            let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                            UIApplication.shared.windows.first?.makeKeyAndVisible()
                            
                        }
                        //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                        alert.addAction(okAction)
                        //alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    Hud.dismiss()
                } catch {
                    print(error)
                    Hud.dismiss()
                }
            }
            
        }
        
    }
    
}

//extension UIImage {
//    class func downloadedAsync(fromUrl url: URL)->Promise<UIImage> {
//        return Promise{ fulfill, reject in
//            URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
//                guard let data = data, error == nil else {
//                    reject(error!); return
//                }
//                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
//                    reject(NSError(domain: "Wrong HTTP response code when downloading image asynchronously",code: (response as? HTTPURLResponse)?.statusCode ?? 1000));return
//                }
//                guard let mimeType = response?.mimeType, mimeType.hasPrefix("image"), let image = UIImage(data: data) else {
//                    reject(NSError(domain: "No image in response", code: 700)); return
//                }
//                fulfill(image)
//            }).resume()
//        }
//    }
//}
