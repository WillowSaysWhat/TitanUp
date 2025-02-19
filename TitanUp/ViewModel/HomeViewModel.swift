

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
    private var listener: ListenerRegistration? // real time listener so charts update.
    
    
    init() {
        fetchSessionsRealTime()
    }
    deinit {
        listener?.remove()
    }
    
    func fetchSessionsRealTime() {
            
            listener?.remove() // Remove previous listener if it exists

            listener = db.collection("TitanUpUsers")
                .document(user)
                .collection("DailySessions")
                .order(by: "date", descending: true) // Sort by date (most recent first)
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        print("Error fetching sessions: \(error.localizedDescription)")
                        return
                    }

                    guard let documents = snapshot?.documents else { return }

                    DispatchQueue.main.async {
                        self.sessions = documents.compactMap { doc -> Session? in
                            let data = doc.data()
                            let sessionId = doc.documentID
                            let timestamp = data["date"] as? Timestamp
                            let date = timestamp?.dateValue() ?? Date() // Convert Firestore Timestamp to Date
                            let pushUps = data["pushUps"] as? Int ?? 0
                            
                            
                            return Session(sessionId: sessionId, date: date, pushUps: pushUps)
                        }
                        
                        // ✅ FILTER SESSIONS FOR TODAY, WEEK, AND MONTH
                        self.todaySessions = self.sessions.filter { Calendar.current.isDate($0.date, inSameDayAs: Date()) }
                        self.filterWeekSessions( )
                        self.monthSessions = self.sessions.filter { Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .month) }
                        
                        print("months sessions: \(self.monthSessions.count).")
                    }
                }
        }
    func filterWeekSessions() {
        let calendar = Calendar.current
        let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        
        self.weekSessions = self.sessions.filter { session in
            return session.date >= sevenDaysAgo // ✅ Keeps only last 7 days
        }
    }

    
}

