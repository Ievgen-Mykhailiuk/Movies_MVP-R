//
//  Model.swift
//  Movies
//
//  Created by Евгений  on 26/09/2022.
//

import UIKit

//MARK: - UI Movie Model
struct MovieModel {
    
    let genres: [String]
    let id: Int
    let popularity: String
    let posterPath: String
    let releaseYear: String
    let title: String
    let votesAverage: String
    let votesCount: String
    let overview: String
    let page: Int?
    let totalPages: Int?
    
    static func from(networkResponse: MovieResponse, using genres: [GenreModel]) -> [MovieModel] {
        var movies = [MovieModel]()
        for networkModel in networkResponse.results {
            let genres = networkModel.genreIDS.compactMap { id in
                genres.first(where: { $0.id == id })?.name
            }
            let releaseYear = Date.getYear(from: networkModel.releaseDate)
            let movie = MovieModel(genres: genres,
                                   id: networkModel.id,
                                   popularity: networkModel.popularity.stringDecimalValue,
                                   posterPath: networkModel.posterPath,
                                   releaseYear: releaseYear,
                                   title: networkModel.title,
                                   votesAverage: networkModel.votesAverage.stringDecimalValue,
                                   votesCount: networkModel.voteCount.stringValue,
                                   overview: networkModel.overview,
                                   page: networkResponse.page,
                                   totalPages: networkResponse.totalPages)
            movies.append(movie)
        }
        return movies
    }
    
    static func from(entity: MovieEntity) -> MovieModel {
        let model = MovieModel(genres: entity.genres,
                               id: Int(entity.id),
                               popularity: entity.popularity,
                               posterPath: entity.posterPath,
                               releaseYear: entity.releaseYear,
                               title: entity.title,
                               votesAverage: entity.votesAverage,
                               votesCount: entity.votesCount,
                               overview: entity.overview,
                               page: nil,
                               totalPages: nil)
        return model
    }
    
}

//MARK: - Response Movie Data
struct MovieResponse: Codable {
    
    let page: Int
    let results: [MovieData]
    let totalPages: Int
    
    private enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decodeIfPresent(Int.self, forKey: .page) ?? .zero
        self.results = try container.decodeIfPresent([MovieData].self, forKey: .results) ?? []
        self.totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages) ?? .zero
    }
    
}

struct MovieData: Codable {
    
    let genreIDS: [Int]
    let id: Int
    let overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate, title: String
    let votesAverage: Double
    let voteCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case genreIDS = "genre_ids"
        case id, overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case votesAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.genreIDS = try container.decodeIfPresent([Int].self, forKey: .genreIDS) ?? []
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? .zero
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview) ?? .empty
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity) ?? .zero
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? .empty
        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? .empty
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? .empty
        self.votesAverage = try container.decodeIfPresent(Double.self, forKey: .votesAverage) ?? .zero
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount) ?? .zero
    }
    
}
