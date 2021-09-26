//
//  MovieDetailRouter.swift
//  BillboardMovieApp
//
//  Created by Meli on 9/25/21.

import Foundation

class MovieDetailRouter: MovieDetailRouterProtocol {
  
  typealias MovieDetailPresenterProtocols = MovieDetailPresenterProtocol & MovieDetailInteractorOutputProtocol

  class func createMovieTrailerModule(for view: MovieDetailViewController, and movie: Movie) {
    let presenter: MovieDetailPresenterProtocols = MovieDetailPresenter(movie: movie)
    view.presenter = presenter
    view.presenter?.view = view
    view.presenter?.interactor = MovieDetailInteractor()
    view.presenter?.interactor?.presenter = presenter
    view.presenter?.router = MovieDetailRouter()
  }
}
