

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
    @Published var medalsTrophies =  MedalsAndTrophies()
    @Published var user: String = Auth.auth().currentUser?.uid ?? ""
    private var db = Firestore.firestore()
    private var sessionListener: ListenerRegistration? // real time listener so charts update.
    private var medalListener: ListenerRegistration? // real time listener so medals update.
    
    init() { // populates homepage with session data and medals.
        fetchSessionsRealTime()
        fetchMedalsAndTrophies()
        
    }
    deinit {
        saveMedalsAndTrophies()
        sessionListener?.remove()
        medalListener?.remove()
    }
    
    func fetchSessionsRealTime() {
            
        sessionListener?.remove() // Remove previous listener if it exists

        sessionListener = db.collection("TitanUpUsers")
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
                        
                        // FILTER SESSIONS FOR TODAY, WEEK, AND MONTH
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
            return session.date >= sevenDaysAgo // Keeps only last 7 days
        }
    }
    
    
    
    func saveMedalsAndTrophies() {
        guard !user.isEmpty else {
            print("Error: No valid user ID.")
            return
        }

        let medalsData: [String: Any] = [
            "firstDay": medalsTrophies.firstDay,
            "seventhDay": medalsTrophies.seventhDay,
            "thirtyDay": medalsTrophies.thirtyDay,
            "sixtyDay": medalsTrophies.sixtyDay,
            "ninetyDay": medalsTrophies.ninetyDay,
            "OneFiftyDay": medalsTrophies.OneFiftyDay,
            "twoHundredDay": medalsTrophies.twoHundredDay,
            "threeHundredDay": medalsTrophies.threeHundredDay,
            "threeSixtyFiveDay": medalsTrophies.threeSixtyFiveDay,
            
            "oneSession": medalsTrophies.oneSession,
            "twoSession": medalsTrophies.twoSession,
            "fiveSession": medalsTrophies.fiveSession,
            "eightSession": medalsTrophies.eightSession,
            "tenSession": medalsTrophies.tenSession,
            "fifteenSession": medalsTrophies.fifteenSession,
            "twentySession": medalsTrophies.twentySession,
            "fiftySession": medalsTrophies.fiftySession
        ]

        db.collection("TitanUpUsers")
            .document(user)
            .collection("medals")
            .document("userMedals") // Assume only one medals document per user
            .setData(medalsData, merge: true) { error in
                if let error = error {
                    print("Error saving medals: \(error.localizedDescription)")
                } else {
                    print("Medals successfully saved!")
                }
            }
    }

    func fetchMedalsAndTrophies() {
        medalListener?.remove() // Remove previous listener if it exists

        medalListener = db.collection("TitanUpUsers")
            .document(user)
            .collection("medals") // Assuming there's only ONE document in this collection
            .document("userMedals") // You should have a single document for medals (update as needed)
            .addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    print("Error fetching medals: \(error.localizedDescription)")
                    return
                }
                
                guard let document = documentSnapshot, document.exists else {
                    print("Medals document does not exist.")
                    self.saveMedalsAndTrophies()
                    print("Medals document saved as default")
                   return
                }

                do {
                    // Decode the Firestore document into MedalsAndTrophies
                    let data = document.data()
                    let jsonData = try JSONSerialization.data(withJSONObject: data as Any, options: [])
                    let decodedMedals = try JSONDecoder().decode(MedalsAndTrophies.self, from: jsonData)

                    DispatchQueue.main.async {
                        self.medalsTrophies = decodedMedals // Assign to ViewModel
                        // print("Successfully fetched medals: \(self.medalsTrophies)")
                        
                        self.checkMedal() // checks for medals to be awarded.
                        self.checkTrophies() // checks trophies too.
                    }
                } catch {
                    print("Error decoding medals: \(error.localizedDescription)")
                }
            }
        
    }

    
    // checks medals once a day by executing on todaySession.isEmpty
    private func checkMedal() {
        
        // check whether the previous medal is rewarded before continuing conditionals.
        // checks if it is a new day by finding no sessions for today
        
        // medal 1
        if !medalsTrophies.firstDay { // if bool is false..
            
            print("first day is false")
            if !monthSessions.isEmpty {
                medalsTrophies.firstDay = true
                print("changed to true")
                return
            }
        }
        if !medalsTrophies.seventhDay {
            // find if there are seven days of sessions
            if self.validateMedal(days: 7, thisSessionList: self.weekSessions) {
                // reward medal
                medalsTrophies.seventhDay = true
                return
            }
        }
        if !medalsTrophies.thirtyDay {
            // find if there are 30 days of sessions
            if self.validateMedal(days: 30, thisSessionList: self.monthSessions) {
                // reward medal
                medalsTrophies.thirtyDay = true
                return
            }
        }
        if !medalsTrophies.ninetyDay {
            if self.validateMedal(days: 90, thisSessionList: self.sessions) {
                // reward medal
                medalsTrophies.ninetyDay = true
                return
            }
            
        }
        if !medalsTrophies.OneFiftyDay {
            if self.validateMedal(days: 150, thisSessionList: self.sessions) {
                // reward medal
                medalsTrophies.OneFiftyDay = true
                return
            }
        }
        if !medalsTrophies.twoHundredDay {
            if self.validateMedal(days: 200, thisSessionList: self.sessions) {
                // reward medal
                medalsTrophies.twoHundredDay = true
                return
            }
        }
        if !medalsTrophies.threeHundredDay {
            if self.validateMedal(days: 300, thisSessionList: self.sessions) {
                // reward medal
                medalsTrophies.threeHundredDay = true
                return
            }
        }
        if !medalsTrophies.threeSixtyFiveDay {
            if self.validateMedal(days: 365, thisSessionList: self.sessions) {
                // reward medal
                medalsTrophies.threeSixtyFiveDay = true
                return
            }
        }
    }
    // checks that n days are correct with no missing days.
    private func validateMedal(days: Int, thisSessionList: [Session]) -> Bool {
        let calendar = Calendar.current
            
            // Extract unique days (normalized to midnight)
        let uniqueDays = Set(thisSessionList.map { calendar.startOfDay(for: $0.date) })
            
            // Sort the days in descending order (most recent first)
            let sortedDays = uniqueDays.sorted(by: >)

            // Ensure there are at least 7 unique days
        guard sortedDays.count >= days else { return false }

            // Check if the 7 most recent days form a consecutive sequence
            for i in 0..<(days - 1) {
                
                let expectedPreviousDay = calendar.date(byAdding: .day, value: -1, to: sortedDays[i])!
                if !calendar.isDate(sortedDays[i + 1], inSameDayAs: expectedPreviousDay) {
                    return false // Missing a day in sequence
                }
            }
            
            return true // Passed all checks (7 consecutive days exist)
    }
    
    private func checkTrophies() {
        
        if todaySessions.isEmpty {
            medalsTrophies.oneSession = false
            medalsTrophies.twoSession = false
            medalsTrophies.fiveSession = false
            medalsTrophies.eightSession = false
            medalsTrophies.tenSession = false
            medalsTrophies.fifteenSession = false
            medalsTrophies.twentySession = false
            medalsTrophies.fiftySession = false
            return
        }
        if todaySessions.count == 1 {
            medalsTrophies.oneSession = true
            return
        }
        if todaySessions.count == 2 {
            medalsTrophies.oneSession = true
            medalsTrophies.twoSession = true
            return
        }
        if todaySessions.count == 5 {
            medalsTrophies.oneSession = true
            medalsTrophies.twoSession = true
            medalsTrophies.fiveSession = true
            return
        }
        if todaySessions.count == 8 {
            medalsTrophies.oneSession = true
            medalsTrophies.twoSession = true
            medalsTrophies.fiveSession = true
            medalsTrophies.eightSession = true
            return
        }
        if todaySessions.count == 10 {
            medalsTrophies.oneSession = true
            medalsTrophies.twoSession = true
            medalsTrophies.fiveSession = true
            medalsTrophies.eightSession = true
            medalsTrophies.tenSession = true
            return
        }
        if todaySessions.count == 15 {
            medalsTrophies.oneSession = true
            medalsTrophies.twoSession = true
            medalsTrophies.fiveSession = true
            medalsTrophies.eightSession = true
            medalsTrophies.tenSession = true
            medalsTrophies.fifteenSession = true
            return
        }
        if todaySessions.count == 20 {
            medalsTrophies.oneSession = true
            medalsTrophies.twoSession = true
            medalsTrophies.fiveSession = true
            medalsTrophies.eightSession = true
            medalsTrophies.tenSession = true
            medalsTrophies.twentySession = true
            return
        }
        if todaySessions.count == 50 {
            medalsTrophies.oneSession = true
            medalsTrophies.twoSession = true
            medalsTrophies.fiveSession = true
            medalsTrophies.eightSession = true
            medalsTrophies.tenSession = true
            medalsTrophies.fiftySession = true
        }
        
        return
    }
    
}

