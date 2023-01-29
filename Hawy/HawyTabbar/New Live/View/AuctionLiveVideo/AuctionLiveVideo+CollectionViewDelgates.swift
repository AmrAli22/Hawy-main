//
//  AuctionLiveVideo+CollectionViewDelgates.swift
//  Hawy
//
//  Created by Amr Ali on 16/01/2023.
//

import Foundation
import UIKit
extension AuctionLiveVideo : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AllRequsts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = membersInLiveCollection.dequeueReusableCell(withReuseIdentifier: "LiveMembersCollectionViewCell", for: indexPath) as? LiveMembersCollectionViewCell else { return UICollectionViewCell()}
        
        let item = AllRequsts[indexPath.row]
        
        cell.memberImage.loadImage(URLS.baseImageURL+(item.image ?? ""))
        
        cell.muteUmMuteImage.image = UIImage(named: "Group 52705")
        
        if item.isSpeaker == true {
            cell.muteUmMuteImage.image = UIImage(named: "Group 52704")
        }else {
            cell.muteUmMuteImage.image = UIImage(named: "Group 52705")
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let item = AllRequsts[indexPath.row]
        
        let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        VC?.myProfile = false
        VC?.ownerId = item.id
        VC?.newName = item.name ?? ""
        VC?.newPhone = item.mobile ?? ""
        VC?.newImage = item.image ?? ""
        VC?.newCode = item.code ?? ""
        print(item.id)
        present(VC!, animated: true, completion: nil)
        
        
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
                return createFourthSection()
            default:
                return createFourthSection()
            }
        }
        
        
        func createFourthSection() -> NSCollectionLayoutSection {
            
            let inset: CGFloat = 5
            
            // item
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
            
            // group
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
            
            // section
            let section = NSCollectionLayoutSection(group: group)
            //section.orthogonalScrollingBehavior = .continuous
            
            // supplementary
            let hearderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(20))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: hearderSize, elementKind: "header", alignment: .top)
            //section.boundarySupplementaryItems = [header]
            
            return section
            
        }
    @IBAction func partecipantButtonCollapseTapped(_ sender: Any) {
        if collapse == false {
            collapse = true
            partecipantViewHeight.constant = 100
            membersInLiveCollection.isHidden = true
        }else {
            collapse = false
            partecipantViewHeight.constant = 350
            membersInLiveCollection.isHidden = false
        }
    }
    
    @IBAction func cardsButtonCollapseTapped(_ sender: Any) {
        if cardsCollapse == false {
            cardsCollapse = true
            cardsTableViewHeight.constant = 0
            cardsTableView.isHidden = true
            containerViewOfCardsTableView.isHidden = true
            cardsGradientView.roundCornersWithMask([.topLeading, .topTrailing, .bottomLeading, .bottomTrailing], radius: 20)
        }else {
            cardsCollapse = false
            cardsTableViewHeight.constant = self.cardsTableView.contentSize.height
            cardsTableView.isHidden = false
            containerViewOfCardsTableView.isHidden = false
            cardsGradientView.roundCornersWithMask([.topLeading, .topTrailing], radius: 20)
        }
    }
}
