import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirestoreQueryViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var user: String = Auth.auth().currentUser?.uid ?? ""
    
    private var db = Firestore.firestore()
    
    init() {
        fetchSessions()
    }
    
    func fetchSessions() {
        guard !user.isEmpty else {
            print("User ID is empty.")
            return
        }
        
        db.collection("TitanUpUsers").document(user).collection("DailySessions").getDocuments { snapshot, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching sessions: \(error.localizedDescription)")
                    return
                }
                
                self.sessions = snapshot?.documents.compactMap { document -> Session? in
                    let data = document.data()
                    let sessionId = document.documentID
                    let date = (data["date"] as? Timestamp)?.dateValue() ?? Date()
                    let pushUps = data["pushUps"] as? Int ?? 0
                    return Session(sessionId: sessionId, date: date, pushUps: pushUps)
                } ?? []
                
                print("Retrieved sessions: \(self.sessions)")
            }
        }
    }
}

import SwiftUI

struct FirestoreQueryTesting: View {
    @StateObject private var viewModel = FirestoreQueryViewModel()
    
    var body: some View {
        VStack {
            if viewModel.sessions.isEmpty {
                Text("No sessions")
                Text("User: \(viewModel.user)")
            } else {
                List(viewModel.sessions) { session in
                    VStack(alignment: .leading) {
                        Text("Session ID: \(session.id)")
                        Text("Date: \(session.date.formatted(date: .abbreviated, time: .shortened))")
                        Text("Push-ups: \(session.pushUps)")
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchSessions()
        }
    }
}

#Preview {
    FirestoreQueryTesting()
}

