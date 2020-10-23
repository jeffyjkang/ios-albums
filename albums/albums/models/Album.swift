//
//  Album.swift
//  albums
//
//  Created by Jeff Kang on 10/18/20.
//

import Foundation

struct Album: Codable {
    
    enum Keys: String, CodingKey {
        case artist
        case coverArt
        case genres
        case id
        case name
        case songs
        
        enum URLKeys: String, CodingKey {
            case url
        }
        
    }
    
    var artist: String
    var coverArt: [URL]
    var genres: [String]
    var id: String
    var name: String
    var songs: [Song]
    
    init(artist: String, coverArt: [URL], genres: [String], name: String, songs: [Song]) {
        self.artist = artist
        self.coverArt = coverArt
        self.genres = genres
        self.id = UUID().uuidString
        self.name = name
        self.songs = songs
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: Keys.self)
        
        artist = try container.decode(String.self, forKey: .artist)
        
        var coverArtsContainer = try container.nestedUnkeyedContainer(forKey: .coverArt)
        var url: [String] = []
        while coverArtsContainer.isAtEnd == false {
            let urlContainer = try coverArtsContainer.nestedContainer(keyedBy: Keys.URLKeys.self)
            let urlImage = try urlContainer.decode(String.self, forKey: .url)
            url.append(urlImage)
        }
        coverArt = url.compactMap {URL(string: $0)}
        
        var genreContainer = try container.nestedUnkeyedContainer(forKey: .genres)
        var genreTypes: [String] = []
        while genreContainer.isAtEnd == false {
            let currentGenre = try genreContainer.decode(String.self)
            genreTypes.append(currentGenre)
        }
        genres = genreTypes
        
        id = try container.decode(String.self, forKey: .id)
        
        name = try container.decode(String.self, forKey: .name)
        
        var songsContainer = try container.nestedUnkeyedContainer(forKey: .songs)
        var songsList: [Song] = []
        while songsContainer.isAtEnd == false {
            let currentSong = try songsContainer.decode(Song.self)
            songsList.append(currentSong)
        }
        songs = songsList
        
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(artist, forKey: .artist)
        
        var coverArtsContainer = container.nestedUnkeyedContainer(forKey: .coverArt)
        for coverArtURL in coverArt {
            var coverArtContainer = coverArtsContainer.nestedContainer(keyedBy: Keys.URLKeys.self)
            try coverArtContainer.encode(coverArtURL.absoluteString, forKey: .url)
        }
        
        try container.encode(genres, forKey: .genres)
        
        try container.encode(id, forKey: .id)
        
        try container.encode(name, forKey: .name)
        
        try container.encode(songs, forKey: .songs)
        
    }
    
}
