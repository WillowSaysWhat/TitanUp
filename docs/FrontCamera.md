## Implementing the front CAmera

```swift
import UIKit
import Vision
import SwiftUI
import AVFoundation


class CameraViewModel: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var permissionGranted: Bool = false
    private var pushupCount: Int = 0 // incrementing from the CoreML model.
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private var previewLayer = AVCaptureVideoPreviewLayer()
    var screenRec: CGRect! = nil // view dimensions (portrait)
    
    private var videoOutput = AVCaptureVideoDataOutput()

    // for detector
    var requests = [VNRequest()]
    var pushupCountLayer: CATextLayer!
    var detectionLayer: CALayer! = nil
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkPermission()
        
        sessionQueue.async { [unowned self] in
            guard permissionGranted else { return }
            self.setupCaptureSession()
            
            
            self.captureSession.startRunning()
            
        }
        
        
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        screenRec = UIScreen.main.bounds
        
        switch UIDevice.current.orientation {
        case UIDeviceOrientation.portraitUpsideDown:
            self.previewLayer.connection?.videoOrientation = .portraitUpsideDown
        
        case UIDeviceOrientation.portrait:
            self.previewLayer.connection?.videoOrientation = .portrait
        
        case UIDeviceOrientation.landscapeLeft:
            self.previewLayer.connection?.videoOrientation = .landscapeRight
        
        case UIDeviceOrientation.landscapeRight:
            self.previewLayer.connection?.videoOrientation = .landscapeLeft

        default:
            break
            
        }
        
        // object detector
        

    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permissionGranted = true
        case .notDetermined:
            requestPermission()
        default:
            permissionGranted = false
        }
    }
    
    func requestPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler:  { [unowned self] granted in
            DispatchQueue.main.async {
                self.permissionGranted = granted
                self.sessionQueue.resume()
            }
        })
    }
    
    func setupCaptureSession() {
        // sets the front camera up for capture.
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)
        
        screenRec = UIScreen.main.bounds
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x:0, y:0, width: screenRec.size.width, height: screenRec.size.height)
        // this syntax is depricated - looking for updated syntax.
        previewLayer.connection?.videoOrientation = .portrait
        
        // object detector
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
        
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
        
        
        
        DispatchQueue.main.async { [weak self] in
            self!.view.layer.addSublayer(self!.previewLayer)
        }
    }
}

```
