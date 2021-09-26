//
//  ImageDownloader.swift
//  BillboardMovieApp
//
//  Created by Meli on 9/26/21.

import UIKit

class ImageDownloader {
  // Image Cache Singleton
  private lazy var imageCache = CacheDataManager.shared.imageCache
  private lazy var dataManager = DataManager()
  
  // Get images
  func loadImages(of movie: Movie, completion: @escaping () -> Void ) -> UIImage {
    let size = CGSize(width: 100, height: 140)
    let path = getURL(of: movie)
    let key: NSString = NSString(string: path)
    
    // Get Image Cached
    if let imageFromCache: UIImage = imageCache.object(forKey: key) {
      return imageFromCache
    }
    // Download and Compress image to fit container size
    DispatchQueue.global(qos: .background).async {
      guard let url: URL = URL(string: path),
            let newimage = self.downloadImages(url: url, newSize: size) else { return }
      // save image on cache
      self.imageCache.setObject(newimage, forKey: key)
      // Show in UI
      DispatchQueue.main.async {
        // Save in core data
        self.saveImageLocally(key: key as String, and: newimage.pngData())
        completion()
      }
    }
    return UIImage()
  }
  
  private func downloadImages(url: URL, newSize: CGSize) -> UIImage? {
    guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
      let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil),
      let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { return nil }
    let context = CGContext(data: nil,
                            width: Int(newSize.width),
                            height: Int(newSize.height),
                            bitsPerComponent: image.bitsPerComponent,
                            bytesPerRow: image.bytesPerRow,
                            space: image.colorSpace ?? colorSpace,
                            bitmapInfo: image.bitmapInfo.rawValue)
    context?.interpolationQuality = .high
    context?.draw(image, in: CGRect(origin: .zero, size: newSize))
    guard let scaledImage = context?.makeImage() else { return nil }
    return UIImage(cgImage: scaledImage)
  }
  
  private func saveImageLocally(key: String, and data: Data?) {
    dataManager.saveImageDataFor(key: key, and: data)
  }
}
