//
//  BillboardViewController.swift
//  BillboardMovieApp
//
//  Created by Meli on 9/25/21.

import UIKit

class CatalogViewController: UIViewController {
  
  // IBOUTLETS
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var segmentedControl: UISegmentedControl!
  @IBOutlet private weak var buttonSearch: UIBarButtonItem!
  @IBOutlet weak var FilterCatButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: UIButton!
    
// Cell id
  private lazy var idCell: String = MovieTableViewCell.reuseIdentifier()
  

  
// Constants
  private let titleNavigation: String = "Billboard"
  private let fontSection: UIFont? = UIFont(name: "Futura", size: 20)
  private var currentSectionNumber = 0
  
  // SEARCH
  private let searchPlaceholder: String = "Search movie"
  private var searchController = UISearchController(searchResultsController: nil)
  
  // MARK: - VIPER
  var presenter: CatalogPresenterProtocol?
  let imageDownloader: ImageDownloader = ImageDownloader()
    
    // new view to filter movie
  let filterMovieView = CreationViewAnimation()
  

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    presenter?.loadMoviesData()
    let backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
            navigationItem.backBarButtonItem = backBarButtonItem
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.tableView.reloadData()
  }
  
  // Action buttons
  @IBAction func segmentedActions(_ sender: Any) {
    let section: Int = segmentedControl.selectedSegmentIndex
    segmentedControl.selectedSegmentIndex = section
    scrollTo(section: section)
  }

  @IBAction func search(_ sender: Any) {
    searchController.searchBar.becomeFirstResponder()
  }
  
  @IBAction func presentFilterGenresView(_ sender: Any) {
    //filterButton.bounce()
    presenter?.showFilterView(from: self, transitioningDelegate: self)
  }
    
  @IBAction func filterCategory(_ sender: Any) {
    presenter?.showFilterView(from: self, transitioningDelegate: self)
  }
  
  // MARK: - SETUP AND PRIVATE METHODS
  private func setup() {
    setupNavigationBar()
    // Segmented control basic setup
    segmentedControl.isEnabled = false
    segmentedControl.isHidden = true
    // Setup Viper Router
    CatalogRouter.createModule(view: self)
    // Setup SearchBar
    setupSearchController()
    // Setup TableView
    setupTableView()
  }
  
  private func scrollTo(section: Int) {
    let indexPath = IndexPath(row: 0, section: section)
    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
  }
  
  private func getItemAt(_ indexPath: IndexPath) -> Movie? {
    return presenter?.getItemAt(indexPath: indexPath)
  }
  
  private func setupTableView() {
    self.tableView.delegate = self
    self.tableView.dataSource = self
    self.tableView.estimatedRowHeight = 175.0
    self.tableView.rowHeight = UITableView.automaticDimension
    self.tableView.register(MovieTableViewCell.nib(), forCellReuseIdentifier: idCell)
  }
  
  private func setupSearchController() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = searchPlaceholder
    searchController.searchBar.sizeToFit()
    navigationItem.searchController = searchController
    searchController.searchBar.delegate = self
  }
  
  private func updateSegmentedControl() {
    presenter?.setupSegmentedControl(control: &segmentedControl)
  }
  
  private func filterSearch(_ searchController: UISearchController) {
    guard let input = searchController.searchBar.text else { return }
    presenter?.filterSearch(input: input) {
      self.tableView.reloadData()
    }
  }
  
  private func showSearchResults(_ show: Bool) {
    presenter?.showSearchResults = show
    segmentedControl.isEnabled = !show
    self.tableView.reloadData()
  }
  
  private func setupNavigationBar() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.tintColor = UIColor.blue
    self.navigationController?.navigationBar.topItem?.title = self.titleNavigation
  }
  
  private func reloadRowAt(_ indexPath: IndexPath) {
    self.tableView.beginUpdates()
    self.tableView.reloadRows( at: [indexPath], with: .fade)
    self.tableView.endUpdates()
  }

}

extension CatalogViewController: CatalogViewProtocol {
  
  func loadMovies() {
    self.tableView.reloadData()
    updateSegmentedControl()
  }

  func showErrorMessage(_ message: String) {
    self.tableView.isHidden = true
    self.navigationController?.navigationBar.isHidden = true
  }
}

// MARK: - Movie tableView Delegate and DataSource
extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return presenter?.getNumberOfSections() ?? 0
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return presenter?.getNameForSection(section)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter?.getNumberOfItemsAt(section) ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    currentSectionNumber = indexPath.section
    guard let movie = getItemAt(indexPath),
          let cell = tableView.dequeueReusableCell(withIdentifier: idCell) as? MovieTableViewCell
      else { return UITableViewCell()}
    
    // setup images fron local storage
    let key = getURL(of: movie)
    if let imageFromStorage = presenter?.getImageFromLocalStorage(key: key as String) {
      cell.setup(with: movie, image: imageFromStorage)
    } else {
    // No local storage, call api to download image
      let imageDownloaded = imageDownloader.loadImages(of: movie) { self.reloadRowAt(indexPath) }
      cell.setup(with: movie, image: imageDownloaded)
    }
    return cell
  }
    
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let movie = getItemAt(indexPath) else { return }
    presenter?.showDetailView(for: movie, from: self)
    self.tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    guard let header = view as? UITableViewHeaderFooterView,
          let font = fontSection else { return }
    header.textLabel?.font = font
    header.textLabel?.textColor = UIColor.blue
    header.contentView.backgroundColor = UIColor.white
  }

}
// SEARCHBAR Delegate
extension CatalogViewController: UISearchResultsUpdating, UISearchBarDelegate {
  
  func updateSearchResults(for searchController: UISearchController) {
    filterSearch(searchController)
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    showSearchResults(true)
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    showSearchResults(false)
    searchController.searchBar.resignFirstResponder()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    if let show = presenter?.showSearchResults, !show {
       showSearchResults(true)
    }
    searchController.searchBar.resignFirstResponder()
  }
}


// MARK: - New view to show filter feature
extension CatalogViewController: UIViewControllerTransitioningDelegate {

    
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    self.filterMovieView.transition = .present
    self.filterMovieView.appearPoint = self.filterButton.center
    self.filterMovieView.newViewColor = self.filterButton.backgroundColor ?? UIColor.white
    return self.filterMovieView
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    self.filterMovieView.transition = .dismiss
    self.filterMovieView.appearPoint = self.filterButton.center
    self.filterMovieView.newViewColor = self.filterButton.backgroundColor ?? UIColor.white
    return self.filterMovieView
  }
}
