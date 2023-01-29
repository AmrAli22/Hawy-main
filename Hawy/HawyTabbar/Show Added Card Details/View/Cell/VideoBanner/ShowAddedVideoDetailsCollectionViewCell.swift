//
//  ShowAddedVideoDetailsCollectionViewCell.swift
//  Hawy
//
//  Created by ahmed abu elregal on 31/08/2022.
//

import UIKit
import AVFoundation
import AVKit

class ShowAddedVideoDetailsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var videoView: VideoView!
    
    var player : AVPlayer!
    var avController = AVPlayerViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
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
    
}
