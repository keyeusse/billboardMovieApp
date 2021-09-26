//
//  APIManager.swift
//  BillboardMovieApp
//
//  Created by Meli on 9/26/21.
//
//
import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

protocol APIResponseProtocol {
  func getMovieResult(data: MovieResults)
  func getMovieGenres(data: Genres)
  func onFailure(_ error: Error)
}

protocol APIClientProtocol: AnyObject {
  func getMovieList(url: APIServiceUrls, release: APIMovieCategoryParams, lang: MovieLanguage)
  func getGenreList(url: APIServiceUrls, release: APIMovieCategoryParams, lang: MovieLanguage)
}


// MARK: - Call to api services movies and genres
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
        self.delegate?.getMovieResult(data: results)
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
        self.delegate?.getMovieGenres(data: results)
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

// check connection to internet
class ConnectivityToIntenet {
  class var isConnectedToInternet: Bool {
    return NetworkReachabilityManager()?.isReachable ?? false
  }
}
