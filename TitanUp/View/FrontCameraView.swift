import SwiftUI
import QuickPoseCore
import QuickPoseSwiftUI

struct FrontCameraView: View {
    // This is the sdk key for TitanUP
    var quickPose = QuickPose(sdkKey: "01JCN7DDNVYD0V1FJ8QBHG0P4P")
    // This is a QuickPose Object that counts reps using further logic to capture single reps.
    @State var pushupCounter = QuickPoseThresholdCounter()
    
    @State var feedbackText: String? = nil
    @State var overlayImage: UIImage? = nil
    // QuickPose abstracted container to hold the type of pose/exercise.
    @State var feature: QuickPose.Feature = .fitness(.pushUps)
    @State var fontSize: CGFloat = 34
    
    var body: some View {
        ZStack {
//             this initialised the fake camera
            if let url = Bundle.main.url(forResource: "IMG_4149", withExtension: "mov"){
                QuickPoseSimulatedCameraView(useFrontCamera: true, delegate: quickPose, video: url)
            }
            
            // this commented out code is for the actual camera.
            //QuickPoseCameraView(useFrontCamera: true, delegate: quickPose)
            
            // This is the overlay view which appear as lines linking a virtual skeleton.
            QuickPoseOverlayView(overlayImage: $overlayImage)
        }.overlay(alignment: .bottom) {
            //displays pushup count.
            if let feedbackText = feedbackText {
                Text(feedbackText)
                    .font(.system(size: fontSize, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .onAppear { // when that screen appears, the pose detection starts.
            quickPose.start(features: [.fitness(.pushUps)], onFrame: {status, image, features, feedback, landmarks in
                
                // This places the lines on the screen for testing.
			overlayImage = image
                
                // if the features variable is a pushup (pre-defined in QuickPose package.)
                // count the pushup using the QuickPoseThresholdCounter object.
                // then dislpay it by updating the variable linked to the overlay Text().
                if let result = features[feature] {
                    let counterState = pushupCounter.count(result.value)
                    feedbackText = "\(counterState.count) Pushups"
                }else {
                    print("error in count")
                }
                
            })
        }.onDisappear(){
            quickPose.stop()
                
        }
    }
}

            
      

#Preview {
    FrontCameraView()
}

//"01J52X1864AWPT4J282F1JH3P8"
// 01JCN7DDNVYD0V1FJ8QBHG0P4P
