//
//  ScannerView.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 24/6/2023.
//
import SwiftUI
import AVFoundation

struct ScannerView: UIViewControllerRepresentable {
    @Binding var scannedCode: String?
    @Environment(\.presentationMode) var presentationMode

    // Coordinator class to handle AVCaptureMetadataOutputObjectsDelegate methods
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {
        var parent: ScannerView

        init(_ parent: ScannerView) {
            self.parent = parent
        }

        // Delegate method to handle metadata output from the capture session
        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            guard let metadataObject = metadataObjects.first else { return }
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            parent.scannedCode = stringValue
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    // Method to create and configure the UIViewController
    func makeUIViewController(context: UIViewControllerRepresentableContext<ScannerView>) -> UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()

        // Get video capture device
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }

        let videoInput: AVCaptureDeviceInput

        do {
            // Create input using video capture device
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return viewController
        }

        // Add input to capture session
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return viewController
        }

        // Create metadata output
        let metadataOutput = AVCaptureMetadataOutput()

        // Add output to capture session
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            // Set metadata output delegate to the Coordinator instance
            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return viewController
        }

        // Create preview layer using the capture session
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill

        // Set preview layer frame to half of the view height
        let viewBounds = viewController.view.bounds
        let previewLayerFrame = CGRect(x: 0, y: 0, width: viewBounds.width, height: viewBounds.height / 2)
        previewLayer.frame = previewLayerFrame

        // Add preview layer to the view's layer
        viewController.view.layer.addSublayer(previewLayer)

        // Start the capture session
        captureSession.startRunning()

        return viewController
    }

    // Method to update the UIViewController
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ScannerView>) {
    }

    // Method to create the Coordinator instance
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
