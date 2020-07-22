//
//  Profile.swift
//  CoreDataCodables
//
//  Created by Michael San Diego on 7/8/20.
//  Copyright © 2020 Michael San Diego. All rights reserved.
//

import Foundation
import CoreData

@objc(Profile)
class Profile: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case type = "type"
        case avatar_url = "avatar_url"
        case followers = "followers"
        case following = "following"
        case company = "company"
        case blog = "blog"
        case location = "location"
        case bio = "bio"
        case name = "name"
        case notes = "notes"
        case seen = "seen"
    }
    
    @NSManaged var login: String
    @NSManaged var type: String
    @NSManaged var avatar_url: String
    @NSManaged var id: Int32
    @NSManaged var bio: String?
    @NSManaged var blog: String?
    @NSManaged var company: String?
    @NSManaged var followers: Int32
    @NSManaged var following: Int32
    @NSManaged var location: String?
    @NSManaged var name: String?
    @NSManaged var notes: String?
    @NSManaged var seen: Bool
    
    // MARK: - Decodable
    /*
     Decoding protocol to convert NSManagedObject to JSON
     Decodable protocol by implementing its required initializer. init(from: ):
     */
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Profile", in: managedObjectContext)
            else { fatalError("Failed to decode User") }

        self.init(entity: entity, insertInto: managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            login = try container.decode(String.self, forKey: .login)
            self.type = try container.decode(String.self, forKey: .type)
            self.id = try container.decode(Int32.self, forKey: .id)
            self.avatar_url = try container.decode(String.self, forKey: .avatar_url)
            
            self.bio = try container.decodeIfPresent(String.self, forKey: .bio) ?? ""
            self.blog = try container.decodeIfPresent(String.self, forKey: .blog) ?? ""
            self.company = try container.decodeIfPresent(String.self, forKey: .company) ?? ""
            self.followers = try container.decodeIfPresent(Int32.self, forKey: .followers) ?? 0
            self.following = try container.decodeIfPresent(Int32.self, forKey: .following) ?? 0
            self.location = try container.decodeIfPresent(String.self, forKey: .location) ?? ""
            self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
            self.notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
            self.seen = try container.decodeIfPresent(Bool.self, forKey: .seen) ?? false
            
        } catch {
            print("Error decoding!")
        }
    }

    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(login, forKey: .login)
            try container.encode(id, forKey: .id)
            try container.encode(avatar_url, forKey: .avatar_url)
            try container.encode(type, forKey: .type)
            
            try container.encode(bio ?? "", forKey: .bio)
            try container.encode(blog ?? "", forKey: .blog)
            try container.encode(company ?? "", forKey: .company)
            try container.encodeIfPresent(followers, forKey: .followers)
            try container.encodeIfPresent(following, forKey: .following)
            try container.encode(location, forKey: .location)
            try container.encode(name, forKey: .name)
            try container.encodeIfPresent(notes, forKey: .notes)
            
            try container.encodeIfPresent(seen, forKey: .seen)
        } catch {
            print("Error encoding!")
        }
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

extension Profile {
    public func update(with profile: Profile) {
        self.setValue(self.name, forKey: "name")
        self.setValue(self.avatar_url, forKey: "avatar_url")
        self.setValue(self.bio, forKey: "bio")
        self.setValue(self.blog, forKey: "blog")
        self.setValue(self.company, forKey: "company")
        self.setValue(self.followers, forKey: "followers")
        self.setValue(self.following, forKey: "following")
        self.setValue(self.location, forKey: "location")
        self.setValue(self.type, forKey: "type")
        self.setValue(profile.notes, forKey: "notes")
        self.setValue(profile.seen, forKey: "seen")
    }
}
