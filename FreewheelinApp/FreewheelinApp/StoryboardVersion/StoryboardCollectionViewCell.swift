//
//  StoryboardCollectionViewCell.swift
//  FreewheelinApp
//
//  Created by Dannian Park on 2021/05/18.
//

import UIKit

class StoryboardCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    // MARK: - Cell Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .clear // .darkGray
        // Initialization code
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgView.image = nil
    }
    public func setData(data : DrawingDatas) {
        if !data.thumbPath.isEmpty {
            guard let filePath = Utils.getFileURL(fileName: data.thumbPath) else {
                return
            }
            let test = filePath.absoluteString.replacingOccurrences(of: "file://", with: "")
            let image = UIImage(contentsOfFile: test)
            self.imgView.image = image
        } else {
            // default ?
        }
    }
}
