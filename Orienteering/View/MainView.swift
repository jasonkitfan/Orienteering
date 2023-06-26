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
    @State private var isDrawerOpen = false
    
    var body: some View {
        ZStack {
            // Main Content
            TabView(selection: $selectedTab) {
                // Home tab
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)
                    .navigationBarTitle("Orienteering", displayMode: .inline)
                
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
                    .navigationBarTitle("Map", displayMode: .inline)
                
                // Checkpoint tab
                CheckpointView()
                    .tabItem {
                        Image(systemName: "mappin.circle.fill")
                        Text("Checkpoint")
                    }
                    .tag(2)
                    .navigationBarTitle("Checkpoints", displayMode: .inline)
                
                // Camera tab
                CameraView(selectedTab: $selectedTab)
                    .tabItem {
                        Image(systemName: "qrcode")
                        Text("QR code")
                    }
                    .tag(3)
                    .navigationBarTitle("Activate QR code", displayMode: .inline)
                
                // Support tab
                SupportView()
                    .tabItem {
                        Image(systemName: "questionmark.circle.fill")
                        Text("Support")
                    }
                    .tag(4)
                    .navigationBarTitle("Support", displayMode: .inline)
            }
            .navigationBarBackButtonHidden(true)
            .id(selectedTab)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isDrawerOpen.toggle()
                    }, label: {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .foregroundColor(.primary)
                    })
                }
            }
            
            // Drawer
            if isDrawerOpen {
                Color.gray.opacity(0.9)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        isDrawerOpen.toggle()
                    }
                HStack{
                    DrawerView(isOpen: $isDrawerOpen)
                        .frame(maxWidth: 300)
                        .zIndex(1)
                    Spacer()
                }
                
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
