//
//  FeedViewModel.swift
//  KimonoFeed
//
//  Created by 孙翔宇 on 12/25/18.
//  Copyright © 2018 孙翔宇. All rights reserved.
//

import Foundation

class FeedViewModel : NSObject {
    @objc dynamic var result: SearchResult?
    
    func photoAt(indexPath: IndexPath) -> BriefPhotoInfo? {
        return result?.photos.photo[indexPath.row]
    }
    
    func reload() {
        let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=14740156d6ac44b049ea94e201a50458&text=kimono&format=json&nojsoncallback=1")!
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let feedData = data else {return}
            do {
                self.result = try JSONDecoder().decode(SearchResult.self, from: feedData)
            } catch {
                
            }
            }.resume()
    }
}
