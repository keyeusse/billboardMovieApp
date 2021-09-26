//
//  MovieDetailInteractor.swift
//  BillboardMovieApp
//
//  Created by Meli on 9/25/21.

import UIKit

class MovieDetailInteractor: MovieDetailInteractorInputProtocol {
  

  weak var presenter: MovieDetailInteractorOutputProtocol?
  
  var cacheDataManager: CacheDataManager = CacheDataManager()
  private let dataManager = DataManager()
  var coverImage: UIImage?
    
  
  func loadImage(of movie: Movie) {
    let key = NSString(string: "\(String(describing: movie.id))backdropImage")
    
    // get from local cache
    if !ConnectivityToIntenet.isConnectedToInternet {
      getOfflineImageWith(key: key as String)
      return
    }
    
    let cache = cacheDataManager.imageCache
    if let cachedImage = cache.object(forKey: key) {
      self.coverImage = cachedImage
      presenter?.loadImage(cachedImage)
    } else {
      //call to api
      downloadImage(of: movie, key: key as String)
    }
  }
  
  func getImageFromLocalStorage(key: String) -> UIImage? {
    // Get image From Local Storage
    var image: UIImage?
      dataManager.getImageDataFrom(key: key) { data in
        guard let data = data else { return }
        image = UIImage(data: data)
      }
    return image
  }
  

  private func getOfflineImageWith(key: String) {
    let dataManager = DataManager()
    dataManager.getImageDataFrom(key: key) { data in
      guard let data = data else { return }
      if let image = UIImage(data: data) {
        self.presenter?.loadImage(image)
      }
    }
  }
  
  private func downloadImage(of movie: Movie, key: String) {
    guard let path = movie.backdropPath else { return }
    let fullPath: String = "\(APIServiceUrls.image.rawValue)\(path)"
    let cache = cacheDataManager.imageCache
    DispatchQueue.global(qos: .background).async {
      guard
        let url: URL = URL(string: fullPath),
        let data = try? Data(contentsOf: url),
        let image: UIImage = UIImage(data: data)
        else { return }
      DispatchQueue.main.async {
        cache.setObject(image, forKey: key as NSString)
        self.saveImageLocallyWith(key: key, and: data)
        self.coverImage = image
        self.presenter?.loadImage(image)
      }
    }
  }

  private func saveImageLocallyWith(key: String, and data: Data?) {
    dataManager.saveImageDataFor(key: key, and: data)
  }
}
