//
//  HomeView.swift
//  Orienteering
//
//  Created by Kit Fan Cheung on 15/6/2023.
//

import SwiftUI

struct HomeView: View {
    let events = [
        HomeEvent(title: "Orienteering Competition", date: "Jun 30, 2023", location: "Central Park, New York, NY", imageName: "event1"),
        HomeEvent(title: "Night Orienteering", date: "Jul 15, 2023", location: "Prospect Park, Brooklyn, NY", imageName: "event2"),
        HomeEvent(title: "Orienteering Festival", date: "Aug 20, 2023", location: "Highland Park, Rochester, NY", imageName: "event3")
    ]
    
    let tips = [
        HomeTip(title: "How to use a compass", subtitle: "Learn the basics of compass navigation", imageName: "tip1"),
        HomeTip(title: "Route planning tips", subtitle: "Get better at planning your orienteering route", imageName: "tip2"),
        HomeTip(title: "Navigating in difficult terrain", subtitle: "Improve your navigation skills in challenging terrain", imageName: "tip3")
    ]
    
    let courses = [
        HomeCourse(title: "Beginner Course", duration: "1 hour", distance: "2 km", imageName: "course1"),
        HomeCourse(title: "Intermediate Course", duration: "2 hours", distance: "5 km", imageName: "course2"),
        HomeCourse(title: "Advanced Course", duration: "3 hours", distance: "10 km", imageName: "course3")
    ]
    
    let tools = [
        HomeTool(title: "Orienteering Compass", price: "$29.99", imageName: "tool1"),
        HomeTool(title: "Map Case", price: "$19.99", imageName: "tool2"),
        HomeTool(title: "Orienteering Shoes", price: "$99.99", imageName: "tool3")
    ]
    
    let helpers = [
        HomeHelper(name: "John Doe", imageName: "helper1"),
        HomeHelper(name: "Jane Smith", imageName: "helper2"),
        HomeHelper(name: "David Lee", imageName: "helper3")
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Upcoming Events")
                    .font(.title2)
                    .fontWeight(.bold)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(events, id: \.title) { event in
                            HomeEventCard(event: event)
                        }
                    }
                    .padding(.trailing, 16)
                }
                
                Text("Tips")
                    .font(.title2)
                    .fontWeight(.bold)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(tips, id: \.title) { tip in
                            HomeTipCard(tip: tip)
                        }
                    }
                    .padding(.trailing, 16)
                }
                
                Text("Training Courses")
                    .font(.title2)
                    .fontWeight(.bold)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(courses, id: \.title) { course in
                            HomeCourseCard(course: course)
                        }
                    }
                    .padding(.trailing, 16)
                }
                
                Text("Tools for Sale")
                    .font(.title2)
                    .fontWeight(.bold)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(tools, id: \.title) { tool in
                            HomeToolCard(tool: tool)
                        }
                    }
                    .padding(.trailing, 16)
                }
                
                Text("Helpers")
                    .font(.title2)
                    .fontWeight(.bold)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(helpers, id: \.name) { helper in
                            HomeHelperCard(helper: helper)
                        }
                    }
                    .padding(.trailing, 16)
                }
            }
            .padding()
        }
        .navigationBarTitle("Orienteering App")
    }
}

struct HomeEvent {
    let title: String
    let date: String
    let location: String
    let imageName: String
}

struct HomeTip {
    let title: String
    let subtitle: String
    let imageName: String
}

struct HomeCourse {
    let title: String
    let duration: String
    let distance: String
    let imageName: String
}

struct HomeTool {
    let title: String
    let price: String
    let imageName: String
}

struct HomeHelper {
    let name: String
    let imageName: String
}

struct HomeEventCard: View {
    let event: HomeEvent
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let image = UIImage(named: event.imageName) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 120)
                    .cornerRadius(16)
                    .onAppear {
                        // Do nothing if the image has loaded successfully
                    }
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 200, height: 120)
                    .cornerRadius(16)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(1)
                Text(event.date)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                Text(event.location)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .frame(width: 200, height: 80)
            .padding(.horizontal, 8)
        }
        .frame(width: 200, height: 200)
    }
}

struct HomeTipCard: View {
    let tip: HomeTip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let image = UIImage(named: tip.imageName) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 120)
                    .cornerRadius(16)
                    .onAppear {
                        // Do nothing if the image has loaded successfully
                    }
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 200, height: 120)
                    .cornerRadius(16)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(tip.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(1)
                Text(tip.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
            }
            .frame(width: 200, height: 80)
            .padding(.horizontal, 8)
        }
        .frame(width: 200, height: 200)
    }
}

struct HomeCourseCard: View {
    let course: HomeCourse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let image = UIImage(named: course.imageName) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 120)
                    .cornerRadius(16)
                    .onAppear {
                        // Do nothing if the image has loaded successfully
                    }
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 200, height: 120)
                    .cornerRadius(16)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(course.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(1)
                Text("\(course.duration) • \(course.distance)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .frame(width: 200, height: 80)
            .padding(.horizontal, 8)
        }
        .frame(width: 200, height: 200)
    }
}

struct HomeToolCard: View {
    let tool: HomeTool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let image = UIImage(named: tool.imageName) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 120)
                    .cornerRadius(16)
                    .onAppear {
                        // Do nothing if the image has loaded successfully
                    }
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 200, height: 120)
                    .cornerRadius(16)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(tool.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(1)
                Text(tool.price)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
            }
            .frame(width: 200, height: 80)
            .padding(.horizontal, 8)
        }
        .frame(width: 200, height: 200)
    }
}

struct HomeHelperCard: View {
    let helper: HomeHelper
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let image = UIImage(named: helper.imageName) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .cornerRadius(40)
                    .onAppear {
                        // Do nothing if the image has loaded successfully
                    }
            } else {
                Rectangle()
                    .foregroundColor(.gray)
                    .frame(width: 80, height: 80)
                    .cornerRadius(40)
            }
            
            Text(helper.name)
                .font(.headline)
                .fontWeight(.bold)
        }
        .frame(width: 120)
    }
}
