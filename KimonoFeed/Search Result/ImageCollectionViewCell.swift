//
//  ImageCollectionViewCell.swift
//  KimonoFeed
//
//  Created by 孙翔宇 on 12/22/18.
//  Copyright © 2018 孙翔宇. All rights reserved.
//

import UIKit
import os

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
    
    var imageTask: URLSessionDataTask?
    var imageInfoTask: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        self.autoresizesSubviews = true
        
        imageView.frame = self.bounds
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        dateLabel.text = nil
        viewsLabel.text = nil
        imageTask?.cancel()
        imageTask = nil
        imageInfoTask?.cancel()
        imageInfoTask = nil
    }
    
    
    func updateImageViewWith(_ photo: BriefPhotoInfo) {
        guard let url = APIRequestBuilder.buildPhotoPublicURL(photo: photo) else {
            return
        }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
        
        imageTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let imageData = data,
                let image = UIImage(data: imageData){
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = image
                }
            }
        }
        imageTask?.resume()
    }
    
    func updatePhotoInfoUIWith(_ photo: BriefPhotoInfo) {
        guard let infourl = APIRequestBuilder.buildPhotoInfoURL(photo: photo) else {
            return
        }
        
        let inforequest = URLRequest(url: infourl)
        
        imageInfoTask = URLSession.shared.dataTask(with: inforequest) { (data, response, error) in
            if let infoData = data{
                do {
                    let photoResponse = try JSONDecoder().decode(PhotoResponse.self, from: infoData)
                    guard let postDateInterval = Double(photoResponse.photo.dates.posted) else { return }
                    DispatchQueue.main.async {  [weak self] in
                        
                        self?.dateLabel.text = ImageCollectionViewCell.dateFormatter.string(from: Date(timeIntervalSince1970: postDateInterval))
                        
                        self?.viewsLabel.text = "\(photoResponse.photo.views) 👁‍🗨"
                    }
                } catch {
                    os_log("%@", error.localizedDescription)
                }
            }
        }
        
        imageInfoTask?.resume()
    }
}
