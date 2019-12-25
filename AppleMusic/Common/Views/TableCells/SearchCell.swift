//
//  SearchCell.swift
//  AppleMusic
//
//  Created by TOOK on 30.11.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//
import UIKit
import SDWebImage
import TableKit
import RealmSwift
import Lottie

class SearchCell: UITableViewCell, ConfigurableCell {
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var topSeparator: UIView!
    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var addTrack: UIButton!
    @IBOutlet weak var lottieView: AnimationView!
    @IBOutlet weak var musicLogo: UIImageView!
    
    static var defaultHeight: CGFloat? {
        return 85
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if(selected) {
            lottieView.isHidden = false
            musicLogo.isHidden = false
            artistImageView.alpha = 0.5
            musicLogo.animate(.fadeIn)
            lottieView.animation = Animation.named("isPlaying")
            lottieView.loopMode = .loop
            lottieView.contentMode = .scaleAspectFit
            lottieView.play()
        } else {
            musicLogo.animate(.fadeOut)
            artistImageView.alpha = 1
            lottieView.isHidden = true
            lottieView.stop()
        }
    }
    private let realm = try! Realm()
    var songViewModel: ViewModel?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        addTrack.add(for: .touchUpInside) { [weak self] in
            guard let self = self else {return}
            TableCellAction(key: CellActions.addToLibrary.rawValue, sender: self).invoke()
            self.addTrack.isHidden = true
        }
        lottieView.backgroundBehavior = .pauseAndRestore
    }
    @objc func restartAnimation() {
            lottieView.play()
    }
    
    func configure(with data: ViewModel) {
        songViewModel = data
        let results = realm.objects(TrackModel.self)
        let lal: [Songs] = results.map {
            Songs(object:
                ["artistName" : $0.artistName,
                 "trackName" : $0.trackName
                ]
            )}
        let hasFavourited = lal.firstIndex(where: {
            $0.trackName == data.trackName && $0.artistName == data.artistName
        }) != nil
        if hasFavourited {
            addTrack.isHidden = true
        } else {
            addTrack.isHidden = false
        }
        artistName.text = data.artistName
        trackName.text = data.trackName
        collectionName.text = data.collectionName
        if let image = data.trackImage {
            self.artistImageView.image = image
        } else {
            artistImageView.sd_setImage(with: URL(string: data.songIconUrl ?? "")) {[weak self] (image, _, _, _) in
                if let image = image?.withRenderingMode(.alwaysOriginal) {
                    self?.artistImageView.image = image
                }
            }
        }
        //        artistImageView.alpha = 0.5
        //        self.artistImageView.addSubview(lottieView)
        //        lottieView.fillSuperview()
        //        lottieView.alpha = 1
        //        lottieView.animation = Animation.named("isPlaying")
        //        lottieView.loopMode = .loop
        //        lottieView.contentMode = .scaleAspectFit
        //        lottieView.isHidden = true
    }
    func setAnimation() {
        
    }
    
    func resetAnimation() {
        lottieView.stop()
        artistImageView.alpha = 1
        self.lottieView.removeFromSuperview()
        lottieView.alpha = 0
        
        //        lottieView.animation = Animation.named("isPlaying")
        //        lottieView.loopMode = .loop
        //        lottieView.contentMode = .scaleAspectFit
        //        lottieView.play()
    }
}

extension SearchCell {
    struct ViewModel {
        let id: Int?
        let trackName: String?
        let artistName: String?
        let collectionName: String?
        let songIconUrl: String?
        let songMp4: String?
        let trackImage: UIImage?
    }
}
