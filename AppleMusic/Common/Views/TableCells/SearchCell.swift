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

class SearchCell: UITableViewCell, ConfigurableCell {
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var topSeparator: UIView!
    @IBOutlet weak var bottomSeparator: UIView!
    
    static var defaultHeight: CGFloat? {
        return 85
    }
    
        // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with data: Songs) {
        artistName.text = data.artistName
        trackName.text = data.trackName
        collectionName.text = data.collectionName
        artistImageView.sd_setImage(with: URL(string: data.songIconUrl100 ?? "")) {[weak self] (image, _, _, _) in
            if let image = image?.withRenderingMode(.alwaysOriginal) {
                self?.artistImageView.image = image
            }
        }
        separatorInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension SearchCell {
    struct Data {
        let trackName: String?
        let artistName: String?
        let collectionName: String?
        let songIconUrl: String?
        let songMusicMp4: String?
    }
}
