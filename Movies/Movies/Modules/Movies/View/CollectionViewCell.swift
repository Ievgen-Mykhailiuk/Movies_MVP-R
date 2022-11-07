//
//  CollectionViewCell.swift
//  Movies
//
//  Created by Евгений  on 26/09/2022.
//

import UIKit
import Kingfisher

final class CollectionViewCell: BaseCollectionViewCell {

    //MARK: - Outlets
    @IBOutlet private weak var topGradientView: UIView!
    @IBOutlet private weak var bottomGradientView: UIView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var genresTotalLabel: UILabel!
    @IBOutlet private weak var starImageView: UIImageView!
    @IBOutlet private weak var votesCountLabel: UILabel!
    
    //MARK: - Properties
    private let radius: CGFloat = 10
    private let gradientColorSet: [UIColor] = [
        UIColor.black.withAlphaComponent(0.6),
        UIColor.black.withAlphaComponent(0.4),
        UIColor.black.withAlphaComponent(0.3),
        UIColor.black.withAlphaComponent(0.2),
        UIColor.black.withAlphaComponent(0.1),
        UIColor.black.withAlphaComponent(0)
    ]
    
    //MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        applyVisualEffects()
    }
    
    //MARK: - Private methods
    private func applyVisualEffects() {
        contentView.cornerRadius = radius
        topGradientView.addGradient(with: gradientColorSet, startPoint: .topCenter, endPoint: .bottomCenter)
        bottomGradientView.addGradient(with: gradientColorSet, startPoint: .bottomCenter, endPoint: .topCenter)
        addShadow()
    }
    
    private func setPoster(for movie: MovieModel) {
        posterImageView.kf.cancelDownloadTask()
        posterImageView.image = nil
        let urlString = EndPoint.poster(size: .small, path: movie.posterPath).urlString
        posterImageView.setImage(urlString: urlString, placeholder: Constants.placeholder)
    }
    
    //MARK: - Configuration method
    func configure(for movie: MovieModel) {
        setPoster(for: movie)
        titleLabel.text = [movie.title, movie.releaseYear].joined(separator: .commaSeparator)
        genresTotalLabel.text = movie.genres.joined(separator: .commaSeparator)
        votesCountLabel.text = movie.votesCount
    }
}
