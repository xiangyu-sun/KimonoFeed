//
//  APIRequestBuilder.swift
//  KimonoFeed
//
//  Created by 孙翔宇 on 1/6/19.
//  Copyright © 2019 孙翔宇. All rights reserved.
//

import Foundation

final class APIRequestBuilder {
    static private let apiKey = "14740156d6ac44b049ea94e201a50458"
    
    static func buildReloadURL() -> URL? {
        return URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=kimono&format=json&nojsoncallback=1")
    }
    
    static func buildPhotoPublicURL(photo: BriefPhotoInfo) -> URL? {
        return URL(string: "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_c.jpg")
    }
    
    static func buildPhotoInfoURL(photo: BriefPhotoInfo) -> URL? {
        return  URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=14740156d6ac44b049ea94e201a50458&format=json&nojsoncallback=1&photo_id=\(photo.id)")
    }
}
