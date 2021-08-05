//
//  Database.swift
//  SevenWondersStatTracker
//
//  Created by Martin Peshevski on 13.7.21.
//

import Foundation
import Firebase

struct User {
    var name: String
}

class DatabaseManager {
    var ref: DatabaseReference
    var users: [User] = []
    
    init() {
        ref = Database.database().reference()
    }
    
    func loadUsers(completion: @escaping ([User]) -> Void) {
        ref.child("users").getData { [weak self] error, snapshot in
            guard let self = self else { return }
            if let error = error {
                print("Error getting data \(error)")
                completion([])
            }
            else if snapshot.exists() {
                print("Got data \(snapshot.value!)")
                guard let value = snapshot.value as? [String] else {
                    print("Data in wrong type")
                    completion([])
                    return
                }
                for username in value {
                    if self.users.filter({ $0.name == username }).isEmpty {
                        self.users.append(User(name: username))
                    }
                }
                completion(self.users)
            }
            else {
                print("No data available")
                completion([])
            }
        }
    }
    
    func addUser(_ user: User) {
        users.append(user)
        ref.child("users").setValue(users.map { $0.name })
    }
}
