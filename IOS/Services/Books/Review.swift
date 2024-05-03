//
//  File.swift
//  MP
//
//  Created by aleksej on 4/6/24.
//

import Foundation

public class Review : Codable{
    private static var jsonDecoder = JSONDecoder()
    private static var jsonEncoder = JSONEncoder()
    
    var email: String
    var description: String
    
    init(email: String, description: String) {
        self.email = email
        self.description = description
    }
    
    public func getEncoded() -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: Review.jsonEncoder.encode(self), options: [])
        } catch {
            print("Error in encoding")
            return nil
        }
    }
}
