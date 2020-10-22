//
//  AlbumController.swift
//  albums
//
//  Created by Jeff Kang on 10/19/20.
//

import Foundation

class AlbumController {
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
    }
    
    enum TestError: Error {
        case noData
        case tryAgain
    }
    
    enum NetworkError: Error {
        case noData
        case tryAgain
        case failedPut
    }
    
    var albums: [Album] = []
    
    private let baseURL = URL(string: "https://ios-album.firebaseio.com/")!
    
    func getAlbums(completion: @escaping (Result<[Album], NetworkError>) -> Void) {
        var request = URLRequest(url: baseURL.appendingPathExtension("json"))
        request.httpMethod = HTTPMethod.get.rawValue
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error retrieving albums data: \(error)")
                completion(.failure(.tryAgain))
                return
            }
            guard let data = data else {
                print("No data received from getAlbums")
                completion(.failure(.noData))
                return
            }
            do {
                print(data)
                let albums = try JSONDecoder().decode([String: Album].self, from: data)
                print(albums)
                self.albums = albums.map {$0.value}
                print("Successfully retrieved albums")
            } catch {
                print("Error decoding albums data: \(error)")
                completion(.failure(.tryAgain))
            }
        }.resume()
    }
    
    func putAlbums(album: Album) {
        
        let putAlbumURL = baseURL.appendingPathComponent(album.id).appendingPathExtension("json")
        var request = URLRequest(url: putAlbumURL)
        request.httpMethod = HTTPMethod.put.rawValue
        do {
            let jsonData = try JSONEncoder().encode(album)
            request.httpBody = jsonData
            URLSession.shared.dataTask(with: request) { (_, _, error) in
                if let error = error {
                    print("Failed put of album: \(error)")
                }
            }.resume()
        } catch {
            print("Error encoding album: \(error)")
        }
    }
    
    func createAlbum(artist: String, coverArt: [URL], genres: [String], name: String, songs: [Song]) {
        let newAlbum = Album(artist: artist, coverArt: coverArt, genres: genres, name: name, songs: songs)
        albums.append(newAlbum)
        putAlbums(album: newAlbum)
    }
    
    func createSong(duration: String, title: String) -> Song {
        let newSong = Song(duration: duration, title: title)
        print(newSong)
        return newSong
    }
    
    func update(album: Album, with name: String, coverArt: [URL], genres: [String], artist: String, songs: [Song]) {
        var updateAlbum = album
        updateAlbum.artist = artist
        updateAlbum.coverArt = coverArt
        updateAlbum.genres = genres
        updateAlbum.name = name
        updateAlbum.songs = songs
        putAlbums(album: updateAlbum)
    }
    
    func testDecodingExampleAlbum() {
        
        guard let urlPath = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json") else {
            print("Could not locate exampleAlbum")
            return
        }
        
        let album: Album
        
        do {
            let jsonData = try Data(contentsOf: urlPath)
            album = try JSONDecoder().decode(Album.self, from: jsonData)
            print(album)
        } catch {
            print("Error decoding data from exampleAlbum")
        }
        
    }
    
    func testEncodingExampleAlbum() {
        
        guard let urlPath = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json") else {
            print("Could not locate exampleAlbum")
            return
        }
        
        let album: Album
        
        do {
            let jsonData = try Data(contentsOf: urlPath)
            album = try JSONDecoder().decode(Album.self, from: jsonData)
            print(album)
        } catch {
            print("Error decoding data from exampleAlbum")
            return
        }
        
        do {
            let encodedJsonData = try JSONEncoder().encode(album)
            print(encodedJsonData)
        } catch {
            print("Error encoding album to json")
        }
        
    }
    
}
