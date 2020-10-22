//
//  Song.swift
//  albums
//
//  Created by Jeff Kang on 10/18/20.
//

import Foundation

struct Song: Codable {
    
    enum Keys: String, CodingKey {
        
        case duration
        case id
        case name
        
        enum durationKey: String, CodingKey {
            case duration
        }
        enum titleKey: String, CodingKey {
            case title
        }
        
    }
    
    var duration: String
    var id: String
    var title: String
    
    init(duration: String, title: String) {
        self.duration = duration
        self.id = UUID().uuidString
        self.title = title
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: Keys.self)
        
        let durationContainer = try container.nestedContainer(keyedBy: Keys.durationKey.self, forKey: .duration)
        let durationTime = try durationContainer.decode(String.self, forKey: .duration)
        duration = durationTime
        
        id = try container.decode(String.self, forKey: .id)
        
        let nameContainer = try container.nestedContainer(keyedBy: Keys.titleKey.self, forKey: .name)
        let titleValue = try nameContainer.decode(String.self, forKey: .title)
        title = titleValue
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: Keys.self)
        
        var durationContainer = container.nestedContainer(keyedBy: Keys.durationKey.self, forKey: .duration)
        try durationContainer.encode(duration, forKey: .duration)
        
        try container.encode(id, forKey: .id)
        
        var nameContainer = container.nestedContainer(keyedBy: Keys.titleKey.self, forKey: .name)
        try nameContainer.encode(title, forKey: .title)
        
    }
    
}
