//
//  FeedViewModel.swift
//  KimonoFeed
//
//  Created by 孙翔宇 on 12/25/18.
//  Copyright © 2018 孙翔宇. All rights reserved.
//

import Foundation
import os.log

class FeedViewModel : NSObject {
    @objc dynamic var result: SearchResult?
    
    func photoAt(indexPath: IndexPath) -> BriefPhotoInfo? {
        return result?.photos.photo[indexPath.row]
    }
    
    func reload() {
        
        guard let url = APIRequestBuilder.buildReloadURL() else { return }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let feedData = data else {return}
            do {
                self.result = try JSONDecoder().decode(SearchResult.self, from: feedData)
            } catch {
                os_log("%@", error.localizedDescription)
            }
            }.resume()
    }
}
