//
//  APIManager.swift
//  BillboardMovieApp
//
//  Created by Meli on 9/26/21.
//
//
// Examples:
// https://api.themoviedb.org/3/movie/popular?api_key=157b108f1f2d275c12e9092b4b2bcdd9
//
import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

protocol APIResponseProtocol {
  func fetchedResult(data: MovieResults)
  func fetchedGenres(data: Genres)
  func onFailure(_ error: Error)
}

protocol APIClientProtocol: AnyObject {
  func getMovieList(url: APIServiceUrls, release: APIMovieCategoryParams, lang: MovieLanguage)
  func getGenreList(url: APIServiceUrls, release: APIMovieCategoryParams, lang: MovieLanguage)
}

// MARK: - CONNECTIVITY
// Helps to know if device is connected to internet
class Connectivity {
  class var isConnectedToInternet: Bool {
    return NetworkReachabilityManager()?.isReachable ?? false
  }
}

// MARK: - CLIENT
class APIClient: APIClientProtocol {
  
  var delegate: APIResponseProtocol?
  
  init() {}

  func getMovieList(url: APIServiceUrls, release: APIMovieCategoryParams, lang: MovieLanguage) {
    let URL = url.rawValue + release.rawValue
    let params = [APIServiceParams.key.rawValue: HeaderRequest().key,
                  APIServiceParams.lang.rawValue: lang.rawValue]
    Alamofire.request(URL, parameters: params).responseObject { (response: DataResponse<MovieResults>) in
      switch response.result {
      case .success(var results):
        results.category = release
        self.delegate?.fetchedResult(data: results)
      case .failure(let error):
        self.delegate?.onFailure(error)
      }
    }
  }

  func getGenreList(url: APIServiceUrls, release: APIMovieCategoryParams, lang: MovieLanguage) {
    let URL = url.rawValue + release.rawValue
    let params = [APIServiceParams.key.rawValue: HeaderRequest().key,
                  APIServiceParams.lang.rawValue: lang.rawValue]
    Alamofire.request(URL, parameters: params).responseObject { (response: DataResponse<Genres>) in
      switch response.result {
      case .success(let results):
        self.delegate?.fetchedGenres(data: results)
      case .failure(let error):
        self.delegate?.onFailure(error)
      }
    }
  }
  
  func getYouTubeKey(of movie: Movie, completion: @escaping (_ key: String?) -> Void) {
    guard let id = movie.id else { return }
    let URL = APIServiceUrls.movie.rawValue + "\(id)/videos"
    let params = [APIServiceParams.key.rawValue: HeaderRequest().key,
                  APIServiceParams.lang.rawValue: MovieLanguage.US.rawValue]
    Alamofire.request(URL, parameters: params).responseObject { (response: DataResponse<Video>) in
      switch response.result {
      case .success(let details):
        let keysResults = details.results?.compactMap { $0.key }
        completion(keysResults?.first)
      case .failure(_ ):
        completion(nil)
        break
      }
    }
  }
}
