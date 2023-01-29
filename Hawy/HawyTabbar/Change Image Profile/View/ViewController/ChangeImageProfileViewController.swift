//
//  ChangeImageProfileViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 25/08/2022.
//

import UIKit
import Combine
import Alamofire
import NVActivityIndicatorView


class ChangeImageProfileViewController: BottomPopupViewController {
    
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballClipRotatePulse, color: DesignSystem.Colors.PrimaryBlue.color, padding: 0)
    
    lazy var containerOfLoading: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black.withAlphaComponent(0.15)
        return view
        
    }()
    
    @IBOutlet weak var avatarCollectionView: UICollectionView! {
        didSet {
            
            avatarCollectionView.dataSource = self
            avatarCollectionView.delegate = self
            avatarCollectionView.allowsMultipleSelection = false
            avatarCollectionView.contentInset.bottom = 45
            avatarCollectionView.register(UINib(nibName: "ChangeImageProfileCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ChangeImageProfileCollectionViewCell")
            
        }
    }
    @IBOutlet weak var chooseAnotherPhotoButton: UIButton!
    @IBOutlet weak var selectedImage: UIImageView!
    
    var Imagess: UIImage?
    
    var selected_Index : Int?
    var height: CGFloat?
    //var Delegate : AddNewAddress!
    //var delegateAction: delegate?
    //var delegYourAdderss: delegateAddress?
    var topCornerRadius: CGFloat?
    var presentDuration: Double?
    var dismissDuration: Double?
    var shouldDismissInteractivelty: Bool?
    
    var subscriber = Set<AnyCancellable>()
    
    private var viewModel = ProfileViewModel()
    
    var backData: ((String, String, Data) -> Void)?
    var imageURL: String?
    var image: String?
    var imageData: Data?
    
    var photoData: Data?
    
    var index = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            do {
                let avatar = try await viewModel.avatar()
                print(avatar)
            }catch {
                // tell the user something went wrong, I hope
                debugPrint(error)
            }
        }
        
        sinkToReLoading()
        sinkToProfileAvatarModelPublisher()
        getProfileData()
    }
    
    override func getPopupHeight() -> CGFloat {
        return height ?? CGFloat(450)
    }
    
    override func getPopupTopCornerRadius() -> CGFloat {
        return 35
    }
    
    override func getPopupPresentDuration() -> Double {
        return presentDuration ?? 1.0
    }
    
    override func getPopupDismissDuration() -> Double {
        return dismissDuration ?? 1.0
    }
    
    override func shouldPopupDismissInteractivelty() -> Bool {
        return shouldDismissInteractivelty ?? false
    }
    
    @IBAction func changePhotoButtonAction(_ sender: Any) {
        
        dismiss(animated: true) {
            self.backData!(self.imageURL ?? "", self.image ?? "", self.photoData ?? Data())
        }
        
    }
    
    @IBAction func chooseAnotherPhotoButtonTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "".localized, message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera".localized, style: .default) { [weak self] (action) in
            guard let self = self else { return }
            //self.count = 0
            self.chooseImagePickerAction(source: .camera)
        }
        
        let photoLibAction = UIAlertAction(title: "Photo Library".localized, style: .default) { [weak self] (action) in
            guard let self = self else { return }
            //self.count = 0
            self.chooseImagePickerAction(source: .photoLibrary)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showIndecator() {
        addLoaderToView(mainView: view, containerOfLoading: containerOfLoading, loading: loading)
    }
    
    func hideIndecator() {
        removeLoader(containerOfLoading: containerOfLoading, loading: loading)
    }
    
    func getProfileData() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        //showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/auth/profile?user_id=20", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(ProfileModel.self, from: response.data!)
                
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
                
                //self.hideIndecator()
            } catch {
                //self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
//    func sinkToLoading() {
//        self.viewModel.loadState
//            .sink { [weak self] (state) in
//                guard let self = self else { return }
//                if state {
//                    print("show Loading")
//                    self.showIndecator()
//                }else {
//                    print("dismiss Loading")
//                    self.hideIndecator()
//                }
//            }.store(in: &subscriber)
//    }
    
    func sinkToReLoading() {
//        self.viewModel.loadinState
//            .sink { [weak self] state in
//                self?.handleActivityIndicator(state: state)
//            }.store(in: &subscriber)
        self.viewModel.reloadingState
            .sink { [weak self] (state) in
                guard let self = self else { return }
                if state {
                    print("show Loading")
                    self.avatarCollectionView.reloadData()
                }
            }.store(in: &subscriber)
    }
    
    func sinkToProfileAvatarModelPublisher() {
        viewModel.profileAvatarModelPublisher.sink { [weak self] (result) in
            guard let self = self else { return }
            if result?.code == 200 {
                //self.cardData = result?.item ?? []
            }
            
            if result?.message == "Unauthenticated." {
                
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
            
        }.store(in: &subscriber)
    }
    
}

extension ChangeImageProfileViewController: BottomPopupDelegate {
    func bottomPopupViewLoaded() {
        print("bottomPopupViewLoaded")
        shouldDismissInteractivelty = false
    }
    
    func bottomPopupWillAppear() {
        print("bottomPopupWillAppear")
    }
    
    func bottomPopupDidAppear() {
        print("bottomPopupDidAppear")
    }
    
    func bottomPopupWillDismiss() {
        print("bottomPopupWillDismiss")
    }
    
    func bottomPopupDidDismiss() {
        print("bottomPopupDidDismiss")
    }
    
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) {
        print("bottomPopupDismissInteractionPercentChanged fromValue: \(oldValue) to: \(newValue)")
    }
}

