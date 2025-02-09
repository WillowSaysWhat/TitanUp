

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
                        self.weekSessions = self.sessions.filter { Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .weekOfYear) }
                        self.monthSessions = self.sessions.filter { Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .month) }
                        
                        print("months sessions: \(self.monthSessions.count).")
                    }
                }
        }
    

    
    func filterSessionsForToday() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date()) // Midnight of today
        print( "today: \(today)")
        self.todaySessions = sessions.filter { session in
            let sessionDate = calendar.startOfDay(for: session.date)
            print("sessionDate: \(sessionDate)")
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

