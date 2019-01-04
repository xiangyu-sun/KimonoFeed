//
//  Model.swift
//  KimonoFeed
//
//  Created by 孙翔宇 on 12/25/18.
//  Copyright © 2018 孙翔宇. All rights reserved.
//

import Foundation

class SearchResult: NSObject, Codable {
    var photos: SearchResultInfo
    var stat : String
}

struct SearchResultInfo: Codable {
    var photo : [BriefPhotoInfo]
    var page : Int
    var pages : Int
    var perpage : Int
    var total : String
}

struct BriefPhotoInfo: Codable {
    var id : String
    var owner : String
    var secret : String
    var server : String
    var farm : Int
    var title : String
    var ispublic : Int
    var isfriend : Int
    var isfamily : Int
}

struct PhotoResponse: Codable {
    var photo: Photo
}

struct Photo: Codable {
    
    struct Owner: Codable {
        var nsid : String
        var username : String
        var realname : String
        var location : String
        var iconserver : String
        var path_alias : String?
    }
    
    struct Date: Codable {
        var posted : String
        var taken : String
        var takenunknown : String
        var lastupdate : String
    }
    
    struct Publiceditability: Codable {
        var cancomment : Int
        var canaddmeta : Int
    }
    
    var owner : Owner
    var dates : Date
    var publiceditability : Publiceditability
    var views: String
}
