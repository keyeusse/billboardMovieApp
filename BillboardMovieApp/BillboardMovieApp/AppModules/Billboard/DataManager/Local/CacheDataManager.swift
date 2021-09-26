//
//  LocalDataManager.swift
//  BillboardMovieApp
//
//  Created by Meli on 9/26/21.
//

import UIKit

// MARK: - IMAGE CACHE SINGLETON
public class CacheDataManager {
  
  static let shared = CacheDataManager()
  
  private(set) var imageCache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()

  init() {}

}
