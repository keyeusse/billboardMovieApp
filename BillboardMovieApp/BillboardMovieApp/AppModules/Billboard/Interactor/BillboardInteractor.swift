//
//  BillboardInteractor.swift
//  BillboardMovieApp
//
//  Created by Meli on 9/26/21.

import UIKit

class CatalogInteractor: CatalogInteractorInputProtocol {
  
  weak var presenter: CatalogInteractorOutputProtocol?
  private let apiClient = APIClient()
  private var movieResults: MovieResults?
  
  private var popular: [Movie] = []
  private var topRated: [Movie] = []
  private var upcoming: [Movie] = []
  private(set) var sections: [Category] = []
  var genresCategories: [Genre] = []
  var genresFilteredIds: [Int] = []
  
  // This is for cache
  var cacheDataManager: CacheDataManager = CacheDataManager()
  
  private var filteredData: [Movie] = []
  
  // REquest data to load movies and images
  func fetchMoviesData() {
    if ConnectivityToIntenet.isConnectedToInternet {
      apiClient.delegate = self
      // Request fot Genres list
      apiClient.getGenreList(url: .genreTV, release: .none, lang: .US)
      apiClient.getGenreList(url: .genreMovie, release: .none, lang: .US)
        
      // Request for Movie list by genre
      apiClient.getMovieList(url: .movie, release: .popular,  lang: .US)
      apiClient.getMovieList(url: .movie, release: .topRated, lang: .US)
      apiClient.getMovieList(url: .movie, release: .upcoming, lang: .US)
        
      // Request for Movie list and TV shows List
      apiClient.getMovieList(url: .tv, release: .popular,  lang: .US)
      apiClient.getMovieList(url: .tv, release: .topRated, lang: .US)
      apiClient.getMovieList(url: .tv, release: .upcoming, lang: .US)
    } else {
      // get data from local storage
      let update: () -> Void = { self.presenter?.updateData() }
      loadFromLocalStorage(category: .popular, completion: update)
      loadFromLocalStorage(category: .topRated, completion: update)
      loadFromLocalStorage(category: .upcoming, completion: update)
    }
  }
  
  func loadFromLocalStorage(category: Category, completion: @escaping () -> Void) {
    let dataManager = DataManager()
    dataManager.getMoviesData(from: category.rawValue) {
      if category == .popular  { self.popular = $0 }
      if category == .topRated { self.topRated = $0 }
      if category == .upcoming { self.upcoming = $0 }
      self.appendSection(category)
      completion()
    }
    dataManager.getGenres { genres in
      self.genresCategories = genres ?? []
    }
  }
  
  func getImageFromLocalStorage(key: String) -> UIImage? {
    // Get image From Local Storage
    var image: UIImage?
    if !ConnectivityToIntenet.isConnectedToInternet {
      let dataManager = DataManager()
      dataManager.getImageDataFrom(key: key) { data in
        guard let data = data else { return }
        image =  UIImage(data: data)
      }
    }
    return image
  }
  
  // For data filter
  func filterSearch(text: String) {
    if text.isEmpty {
      self.filteredData = []
      return
    }
    let allData: [[Movie]] = [popular, topRated, topRated]
    allData.forEach { movies in
      let results = filterArray(input: text, data: movies)
      if !results.isEmpty {
        self.filteredData = results
        return
      }
    }
  }
  
  private func filterArray(input: String, data: [Movie]) -> [Movie] {
    let results = data.filter {
      if let title = $0.title {
        return title.contains(input)
      }
      if let name = $0.name {
        return name.contains(input)
      }
      return false
    }
    return results
  }
  
  func filterByGenre(_ ids: [Int]) {
    self.genresFilteredIds = ids
    if ids.isEmpty {
      self.filteredData = []
      return
    }
    let allData: [[Movie]] = [popular, topRated, topRated]
    allData.forEach { movies in
      let results = finterByGenre(ids, data: movies)
      if !results.isEmpty {
        self.filteredData = results
        return
      }
    }
  }
  
  private func finterByGenre(_ ids: [Int], data: [Movie]) -> [Movie] {
    let results = data.filter {
      if let movieIds = $0.genereIds {
        return movieIds.contains{ ids.contains($0) }
      }
      return false
    }
    return results
  }
  

  func getNumberOfItemsAt(_ index: Int, isFiltering: Bool) -> Int {
    return isFiltering ? filteredData.count : getNumberOfItems(index)
  }
  
    //button search selection
  private func getNumberOfItems(_ index: Int) -> Int {
    let section = sections[index]
    switch section {
    case .popular:
      return popular.count
    case .upcoming:
      return upcoming.count
    case .topRated:
      return topRated.count
    case .none:
      return 0
    }
  }

  func getItemAt(_ indexPath: IndexPath, isFiltering: Bool) -> Movie? {
    if indexPath.row < filteredData.count && isFiltering {
      return filteredData[indexPath.row]
    } else {
      return getItemAt(indexPath)
    }
  }
  
  private func getItemAt(_ indexPath: IndexPath) -> Movie? {
    let section = sections[indexPath.section]
    return getDataFrom(section: section, at: indexPath.row)
  }
  
  func getDataFrom(section: APIMovieCategoryParams, at row: Int) -> Movie? {
    switch section {
    case .popular:
      return popular[row]
    case .upcoming:
      return upcoming[row]
    case .topRated:
      return topRated[row]
    case .none:
      return nil
    }
  }
  
  func getSections() -> [String] {
    var output: [String] = []
    sections.forEach {
      switch $0 {
      case .popular:
        output.append(MovieCategories.popular.rawValue)
      case .upcoming:
        output.append(MovieCategories.upcoming.rawValue)
      case .topRated:
        output.append(MovieCategories.topRated.rawValue)
      case .none:
        break
      }
    }
    return output
  }
}

//API Calls for movies and series
extension CatalogInteractor: APIResponseProtocol {
  
  func getMovieGenres(data: Genres) {
    let local = DataManager()
    data.categories.forEach { genre in
      if !genresCategories.contains(genre){
        self.genresCategories.append(genre)
        local.saveEntryOf(genre: genre)
      }
    }
  }
  
  func getMovieResult(data: MovieResults) {
    if let section = data.category, let movies = data.results {
      appendSection(section)
      storeMovies(movies: movies, category: section)
        
      switch section {
      case .popular:
        self.popular.append(contentsOf: movies)
      case .upcoming:
        self.upcoming.append(contentsOf: movies)
      case .topRated:
        self.topRated.append(contentsOf: movies)
      case .none:
        break
      }
    }
    self.presenter?.updateData()
  }
  

  private func appendSection(_ section: Category) {
    if !self.sections.contains(section) {
      self.sections.append(section)
    }
  }
  
  private func storeMovies(movies: [Movie], category: Category) {
    let dataManager = DataManager()
    movies.forEach {
      dataManager.saveEntryOf(movie: $0, category: category)
    }
  }
  
  // Manage error response
  func onFailure(_ error: Error) {
    presenter?.receivedError(error)
  }
}

