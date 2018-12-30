//
//  ImageCollectionViewCell.swift
//  KimonoFeed
//
//  Created by 孙翔宇 on 12/22/18.
//  Copyright © 2018 孙翔宇. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
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
        imageTask?.cancel()
        imageTask = nil
        imageInfoTask?.cancel()
        imageInfoTask = nil
    }
    
    
    func pullImageAndInfomation(photo: BriefPhotoInfo) {
        let url = URL(string: "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_c.jpg")!
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
        
        imageTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let imageData = data,
                let image = UIImage(data: imageData){
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        imageTask?.resume()
        
        let infourl = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=14740156d6ac44b049ea94e201a50458&format=json&nojsoncallback=1&photo_id=\(photo.id)")!
        let inforequest = URLRequest(url: infourl, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
        
        imageInfoTask = URLSession.shared.dataTask(with: inforequest) { (data, response, error) in
            if let infoData = data{
                do {
                    let photo = try JSONDecoder().decode(Photo.self, from: infoData)
                    DispatchQueue.main.async {
                        self.dateLabel.text = photo.dates.posted
                        
                        photo.publiceditability.cancomment
                    }
                } catch {
                    
                }
            }
        }
        imageInfoTask?.resume()
    }
}
