//
//  BillboardMovieAppTests.swift
//  BillboardMovieAppTests
//
//  Created by Meli on 9/26/21.
//  Copyright © 2021 Rappi. All rights reserved.
//

import XCTest
import ObjectMapper
import Foundation
@testable import BillboardMovieApp

class BillboardMovieAppTests: XCTestCase {

    private var apiClient: APIClientMock?
    
    override func setUp() {
      self.apiClient = APIClientMock()
      self.apiClient?.delegate = self
    }
    
    override func tearDown() {
      self.apiClient = nil
    }
    
    func getMoviesListTest() {
        self.apiClient?.getMovieList(url: .genreTV, release: .none, lang: .US)
    }
    
    func getGenresListTest() {
      self.apiClient?.getGenreList(url: .genreTV, release: .none, lang: .US)
    }
  }

extension BillboardMovieAppTests: APIResponseProtocol {
    func getMovieResult(data: MovieResults) {
        guard let resutls = data.results else {
          XCTFail()
          return
        }
        XCTAssert(!resutls.isEmpty, "Error")
    }
    
    func getMovieGenres(data: Genres) {
        XCTAssert(!data.categories.isEmpty, "Error")
    }
    
    func onFailure(_ error: Error) {
      print(error)
    }
  }
