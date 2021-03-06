//
//  Speaker.swift
//  hackertracker
//
//  Created by Seth W Law on 6/6/22.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

struct Speaker: Codable, Equatable {
    @DocumentID var docId: String?
    var id: Int
    var conferenceName: String
    var description: String
    var link: String
    var name: String
    var title: String?
    var twitter: String
    var events: [SpeakerEvent]

    static func == (lhs: Speaker, rhs: Speaker) -> Bool {
        if lhs.id == rhs.id, lhs.name == rhs.name, lhs.description == rhs.description {
            return true
        } else {
            return false
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case conferenceName = "conference"
        case description
        case link
        case name
        case title
        case twitter
        case events
    }
}

struct SpeakerEvent: Codable, Identifiable {
    var id: Int
    var title: String?
}
