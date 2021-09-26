//
//  Constants.swift
//  BillboardMovieApp
//
//  Created by Meli on 9/26/21.
//

import Foundation

// Headers to request
public struct HeaderRequest {
  let auth: String = "Authorization"
  let key: String = "157b108f1f2d275c12e9092b4b2bcdd9"
}

public enum MovieCategories: String {
  case popular = "Popular"
  case topRated = "Top Rated"
  case upcoming = "Upcoming"
  
}

//Later, we can set more languages
public enum MovieLanguage: String {
  case US = "en-US"
}

// Video params to rearch in youtube
public let VideoYouTubeParams: [String: Any] = [
  "autoplay": 0,
  "playsinline" : 1,
  "enablejsapi": 1,
  "wmode": "transparent",
  "controls": 0,
  "showinfo": 0,
  "rel": 0,
  "fs" : 1,
  "modestbranding": 0,
  "iv_load_policy": 3
]

// Api urls to call api movies
public enum APIServiceUrls: String {
  case movie = "https://api.themoviedb.org/3/movie/"
  case image = "http://image.tmdb.org/t/p/w500"
  case tv = "https://api.themoviedb.org/3/tv/"
  case genreMovie = "https://api.themoviedb.org/3/genre/movie/list"
  case genreTV = "https://api.themoviedb.org/3/genre/tv/list"
}

public enum APIServiceParams: String {
  case key = "api_key"
  case lang = "language"
}

public enum APIMovieCategoryParams: String {
  case popular = "popular"
  case topRated = "top_rated"
  case upcoming = "upcoming"
  case none = ""
}

public enum APIRequestMethod {
  case get
  case post
}

public enum APIRequestEncoding {
  case json
  case url
}

public enum APIResponseError: Error {
  case jsonMapping(String)
  case statusCode(Int)
  case badResponse(Any?)
  case unreachableNetwork
  case noNetworkConnection
  case timeout
}
