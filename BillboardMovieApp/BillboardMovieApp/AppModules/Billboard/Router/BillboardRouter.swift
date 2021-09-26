//
//  Router.swift
//  BillboardMovieApp
//
//  Created by Meli on 9/25/21.

import UIKit

//Class to navegatio between VC
class CatalogRouter: CatalogRouterProtocol {
  
  typealias CatalogPresenterProtocols = CatalogPresenterProtocol & CatalogInteractorOutputProtocol
  
  class func createModule(view: CatalogViewController) {
    let presenter: CatalogPresenterProtocols = CatalogPresenter()
    view.presenter = presenter
    view.presenter?.router = CatalogRouter()
    view.presenter?.view = view
    view.presenter?.interactor = CatalogInteractor()
    view.presenter?.interactor?.presenter = presenter
  }
  
  func presentMovieDetailView(for movie: Movie, from view: UIViewController) {
    guard let detailView = view.storyboard?.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else { return }
    MovieDetailRouter.createMovieTrailerModule(for: detailView, and: movie)
    view.navigationController?.pushViewController(detailView, animated: true)
  }
  
  func presentCategoryFilterView(from view: UIViewController,
                                 categories: [Genre],
                                 filteredIds: [Int],
                                 delegate: CategoryFilterDelegate?) {
    guard let filterView = view.storyboard?.instantiateViewController(withIdentifier: "CategoryFilterViewController") as? CategoryFilterViewController else { return }
    filterView.items = categories
    filterView.delegate = delegate
    filterView.selectedGenresIds = filteredIds
    view.present(filterView, animated: true, completion: nil)
  }
  
  func presentCategoryFilterView(from view: UIViewController, categories: [Genre], filteredIds: [Int],
                                 delegate: CategoryFilterDelegate?, transitionDelegate: UIViewControllerTransitioningDelegate?) {
    guard let filterView = view.storyboard?.instantiateViewController(withIdentifier: "CategoryFilterViewController") as? CategoryFilterViewController else { return }
    filterView.transitioningDelegate = transitionDelegate
    filterView.modalPresentationStyle = .custom
    filterView.items = categories
    filterView.delegate = delegate
    filterView.selectedGenresIds = filteredIds
    view.present(filterView, animated: true, completion: nil)
  }
    
}
