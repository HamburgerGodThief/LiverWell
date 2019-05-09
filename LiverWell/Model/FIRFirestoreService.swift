//
//  FirestoreService.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/5/7.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import Foundation
import Firebase

class FIRFirestoreService {
    
    private init() {}
    static let shared = FIRFirestoreService()
    
    func configure() {
        FirebaseApp.configure()
    }
    
    let today = Date()
    
    private func reference(to collectionReference: FIRCollectionReference) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
//    func firebase(query: (CollectionReference) -> Query) {
//
//        let query = query(Firestore.firestore().collection("users"))
//
//        query.getDocuments(completion: {_,_ in
//
//        })
//    }

    private func userSubReference(to collectionReference: FIRCollectionReference) -> CollectionReference {
        let user = Auth.auth().currentUser
        
        Firestore.firestore().collection("users")
        
        return Firestore.firestore()
            .collection("users").document(user!.uid)
            .collection(collectionReference.rawValue)
    }
    
    func create<T: Encodable>(for encodableObject: T, in collectionReference: FIRCollectionReference) {
        do {
            let json = try encodableObject.toJson()
            reference(to: collectionReference).addDocument(data: json)
        } catch {
            print(error)
        }
    }
    
    func read<T: Decodable>(from collectionReference: FIRCollectionReference, returning objectType: T.Type, completion: @escaping ([T]) -> Void) {
        
        reference(to: collectionReference).addSnapshotListener { (snapshot, _) in

            guard let snapshot = snapshot else { return }

            do {
                var objects = [T]()
                for document in snapshot.documents {
                    let object = try document.decode(as: objectType.self)
                    objects.append(object)
                }

                completion(objects)

            } catch {
                print(error)
            }

        }
        
    }
    
    func readWeekWorkout<T: Decodable>(returning objectType: T.Type, completion: @escaping ([T]) -> Void) {
        
        guard let monday = today.startOfWeek else { return }
        
        userSubReference(to: .workout)
            .whereField("created_time", isGreaterThan: monday)
            .order(by: "created_time", descending: false)
            .getDocuments { (snapshot, error) in
                
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    
                    do {
                        var objects = [T]()
                        for document in snapshot!.documents {
                            let object = try document.decode(as: objectType.self)
                            objects.append(object)

                        }
                        
                        completion(objects)
                        
                    } catch {
                        print(error)
                    }
                
            }
        }
    }
    
    func update<T: Encodable & Identifiable>(for encodableObject: T, in collectionReference: FIRCollectionReference) {
        
        do {
            let json = try encodableObject.toJson()
            guard let id = encodableObject.id else { throw LWError.encodingError }
            reference(to: collectionReference).document(id).setData(json)
            
        } catch {
            print(error)
        }
        
    }
    
    func delete<T: Identifiable>(_ identifiableObject: T, in collectionReference: FIRCollectionReference) {
        
        do {
            guard let id = identifiableObject.id else { throw LWError.encodingError}
            reference(to: collectionReference).document(id).delete()
            
        } catch {
            print(error)
        }
        
    }
    
    func createUser(email: String, password: String, completion: @escaping (User, Error) -> Void) {
        
        Auth.auth().createUser(
            withEmail: email,
            password: password
        )
        
//        completion(User.self, Error.self)
        
    }
}