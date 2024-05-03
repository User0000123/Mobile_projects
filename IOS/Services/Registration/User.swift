//
//  User.swift
//  MP
//
//  Created by aleksej on 3/22/24.
//

import Foundation

public class CustomUser : Codable {
    private static var jsonDecoder = JSONDecoder()
    private static var jsonEncoder = JSONEncoder()
    
    var firstName: String?
    var lastName: String?
    var favourites : [String]?
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.favourites = [String]()
    }
    
    public func getEncoded() -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: CustomUser.jsonEncoder.encode(self), options: [])
        } catch {
            print("Error in encoding")
            return nil
        }
    }
}
