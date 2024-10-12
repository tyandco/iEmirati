//
//  ContentView.swift
//  iEmirati
//
//  Created by TY on 10/12/24.
//

import SwiftUI
import SwiftData

struct HomeScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        Text("This is the base app.\n The interface is not ready yet.")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .multilineTextAlignment(.center)
        Text("The things being tested are:")
            .font(.title2.bold())
        Text("App Icon")
            .font(.title3.bold())
        Text("Splash Screen")
            .font(.title3.bold())
    }
}

#Preview {
    HomeScreen()
        .modelContainer(for: Item.self, inMemory: true)
}
