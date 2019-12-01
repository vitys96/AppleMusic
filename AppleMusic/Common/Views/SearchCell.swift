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
    @IBOutlet weak var artistName: UILabel!
    
        // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with data: Data) {
        artistName.text = data.artistName
        artistImageView.sd_setImage(with: URL(string: data.artistLinkUrl ?? "")) {[weak self] (image, _, _, _) in
            if let image = image?.withRenderingMode(.alwaysOriginal) {
                self?.artistImageView.image = image
            }
        }
    }
}

extension SearchCell {
    struct Data {
        let artistName: String?
        let artistLinkUrl: String?
    }
}
