//
//  EditeVC.swift
//  Hawy
//
//  Created by ahmed abu elregal on 10/08/2022.
//

import UIKit

class EditeVC: UIViewController {
    
    @IBOutlet weak var editeCollection: UICollectionView!{
        didSet {
            
            editeCollection.dataSource = self
            editeCollection.delegate = self
            //homeCollectionView.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: "header", withReuseIdentifier: "HeaderView")
            editeCollection.register(UINib(nibName: "SubscriptionsPackagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SubscriptionsPackagesCollectionViewCell")
            
        }
    }
    
    var index = 0
    var index1 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editeCollection.collectionViewLayout = createCompositionalLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        editeCollection.contentInset.top = 0
    }
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (index, environment) -> NSCollectionLayoutSection? in
            
            return self?.createSectionFor(index: index, environment: environment)
            
        }
        return layout
    }
    
    func createSectionFor(index: Int, environment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        switch index {
        case 0:
            return createZooomedSection()
        case 1:
            return createZooomedSection()
        default:
            return createZooomedSection()
        }
    }
    
    func createZooomedSection() -> NSCollectionLayoutSection {
        let carouselItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(250)))
        carouselItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let carouselGroup = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.6 / 3.0), heightDimension: .absolute(250)), subitems: [carouselItem]) // every play thing with 1.6
        
        let carouselSection = NSCollectionLayoutSection(group: carouselGroup)
        carouselSection.orthogonalScrollingBehavior = .groupPagingCentered
        
        // supplementary
        let hearderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: hearderSize, elementKind: "header", alignment: .top)
        carouselSection.boundarySupplementaryItems = [header]
        
        carouselSection.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.8
                let maxScale: CGFloat = 1.2
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        return carouselSection
        
    }
    
    func createFourthSection() -> NSCollectionLayoutSection {
        
        let inset: CGFloat = 5
        
        // item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
        
        // group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        // section
        let section = NSCollectionLayoutSection(group: group)
        //section.orthogonalScrollingBehavior = .continuous
        
        // supplementary
        let hearderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: hearderSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [header]
        
        return section
        
    }
    
}

extension EditeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return section == 2 ? 15 : 5
        switch section {
        case 0:
            return 5
        case 1:
            return 5
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = editeCollection.dequeueReusableCell(withReuseIdentifier: "SubscriptionsPackagesCollectionViewCell", for: indexPath) as? SubscriptionsPackagesCollectionViewCell else { return UICollectionViewCell() }
            
            cell.containerView.layer.borderWidth = 0
            cell.containerView.layer.borderColor = UIColor.clear.cgColor
            
            if indexPath.row == index {
                cell.containerView.layer.borderWidth = 2
                cell.containerView.layer.borderColor = DesignSystem.Colors.PrimaryYellow.color.cgColor
            }
            
            return cell
        case 1:
            guard let cell = editeCollection.dequeueReusableCell(withReuseIdentifier: "SubscriptionsPackagesCollectionViewCell", for: indexPath) as? SubscriptionsPackagesCollectionViewCell else { return UICollectionViewCell() }
            
            cell.containerView.layer.borderWidth = 0
            cell.containerView.layer.borderColor = UIColor.clear.cgColor
            
            if indexPath.row == index1 {
                cell.containerView.layer.borderWidth = 2
                cell.containerView.layer.borderColor = DesignSystem.Colors.PrimaryYellow.color.cgColor
            }
            
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            index = indexPath.row
            editeCollection.reloadData()
        case 1:
            index1 = indexPath.row
            editeCollection.reloadData()
        default:
            break
        }
    }
    
}