extension ChangeImageProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        DispatchQueue.main.async {
//            let firstAnimation = CollectionViewAnimationFactory.makeSlideIn(duration: 0.5, delayFactor: 0.05)
//            let secondAnimation = CollectionViewAnimationFactory.makeFade(duration: 0.5, delayFactor: 0.05)
//            let thirdAnimation = CollectionViewAnimationFactory.makeMoveUpWithBounce(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
//            let fourthAnimation = CollectionViewAnimationFactory.makeMoveUpWithFade(rowHeight: cell.frame.height, duration: 0.5, delayFactor: 0.05)
//            //
//            let animator = CollectionViewAnimator(animation: firstAnimation)
//            animator.animate(cell: cell, at: indexPath, in: collectionView)
//        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return viewModel.profileAvatarModel?.item?.count ?? 0
        }else {
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            
            guard let cell = avatarCollectionView.dequeueReusableCell(withReuseIdentifier: "ChangeImageProfileCollectionViewCell", for: indexPath) as? ChangeImageProfileCollectionViewCell else { return UICollectionViewCell() }
            
            if indexPath.row == index {
                cell.containerView.backgroundColor = DesignSystem.Colors.PrimaryDarkGray.color
                imageData = cell.profileImage.image?.jpegData(compressionQuality: 0.5)
                print(imageData)
            }else {
                cell.containerView.backgroundColor = .white
            }
            
            let item = viewModel.profileAvatarModel?.item?[indexPath.row] ?? ""
            cell.profileImage.loadImage(URLS.baseImageURL+item)
            return cell
            
        }else {
            
            guard let cell = avatarCollectionView.dequeueReusableCell(withReuseIdentifier: "ChangeImageProfileCollectionViewCell", for: indexPath) as? ChangeImageProfileCollectionViewCell else { return UICollectionViewCell() }
            
            cell.profileImage.image = UIImage(systemName: "camera.circle.fill")
            
            return cell
            
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            index = indexPath.row
            avatarCollectionView.reloadData()
            
            let item = viewModel.profileAvatarModel?.item?[indexPath.row] ?? ""
            imageURL = URLS.baseImageURL+item
            image = item
            print(imageURL)
            
        }else {
            
            let alertController = UIAlertController(title: "".localized, message: nil, preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera".localized, style: .default) { [weak self] (action) in
                guard let self = self else { return }
                //self.count = 0
                self.chooseImagePickerAction(source: .camera)
            }
            
            let photoLibAction = UIAlertAction(title: "Photo Library".localized, style: .default) { [weak self] (action) in
                guard let self = self else { return }
                //self.count = 0
                self.chooseImagePickerAction(source: .photoLibrary)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel)
            
            alertController.addAction(cameraAction)
            alertController.addAction(photoLibAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//
//        if let cell = collectionView.cellForItem(at: indexPath) as? ChangeImageProfileCollectionViewCell {
//            cell.containerView.backgroundColor = .white
//            avatarCollectionView.reloadData()
//        }
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (avatarCollectionView.frame.size.width / 3) - 10, height: 80)
        
    }
    
}

extension ChangeImageProfileViewController {
    func chooseImagePickerAction(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = source
            imagePicker.mediaTypes = ["public.image"]
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

extension ChangeImageProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.allowsEditing = true
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        let image = info[convertFromUIImagePickerControllerInfoKey(.editedImage)] as? UIImage //URL(string: "\(movieUrl)")
        selectedImage.image = image
        Imagess = image
        
        //imageData = image?.jpegData(compressionQuality: 0.5)
        photoData = image?.jpegData(compressionQuality: 0.5)
        
        
        
        dismiss(animated: true, completion: {
            guard let cell = self.avatarCollectionView.cellForItem(at: IndexPath(item: 0, section: 1)) as? ChangeImageProfileCollectionViewCell else { return }
                cell.profileImage.image = image
            //self.avatarCollectionView.reloadSections(IndexSet(integer: 1))
        })
        
    }
    
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value)} )
    }
    
    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}
