//
//  Helpers.swift
//  BillboardMovieApp
//
//  Created by Meli on 9/25/21.

import UIKit

// Get info to show as detail movie
public class MovieDetails {
  static func showRatting(of movie: Movie) -> String {
    let rating: Float = movie.rating ?? 0.0
    return "\(rating)"
  }
    static func showViews(of movie: Movie) -> String {
      let votes: Int = movie.voteCount ?? 0
      return "\(votes)"
    }
    
    static func showDate(of movie: Movie) -> String {
      let date: String = movie.releaseDate ?? ""
      return "\(date)"
    }
}

// create url to api calls
func getURL(of movie: Movie) -> String {
  guard let path = movie.posterPath else { return "" }
    let fullPath: String = "\(APIServiceUrls.image.rawValue)\(path)"
  return fullPath
}

func getCategoryKeyFrom(name: String) -> APIMovieCategoryParams {
  switch name {
  case "popular":
    return APIMovieCategoryParams.popular
  case "top_rated":
    return APIMovieCategoryParams.topRated
  case "upcoming":
    return APIMovieCategoryParams.upcoming
  default:
    return APIMovieCategoryParams.none
  }
}

