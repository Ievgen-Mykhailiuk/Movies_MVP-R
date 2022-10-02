//
//  DetailsViewController.swift
//  Movies
//
//  Created by Евгений  on 26/09/2022.
//

import UIKit

protocol DetailsView: AnyObject {
    func showDetails(movie: DetailModel?)
    func didFailWithError(error: String)
}

final class DetailsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var releaseYearLabel: UILabel!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var trailerButton: UIButton!
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var votesCountLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    
    //MARK: - Properties
    var presenter: DetailsPresenter!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTrailerButton()
        setRecognizer()
        presenter.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction private func trailerButtonTapped(_ sender: Any) {
        presenter.playButtonTapped()
    }
    
    @objc private func imageTapped(_: UITapGestureRecognizer) {
        presenter.posterTapped()
    }
    
    //MARK: - Private Methods
    private func setupNavigationBar(title: String) {
        self.title = title
    }
    
    private func setupTrailerButton() {
        trailerButton.makeRounded()
        trailerButton.isHidden = true
    }
    
    private func setRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        posterImageView.isUserInteractionEnabled = true
        posterImageView.addGestureRecognizer(recognizer)
    }
    
    private func configure(movie: DetailModel?) {
        guard let movie = movie else { return }
        posterImageView.setImage(size: .medium, endPoint: .poster(path: movie.posterPath))
        countryLabel.text = movie.countries.joined(separator: ", ")
        movieNameLabel.text = movie.title
        genresLabel.text = movie.genres.joined(separator: ", ")
        releaseYearLabel.text = movie.releaseYear
        rankLabel.text = String(format: "%.1f", movie.voteAverage)
        votesCountLabel.text = String(movie.voteCount)
        overviewLabel.text = movie.overview
        if movie.trailerID != nil {
            trailerButton.isHidden = false
        }
    }
}

//MARK: - DetailsViewProtocol
extension DetailsViewController: DetailsView {
    func didFailWithError(error: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "Error", message: error)
        }
    }
    
    func showDetails(movie: DetailModel?) {
        DispatchQueue.main.async {
            self.setupNavigationBar(title: movie?.title ?? .empty)
            self.configure(movie: movie)
        }
    }
}
