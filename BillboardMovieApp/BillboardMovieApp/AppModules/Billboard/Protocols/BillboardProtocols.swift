//
//  Protocols.swift
//  BillboardMovieApp
//
//  Created by Meli on 9/25/21.

import UIKit

// MARK: - VIPER Protocols
protocol CatalogViewProtocol: AnyObject {
  var presenter: CatalogPresenterProtocol? { get set}
  // PRESENTER -> VIEW
  func loadMovies()
  func showErrorMessage(_ message: String)
}

protocol CatalogPresenterProtocol: AnyObject {
  var view: CatalogViewProtocol? { get set }
  var interactor: CatalogInteractorInputProtocol? { get set}
  var router: CatalogRouterProtocol? { get set }
  var showSearchResults: Bool { get set }
  // VIEW -> PRESENTER
  func getItemAt(indexPath: IndexPath) -> Movie?
  func getSections() -> [String]
  func getNumberOfSections() -> Int
  func getNumberOfItemsAt(_ index: Int) -> Int
  func getNameForSection(_ section: Int) -> String
  func loadMoviesData()
  func setupSegmentedControl(control: inout UISegmentedControl)
  // Show Views
  func showDetailView(for movie: Movie, from view: UIViewController)
  func showFilterView(from view: UIViewController, transitioningDelegate: UIViewControllerTransitioningDelegate)
  // FILTERING
  func filterSearch(input: String, completion: () -> Void)
  func filterGenres(input: [Int], completion: () -> Void)
  // IMAGE
  func getImageCache() -> NSCache<NSString, UIImage>?
  func getImageFromLocalStorage(key: String) -> UIImage?
}

protocol CatalogInteractorInputProtocol: AnyObject {
  var presenter: CatalogInteractorOutputProtocol? { get set}
  var cacheDataManager: CacheDataManager { get set }
  var genresCategories: [Genre] { get set }
  var genresFilteredIds: [Int] { get set }

  // PRESENTER -> INTERACTOR
  func fetchMoviesData()
  func getNumberOfItemsAt(_ index: Int, isFiltering: Bool) -> Int
  func getSections() -> [String]
  func getItemAt(_ indexPath: IndexPath, isFiltering: Bool) -> Movie?
  func filterSearch(text: String)
  func filterByGenre(_ ids: [Int])
  func getImageFromLocalStorage(key: String) -> UIImage?
}

protocol CatalogInteractorOutputProtocol: AnyObject {
  // INTERACTOR -> PRESENTER
  func updateData()
  func receivedError(_ error: Error)
}

protocol CatalogRouterProtocol: AnyObject {
  // PRESENTER -> ROUTER
  func presentMovieDetailView(for item: Movie, from view: UIViewController)
  func presentCategoryFilterView(from view: UIViewController, categories: [Genre], filteredIds: [Int], delegate: CategoryFilterDelegate?, transitionDelegate: UIViewControllerTransitioningDelegate?)
}

// MARK: - UITABLEVIEWCELL Protocols
protocol MovieTableViewCellDelegate: AnyObject {
  func showMovieTrailer(of movie: Movie)
}

// MARK: - CELL PROTOCOL Definition
protocol UITableViewCellReusableView {
  static func nib() -> UINib
  static func reuseIdentifier() -> String
}
extension UITableViewCellReusableView where Self: UITableViewCell {
  static func nib() -> UINib {
    return UINib(nibName: String(describing: self), bundle: nil)
  }
  static func reuseIdentifier() -> String {
    return String(describing: self)
  }
}
