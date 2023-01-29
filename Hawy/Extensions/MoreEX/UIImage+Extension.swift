//
//  UIImage+Extension.swift
//  aman
//
//  Created by Enas Abdallah on 04/01/2021.
//
import UIKit
import Kingfisher

extension UIImageView {

    @discardableResult
    private func downloadImage(_ url: URL, _ placeholderImage: UIImage?) -> DownloadTask? {
        kf.indicatorType = .activity
        kf.indicator?.startAnimatingView()
        return self.kf.setImage(with: url, placeholder: placeholderImage, completionHandler:  { [weak self] result in
            guard let self = self else { return }
            self.kf.indicator?.stopAnimatingView()
            
            switch result {
            case .success(let value):
                self.image = value.image
            case .failure(let error):
                self.image = placeholderImage
                debugPrint(error.errorDescription ?? "Error")
            }
        })
    }

    func setImageWith(_ linkString: String?, _ placeholderImage: UIImage? = nil) {
        guard let linkString = linkString, let url = URL(string: linkString) else { return }
        downloadImage(url, placeholderImage)
    }

    func setImageWith(url: URL?, _ placeholderImage: UIImage? = nil) {
        guard let url = url else { return }
        downloadImage(url, placeholderImage)
    }
}
