//
//  CameraView.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 15/6/2023.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    @Binding var selectedTab: Int

    @State private var scannedCode: String?
    @State private var cameraAuthorizationStatus: AVAuthorizationStatus = .notDetermined
    @State private var message = "Scanning QR code"
    
    init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
        self._message = State(initialValue: "Scanning QR code")
        self._scannedCode = State(initialValue: nil)
    }

    var body: some View {
        switch cameraAuthorizationStatus {
        case .authorized:
            VStack {
                ScannerView(scannedCode: $scannedCode)
                    .frame(height: UIScreen.main.bounds.height / 2)
                    .onDisappear {
                        scannedCode = nil // Reset the scannedCode value when the ScannerView disappears
                        message = "Checking QR code"
                    }
                if scannedCode == nil {
                    Text("Scan a QR code to activate the event or checkpoints")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    Text(message)
                        .padding()
                        .onAppear{
                            if let code = scannedCode {
                                FirestoreManager.shared.eventExists(atPath: code) { exists in
                                    if exists {
                                        message = "Activated"
                                        print("Document exists!")
                                    } else {
                                        message = "Invalid Code"
                                        print("Document does not exist!")
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            selectedTab = 2
                                        scannedCode = nil
                                        message = "Checking QR code"
                                        }
                                                                        
                                }
                            } else {
                                message = "No code scanned"
                            }
                        }
                        .onAppear(perform: {
                            if scannedCode == nil {
                                message = "Scanning QR code"
                            }
                        })
                }
            }
        case .notDetermined:
            Text("Requesting camera access...")
                .onAppear {
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        DispatchQueue.main.async {
                            cameraAuthorizationStatus = granted ? .authorized : .denied
                        }
                    }
                }
        case .denied, .restricted:
            Text("Cannot access camera. Please allow camera access in Settings.")
        @unknown default:
            Text("Unknown camera access status.")
        }
    }
}
