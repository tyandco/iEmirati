//
//  SplashScreenView.swift
//  iEmirati
//
//  Created by TY on 10/12/24.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        Text("Welcome to")
            .font(.largeTitle.bold())
            .fontWeight(.heavy)
            .animation(.smooth)
        Image("Logo")
            .animation(.smooth)
        Text("iEmirati!")
            .font(.largeTitle.bold().weight(.heavy))
            .animation(.smooth)
            
    }
}

#Preview {
    SplashScreenView()
}
