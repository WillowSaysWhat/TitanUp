import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class PoseNetDetectionViewModel: ObservableObject {
    
    // MARK: - Get User ID
    private func getUserId() -> String? {
        if let user = Auth.auth().currentUser {
            return user.uid
        } else {
            print("No user is currently signed in.")
            return nil
        }
    }
    
    // MARK: - Save Session to Firestore
    func saveSessionToFirestore(pushupCount: Int) {
        guard let uid = getUserId(), !uid.isEmpty else {
            print("Cannot save session. User ID is invalid or missing.")
            return
        }
        
        let db = Firestore.firestore()
        
        // Create a new session object
        let newSession = Session(sessionId: UUID().uuidString, date: Date(), pushUps: pushupCount)
        
        // Convert session object to a dictionary, ensuring `date` is stored as a Firestore Timestamp
        let sessionData: [String: Any] = [
            "sessionId": newSession.sessionId,
            "date": Timestamp(date: newSession.date),  // Forces Firestore to store as Timestamp
            "pushUps": newSession.pushUps
        ]
        
        // Reference the "DailySessions" collection for the user
        let userSessionsCollection = db.collection("TitanUpUsers")
            .document(uid)
            .collection("DailySessions")
        
        // Add a new document with auto-generated ID
        userSessionsCollection.addDocument(data: sessionData) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
            } else {
                print("New session document created successfully!")
            }
        }
    }
}
