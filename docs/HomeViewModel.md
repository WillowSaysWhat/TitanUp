# Home View Model

The home view model fetches `[Session]` data from the Firestore data base and stores it in 4 arrays.

```swift
    @Published var sessions: [Session] = []
    @Published var todaySessions: [Session] = []
    @Published var weekSessions: [Session] = []
    @Published var monthSessions: [Session] = []
```

The filtering is done on the initialisation of the HomeViewModel and is used with the charts on the HomeView. This is done by the `fetchSessionsRealTime()` function. 

The class also fetches the medals and trophies data which is held in an object full of booleans.

```swift
    @Published var medalsTrophies =  MedalsAndTrophies()
```

This is done using the `fetchMedalsAndTrophies()` function.

This is possible thanks to the FirebaseAuth SDK which lets us retieve the user's ID this is the purpose of `user`

```swift
    @Published var user: String = Auth.auth().currentUser?.uid ?? ""
```

a Firestore object is initialised for database calls

```swift
    private var db = Firestore.firestore()
```

two listeners are initialised for updating the chart and medals.

```swift
private var sessionListener: ListenerRegistration? // real time listener so charts update.
    private var medalListener: ListenerRegistration? // real time listener so medals update.
```

## init()

The class fetches the session and medal data on init. This allows the Home View to display sessions and medals

```swift
    init() {
        fetchSessionsRealTime()
        fetchMedalsAndTrophies()
        
    }
```

## Deinit()

Deinitialisation removeds both listeners and saves the medal data.

```swift
    deinit {
        saveMedalsAndTrophies()
        sessionListener?.remove()
        medalListener?.remove()
    }
```

## fetchSessionReaTime()

This function retrieves sessions from the Firestore database and filters them into their arrays.

The function starts by removing the listener ready for another to be made.

it takes the documents from `TitanUpUsers/user/DailySessions` as a snapshot.

This is placed into the `sessions` array.

`todaySessions`, `weekSessions`, and `monthSessions` are all filtered either within this function or a second function is called.