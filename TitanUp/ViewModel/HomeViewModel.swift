

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
    @Published var weekSessions: [Session] = []
    @Published var monthSessions: [Session] = []
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
                
                // Update filtered sessions after fetching
                self.filterSessionsForToday()
                self.filterSessionsFor7Days()
                self.filterSessionsFor3Months()
                
                print("Retrieved sessions: \(self.sessions)")
            }
        }
    }
    
    func filterSessionsForToday() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date()) // Midnight of today
        
        self.todaySessions = sessions.filter { session in
            let sessionDate = calendar.startOfDay(for: session.date)
            return sessionDate == today
        }
    }
    
    func filterSessionsFor7Days() {
        let calendar = Calendar.current
        let now = Date()
        
        guard let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: now) else {
            self.weekSessions = [] // Clear the list if the calculation fails
            return
        }
        
        self.weekSessions = sessions.filter { session in
            return session.date >= sevenDaysAgo && session.date <= now
        }
    }
    
    func filterSessionsFor3Months() {
        let calendar = Calendar.current
        let now = Date()
        
        guard let threeMonthsAgo = calendar.date(byAdding: .month, value: -3, to: now) else {
            self.monthSessions = [] // Clear the list if the calculation fails
            return
        }
        
        self.monthSessions = sessions.filter { session in
            return session.date >= threeMonthsAgo && session.date <= now
        }
    }
}

