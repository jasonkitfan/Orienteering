//
//  HomeView.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 15/6/2023.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    @State private var id = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Home tab
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            // Map tab
            MapView()
                .onAppear {
                    print("map appear")
                    id += 1
                }
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map")
                }
                .tag(1)
            
            // Checkpoint tab
            CheckpointView()
                .tabItem {
                    Image(systemName: "mappin.circle.fill")
                    Text("Checkpoint")
                }
                .tag(2)
            
            // Camera tab
            CameraView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "qrcode")
                    Text("QR code")
                }
                .tag(3)
            
            // Support tab
            SupportView()
                .tabItem {
                    Image(systemName: "questionmark.circle.fill")
                    Text("Support")
                }
                .tag(4)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle(Text("Orienteering"))
        .navigationBarTitleDisplayMode(.inline)
        .id(selectedTab)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
