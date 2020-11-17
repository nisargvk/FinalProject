//
//  UserViewModel.swift
//  meetups
//
//  Created by Mac on 28.10.2020.
//

import Foundation
import Firebase

// TODO: Split into sub-modules
// TODO: A directory for each View-Model with all utilities
// TODO: Move some logic into Model - Upload / ID-Generation

struct UserData: Codable {
    let username: String
    let email: String
    let password: String
    
    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = password
    }
    
    enum CodingKeys: String, CodingKey {
        case username
        case email
        case password
    }
}

enum UserCreationError: Error {
    case usernameExists
    case emailExists
    case profileImage
    case other
}

enum ProfileImageError: Error {
    case noUser
    case other
}

class UserProfile: ObservableObject {
    @Published var username: String
    @Published var email: String
    @Published var profileImage: String
    
    init(username: String, email: String, profileImage: String) {
        self.username = username
        self.email = email
        self.profileImage = profileImage
    }
}

class UserViewModel: ObservableObject {
    private let firestore: Firestore
    private let functions: Functions
    private let auth: Auth
    private let storage: Storage
    
    private var userListener: ListenerRegistration? = nil
    private var authListener: AuthStateDidChangeListenerHandle? = nil
    
    private var user: User? = nil
    
    // TODO: Move to Model
    // TODO: Configuring extension
    private func imagePath(userId: String) -> String {
        return "raw-profiles/\(userId)/\(UUID().uuidString).jpg"
    }
    
    // TODO: Move to Model
    // TODO: Convfiguring extension
    private func imageMetadata() -> StorageMetadata {
        let metadata = StorageMetadata()
        
        // TODO: Configure (Using PNG or JPEG)
        metadata.contentType = "image/jpeg"
        
        return metadata
    }
    
    private func uploadProfileImage(userId: String, imageData: Data, completion: @escaping (Error?)->()) {
        let profileImageRef = self.storage.reference().child(imagePath(userId: userId))
        
        profileImageRef.putData(imageData, metadata: self.imageMetadata()) { (metadata, error) in
            if metadata == nil {
                completion(NSError(domain: "storage", code: 400, userInfo: ["description": error!.localizedDescription]))
            } else {
                completion(error)
            }
        }
    }
    
    private func listenToUserWithId(userId: String) {
        self.userListener = self.firestore.collection("users").document(userId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                // Iggnoring when the document is empty
                if !document.exists {
                    return
                }

                try? self.user = document.data(as: User.self)
                
                if let user = self.user {
                    self.profileIsLoaded = true

                    self.userProfile = UserProfile(
                        username: user.username,
                        email: user.email,
                        profileImage: user.profileImage
                    )
                }
            }
    }
    
    init(firestore: Firestore, functions: Functions, auth: Auth, storage: Storage) {
        self.firestore = firestore
        self.functions = functions
        self.auth = auth
        self.storage = storage
    }
    
    @Published var profileIsLoaded: Bool = false
    @Published var userProfile: UserProfile = UserProfile(username: "", email: "", profileImage: "")
    
    public func createUser(data: UserData, image: Data?, completion: @escaping (UserCreationError?)->()) {
        let functionData = ["email": data.email, "username": data.username, "password": data.password]
        
        self.functions.httpsCallable("createAccount").call(functionData) { (result, error) in
            if let error = error as NSError? {
                if error.localizedDescription == "email" {
                    completion(UserCreationError.emailExists )
                } else if error.localizedDescription == "username" {
                    completion(UserCreationError.usernameExists)
                } else {
                    completion(UserCreationError.other)
                }
                
                return
            }
            
            guard let uid = result?.data as? String else {
                completion(UserCreationError.other)
                
                return
            }
            
            guard let profileImage = image else {
                completion(nil)
                
                return
            }
            
            // TODO: Think about NOT waiting for the upload to finish
            self.uploadProfileImage(userId: uid, imageData: profileImage) { error in
                completion(error != nil ? UserCreationError.profileImage : nil)
            }
          }
    }
    
    public func editProfileImage(profileImage: Data, completion: @escaping (Error?)->()) {
        guard let currentUser = self.user else {
            completion(ProfileImageError.noUser)
            
            return
        }
        
        self.uploadProfileImage(userId: currentUser.id!, imageData: profileImage) { error in
            completion(error != nil ? ProfileImageError.other : nil)
        }
    }
    
    public func listenToUser() {
        self.profileIsLoaded = false
        
        self.authListener = self.auth.addStateDidChangeListener { (auth, user) in
            self.userListener?.remove()
            
            if let user = user {
                self.listenToUserWithId(userId: user.uid)
            } else {
                self.user = nil
                self.userProfile = UserProfile(username: "", email: "", profileImage: "")
            }
        }
    }
    
    public func stopListeningToUser() {
        if let listener = self.authListener {
            self.auth.removeStateDidChangeListener(listener)
        }
    }
    
    public func changeUsername(newUsername: String, completion: @escaping (Error?) -> Void) {
        let uid: String = (self.user?.id!)!
        
        // For instant update
        self.userProfile.username = newUsername
        
        self.firestore.collection("users")
            .document(uid)
            .updateData([
                "username": newUsername
            ], completion: completion)
    }
    
    public func changePassword(newPassword: String, completion: @escaping (Error?) -> Void) {
        self.auth.currentUser?.updatePassword(to: newPassword, completion: completion)
    }

    // TODO: Change Profile Image
}
