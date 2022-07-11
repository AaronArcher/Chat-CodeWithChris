//
//  ContentView.swift
//  Chat-CodeWithChris
//
//  Created by Aaron Johncock on 11/07/2022.
//

import SwiftUI

struct RootView: View {
    
    @State private var selectedTab: Tabs = .contacts
    
    var body: some View {
        VStack {
            
            Text("Hello, world!")
                .padding()
            
            Spacer()
            
            CustomTabBar(selectedTab: $selectedTab)
            
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
