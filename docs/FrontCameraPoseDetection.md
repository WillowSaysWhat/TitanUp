
<h1 style="text-align: center;">Front Camera Pose Detection</h1>

<p align="center">
<img src="/docs/assets/QuickPose.gif"/>
</p>

## NOTE

QuickPose is a paid solution for pose detection. TitanUp uses the Freemium subscription that allows a single SDK Key and 100 users. This could be a problem for solo developers who are building an anti-cheat mechanism. The next tier is $200 a month which could make pose detection in iOS unacheivable for these fitness app developers. 

## Overview

The app records push-up progress by utilising the front camera of an iPhone and an abstracted Python ML package named MediaPipe. This is further abstracted to Swift thanks to [QuickPose.ai](https://quickpose.ai) who ported this capability to ios and provided much of the boilerplate code for the implementation.

This view relies on the QuickPose packages:

* SwiftUI
* QuickPoseCore
* QuickPoseSwiftUI

The core package implements MediaPipe as a method of detecting posture, which QuickPose providing pre-built functionality to detect particular movements and posteures. Some of the provided dectections include:

* Squads
* Situps
* Pushups
* Thumbs up
* planks

The QuickPose SDK is focused on providing a dectection solution to the fitness industry however, further uses are being produced.

The pushup functionality was used in the making of TitanUp, and the QuickPose Object `QuickPoseThresholdCounter()` was used to implement a count feature to the pose detection.

## QuickPoseThresoldCounter()

The QuickPoseThresholdCounter is a utility class within the QuickPose.ai package, specifically designed to help you count repetitions of exercises, like push-ups, using AI-based posture and movement analysis.

### Key Methods and Attributes:

1. __Initialization:__

* QuickPoseThresholdCounter(threshold: Float = 0.5, hysteresis: Float = 0.1): This initializes the counter with a specified threshold value. The threshold is the value at which a movement is considered valid for counting. The hysteresis helps in avoiding noise by providing a range where the state remains unchanged until it crosses the threshold.

* The object a can also be initialized without parameters.
  `@State var pushupCounter = QuickPoseThresholdCounter()`

1. __count(value: Float) -> CounterState:__

* This is the primary method used to pass the AI-detected feature value to the counter. If the value crosses the threshold (for example, when a push-up is completed), it increments the counter. The method returns a CounterState object, which contains the current count and whether the threshold has been entered or exited.
  
1. __CounterState:__

* count: The total number of repetitions counted.
* isEntered: A boolean indicating whether the movement has entered the threshold.

### Example

```swift

 @State var pushupCounter = QuickPoseThresholdCounter()
    
@State var feedbackText: String? = nil
@State var overlayImage: UIImage? = nil
    // QuickPose abstracted container to hold the type of pose/exercise.
@State var feature: QuickPose.Feature = .fitness(.pushUps)

// this is the text overlay that appears at the bottom of the screen.
// It is the pushup counter.
.overlay(alignment: .bottom) {
            //displays pushup count.
            if let feedbackText = feedbackText {
                Text(feedbackText)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundColor(.white)
            }
}

// This inspects the features value from the features key [this is a dictionary] and checks the value is equal to that of feature (QuickPose.Feature = .fitness(.pushUps)

.onAppear { // when that screen appears, the pose detection starts.
            quickPose.start(features: [.fitness(.pushUps)], onFrame: {status, image, features, feedback, landmarks in
                
                // This places the lines on the screen for testing.
                overlayImage = image
                
                // if the features value is a pushup (pre-defined in QuickPose package held in feature)
                // count the pushup using the QuickPoseThresholdCounter object.
                // then dislpay it by updating the variable linked to the overlay Text().
                if let result = features[feature] {
                    let counterState = pushupCounter.count(result.value)
                    feedbackText = "\(counterState.count) Pushups"
                }else {
                    print("error in count")
                }
                
            })
        }

```

### Finally

The QuickPoseThresoldCounter() is mainly used for its sinlge counter functionality. Using an Integer variable can force the use of a bool toggle to prevent couter "run away" where a pause at 90 degrees will cause multiple count iterations. This will lead to a single pushup returning a count of 4 or 5. QuickPose.ai build the threshold counter to prevent package users from having to deal with the complexity of such logic.

## QuickPoseCameraView()

The QuickPoseCameraView class is part of the QuickPose.ai SDK and provides a camera interface specifically designed for real-time pose estimation and tracking in fitness applications. This class simplifies the process of integrating camera functionality with QuickPose's AI features, making it easier to capture video input and apply pose detection algorithms.

In a fitness app, you might use QuickPoseCameraView to guide users through a workout by showing their movements on screen and providing instant feedback on their form. For example, the app could display whether their push-up posture is correct, count repetitions, and give tips for improvement.

### Key Features and Functionality:

1. __Camera Integration:__

* QuickPoseCameraView handles the integration of the camera feed within your app. It provides a live preview of what the camera sees, which is essential for real-time pose detection and feedback.
  
* The camera view is optimized for performance to ensure that pose detection occurs smoothly, even on mobile devices.

2. __Pose Detection and Feedback:__

* This class works closely with QuickPose’s pose detection algorithms. As the camera captures the user’s movements, the view passes this data to the QuickPose engine, which processes it to detect and analyze poses.

* You can configure the QuickPoseCameraView to provide real-time feedback on the user’s posture or exercise form based on the detected poses.

3. __Customization and Styling:__

* The QuickPoseCameraView can be customized to fit the design and user interface of your app. You can overlay additional UI elements, such as guides, counters, or feedback messages, directly on top of the camera view.

* It supports different layouts and orientations, ensuring it can adapt to various device screen sizes and orientations.

4. __Event Handling:__

* The class allows developers to handle different events, such as when a user enters or exits the camera view, when a pose is detected, or when an error occurs.

* These events can trigger specific actions, such as starting a workout session, counting repetitions, or providing corrective feedback.

## Example

```swift
import SwiftUI
import QuickPose

struct WorkoutView: View {
    var body: some View {
        // 
        QuickPoseCameraView()
            .onAppear {
                // Configure the camera view and QuickPose session
                QuickPose.start() // missing code for brevity
            }
            .onDisappear {
                // Clean up when the view is dismissed
                QuickPose.stop()
            }
    }
}

```

### Conclusion

QuickPoseCameraView is a powerful tool in the QuickPose.ai SDK that simplifies the integration of real-time pose detection into mobile applications. It handles camera setup, pose detection, and event management.

## QuickPose()

The `QuickPose` class is the central component of the QuickPose.ai SDK, which is designed to provide real-time pose detection and analysis in iOS applications. This class is responsible for initializing the SDK, managing sessions, and handling pose detection logic.

### Key Aspects of the QuickPose Class

1. SDK Initialization and sdkKey:

* sdkKey: When you use QuickPose in your application, you need to authenticate the SDK with a unique sdkKey. This key is provided by QuickPose when you sign up for their service and is necessary for accessing their AI-powered features. It ensures that your app is authorized to use QuickPose's services.

2. Usage: The sdkKey is typically set during the initial setup of the SDK, either in the app's initialization process or when starting a QuickPose session.

```swift
QuickPose.initialize(sdkKey: "your_sdk_key_here")
// This line would typically be called in your app's startup code, 
// such as in the AppDelegate or SceneDelegate.
```

3. Starting a Session with QuickPose.start():

* The `start()` method of the `QuickPose` class is used to begin a session where pose detection is actively performed. When you call `start()`, the SDK begins processing the camera feed to detect specified features (e.g., push-ups, squats) in real-time.
* Parameters:
    * __features:__ This parameter defines what the SDK should look for. In the provided code example, `.fitness(.pushUps)` specifies that the SDK should detect push-up movements.
    * __onFrame Callback:__ This closure is called every time a new frame is processed by the SDK. It provides several parameters:
        * _status:_ Indicates the current status of the frame processing, such as success or error states.
        * _image:_ The processed frame image that can be overlaid on the screen for visual feedback.
        * _features:_ A dictionary containing detected features and their corresponding values.
        * _feedback:_ Feedback on the user's posture or movement, which can be used to correct form.
        * _landmarks:_ Coordinates of key body parts detected by the AI, which can be used for advanced visualizations or analyses.

```swift

quickPose.start(features: [.fitness(.pushUps)], onFrame: { status, image, features, feedback, landmarks in
    // Display the processed image as an overlay
    overlayImage = image
    
    // Check if the detected feature is a push-up
    if let result = features[.fitness(.pushUps)] {
        // Count the push-up using the QuickPoseThresholdCounter
        let counterState = pushupCounter.count(result.value)
        
        // Update the feedback text with the count
        feedbackText = "\(counterState.count) Pushups"
    } else {
        print("error in count")
    }
})

```

* __Explanation:__
  * _Overlay Image:_ The processed frame image is assigned to overlayImage, which can be displayed in the UI to show what the camera is seeing along with pose detection overlays.
  * _Feature Detection:_ The code checks if the features dictionary contains data for push-ups. If a push-up is detected, the `QuickPoseThresholdCounter` object, `pushupCounter`, counts the movement.
  * _Counting Push-Ups:_ The `count` is updated, and `feedbackText` is set to display the current number of push-ups detected.
  * _Error Handling:_ If the feature isn't found, an error message is printed.

### Summary

* QuickPose manages pose detection sessions, utilizing an sdkKey for authentication.
* `QuickPose.start()` begins real-time detection based on specified features and provides continuous feedback through the onFrame callback.
* This example illustrates how to set up QuickPose to count push-ups, overlay the camera feed, and provide real-time feedback on the number of push-ups performed.
