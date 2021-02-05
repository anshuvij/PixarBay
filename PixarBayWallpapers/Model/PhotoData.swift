//
//  SearchCodable.swift
//  PixarBayWallpapers
//
//  Created by Anshu Vij on 8/9/20.
//  Copyright © 2020 anshu vij. All rights reserved.
//

struct PhotoData: Codable {
  let hits: [HitCodable]
}

struct HitCodable: Codable {
  let largeImageURL: String
  let webformatURL: String
  let pageURL: String
  let user: String
  
  let likes: Int
  let favorites: Int
  let views: Int
}
