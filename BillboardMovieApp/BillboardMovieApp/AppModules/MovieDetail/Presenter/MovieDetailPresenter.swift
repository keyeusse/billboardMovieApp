//
//  MovieDetailPresenter.swift
//  BillboardMovieApp
//
//  Created by Meli on 9/25/21.

import UIKit

class MovieDetailPresenter: MovieDetailPresenterProtocol {
  
  // MARK: - VIPER
  weak var view: MovieDetailViewProtocol?
  var interactor: MovieDetailInteractorInputProtocol?
  var router: MovieDetailRouterProtocol?
  
  private var movie: Movie?
  var title: String?
  
  init(movie: Movie) {
    self.movie = movie
    self.title = movie.title
  }
  
  func loadDetails() {
    guard let movie = self.movie else { return }
    view?.loadMovieDetails(movie)
    interactor?.loadImage(of: movie)
  }
  
  func loadVideo() {
    guard let movie = self.movie else { return }
    let apiclient = APIClient()
    apiclient.fetchYouTubeKey(of: movie) { key in
      self.view?.loadTailerVideo(key)
    }
  }
  
}
extension MovieDetailPresenter:  MovieDetailInteractorOutputProtocol {
  func loadImage(_ image: UIImage) {
    view?.loadMovieImage(image)
  }
}
