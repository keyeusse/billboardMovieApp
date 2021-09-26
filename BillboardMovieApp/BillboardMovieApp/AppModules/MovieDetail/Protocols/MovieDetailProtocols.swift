//
//  MovieDetailProtocols.swift
//  BillboardMovieApp
//
//  Created by Meli on 9/26/21.

import UIKit

// VIPER Protocols
protocol MovieDetailViewProtocol: AnyObject {
  var presenter: MovieDetailPresenterProtocol? { get set }
  // PRESENTER -> VIEW
  func loadMovieDetails(_ movie: Movie)
  func loadMovieImage(_ image: UIImage)
  func loadTrailerVideo(_ key: String?)
  func showErrorMessage(_ message: String)
}

protocol MovieDetailPresenterProtocol: AnyObject {
  var view: MovieDetailViewProtocol? { get set }
  var interactor: MovieDetailInteractorInputProtocol? { get set }
  var router: MovieDetailRouterProtocol? { get set }
  // VIEW -> PRESENTER
  var title: String? { get set }
  func loadDetails()
  func loadTrailerVideo()
}

protocol MovieDetailInteractorInputProtocol: AnyObject {
  var presenter: MovieDetailInteractorOutputProtocol? { get set }
  var cacheDataManager: CacheDataManager { get set }
  var coverImage: UIImage? { get set }
  // PRESENTER -> INTERACTOR
  func loadImage(of movie: Movie)
}

protocol MovieDetailInteractorOutputProtocol: AnyObject {
  // INTERACTOR -> PRESENTER
  func loadImage(_ image: UIImage)
}

protocol MovieDetailRouterProtocol: AnyObject {
  // PRESENTER -> ROUTER
}
