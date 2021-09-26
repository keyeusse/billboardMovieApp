//
//  MovieDetailViewController.swift
//  BillboardMovieApp
//
//  Created by Meli on 9/25/21.

import UIKit
import youtube_ios_player_helper

class MovieDetailViewController: UIViewController {
    
  @IBOutlet private weak var viewPlayerVideo: YTPlayerView!
  @IBOutlet private weak var imageCover: UIImageView!
  @IBOutlet private weak var labelMovieName: UILabel!
  @IBOutlet private weak var labelMovieDetails: UILabel!
  @IBOutlet private weak var buttonWatchTrailer: RoundButton!
  @IBOutlet private weak var textViewMovieDescription: UITextView!
  @IBOutlet weak var rattingLabel: UILabel!
  
   var presenter: MovieDetailPresenterProtocol?
  
  private var movie: Movie?
  
  private let nowPlayingTitle: String = "Playing trailer"
  private let notAvailableTitle: String = "Trailer No Available"
    
  @IBAction func watchTrailer(_ sender: Any) {
      presenter?.loadTrailerVideo()
  }

  // Show video trailer from youtube
  private var videoKey: String = "" {
    didSet {
      if !videoKey.isEmpty {
        self.imageCover.isHidden = true
        self.viewPlayerVideo.load(withVideoId: videoKey, playerVars: VideoYouTubeParams)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.imageCover.alpha = 0
    presenter?.loadDetails()
    self.viewPlayerVideo.delegate = self
  }
}

// Protocols
extension MovieDetailViewController: MovieDetailViewProtocol {
  
  func loadMovieImage(_ image: UIImage) {
    self.imageCover.image = image
    self.imageCover.setRoundedCorners(radius: 10)
    Animations.showFade(view: imageCover)
  }
  
  func loadMovieDetails(_ movie: Movie) {
    self.movie = movie
    if let title = movie.title {
      self.labelMovieName.text = title
    }
    if let name = movie.name {
      self.labelMovieName.text = name
    }
    self.labelMovieDetails.text = MovieDetails.showDate(of: movie)
    self.rattingLabel.text = MovieDetails.showRatting(of: movie)
    
    if(movie.overview != ""){
        self.textViewMovieDescription.text = movie.overview
    } else {
        self.textViewMovieDescription.text = "Movie description not available"
    }
  }
  
  func loadTrailerVideo(_ key: String?) {
    if let key = key{
      self.videoKey = key
      self.buttonWatchTrailer.setTitle(self.nowPlayingTitle, for: .normal)
    } else {
      self.buttonWatchTrailer.setTitle(self.notAvailableTitle, for: .normal)
    }
    self.buttonWatchTrailer.isEnabled = false
  }
  
  func showErrorMessage(_ message: String) {
    let alert = Animations().showSimpleAlert(title: "Error, try again later", message: message)
    self.present(alert, animated: true, completion: nil)
  }
}

// Protocol to youtube video
extension MovieDetailViewController : YTPlayerViewDelegate {
  func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
    self.viewPlayerVideo.playVideo()
  }
}
