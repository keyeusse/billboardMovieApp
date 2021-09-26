//
//  DataManagerProtocols.swift
//  BillboardMovieApp
//
//  Created by Meli on 9/26/21.
//

import UIKit
import CoreData

// Protocols to help get coredata entity names
protocol EntityNameProtocol: AnyObject {
  func getEntityName() -> String
}
extension EntityNameProtocol where Self: NSManagedObject {
  func getEntityName() -> String {
    let thisType = type(of: self)
    return String(describing: thisType)
  }
}

//Core data for every api call
extension CDResult: EntityNameProtocol {}
extension CDMovie: EntityNameProtocol {}
extension CDGenre: EntityNameProtocol {}
extension CDAllGenres: EntityNameProtocol {}
extension CDGallery: EntityNameProtocol {}
extension CDImages: EntityNameProtocol {}
