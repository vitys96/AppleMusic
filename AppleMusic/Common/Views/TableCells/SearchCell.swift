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

class SearchCell: UITableViewCell, ConfigurableCell {
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var topSeparator: UIView!
    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var addTrack: UIButton!
    
    static var defaultHeight: CGFloat? {
        return 85
    }
    private let realm = try! Realm()
    private var songViewModel: Songs?
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with data: Songs) {
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
        artistImageView.sd_setImage(with: URL(string: data.songIconUrl100 ?? "")) {[weak self] (image, _, _, _) in
            if let image = image?.withRenderingMode(.alwaysOriginal) {
                self?.artistImageView.image = image
            }
        }
    }
    
    @IBAction func addToLibrary(_ sender: UIButton) {
        let song = TrackModel()
        
        guard let trackName = trackName.text,
        let artistName = artistName.text,
        let collectionName = collectionName.text,
        let imageData = artistImageView.image?.pngData(),
        let songsUrl = songViewModel?.songIconUrl100
        else { return }
        
        song.trackID = DBManager.sharedInstance.getDataFromSiteList().count
        song.trackName = trackName
        song.artistName = artistName
        song.collectionName = collectionName
        song.trackImageView = imageData
        song.songIconUrl100 = songsUrl
        DBManager.sharedInstance.addDataSiteList(object: song)
    }
    
    @IBAction func toKnowInfo(_ sender: UIButton) {
        let results = realm.objects(TrackModel.self)
        print (results.count)
    }
}

extension Results {
    func toArray<T>(type: T.Type) -> [T] {
        return compactMap { $0 as? T }
    }
}

//extension SearchCell {
//    struct Data {
//        let trackName: String?
//        let artistName: String?
//        let collectionName: String?
//        let songIconUrl: String?
//        let songMusicMp4: String?
//    }
//}
