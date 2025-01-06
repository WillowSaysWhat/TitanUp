

//
//
//  TitanUp
//
//  Created by Huw Williams on 04/01/2025.
//
import Foundation
import FirebaseFirestore
import FirebaseAuth

class HomeViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var todaySessions: [Session] = []
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
    func filterSessionsForToday(sessions: [Session]) -> [Session] {
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date()) // Midnight of today
            
            return sessions.filter { session in
                let sessionDate = calendar.startOfDay(for: session.date)
                return sessionDate == today
            
        }
    }
    func filterSessionsFor7Days(sessions: [Session]) -> [Session] {
        let calendar = Calendar.current
        let now = Date()
                
        guard let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: now) else {
            return []
        }
                
        return sessions.filter { session in
            return session.date >= sevenDaysAgo && session.date <= now
        }
    }
}
