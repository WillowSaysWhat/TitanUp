import Foundation
import FirebaseAuth

class ContentViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    @Published var showingNewItemView = false
    @Published var isSheet = false
    
    // Listener for authentication changes
    private var handler: AuthStateDidChangeListenerHandle?
    
    // Indicates if a user is signed in
    public var isSignedIn: Bool {
        !currentUserId.isEmpty
    }
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                if let userId = user?.uid {
                    self?.currentUserId = userId
                    print("User ID: \(userId)")
                } else {
                    self?.currentUserId = ""
                    print("No user is signed in.")
                }
            }
        }
    }
    
    deinit {
        if let handler = handler {
            Auth.auth().removeStateDidChangeListener(handler)
        }
    }
}
