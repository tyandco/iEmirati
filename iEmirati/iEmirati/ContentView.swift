//
//  ContentView.swift
//  iEmirati
//
//  Created by TY on 10/13/24.
//
import SwiftUI
import SwiftData
import UIKit

struct ContentView: View {
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    @State var showSplash = true
    @State var scaleAmount: CGFloat = 0 // Start visible
    @State var logoOpacity: CGFloat = 0 // Start visible
    @State var TabViewOpacity: CGFloat = 0
    @State var isHomeRootScreen = false
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashScreen()
                    .scaleEffect(scaleAmount)   // Apply scaling
                    .opacity(logoOpacity)       // Apply opacity
                    .onAppear {
                        // Delay for splash screen visibility
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // 1 second delay before animation
                            withAnimation(.easeInOut(duration: 1)) {
                                scaleAmount = 1     // Slightly shrink the logo
                                logoOpacity = 1     // Reduce opacity
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    scaleAmount = 0
                                    logoOpacity = 0
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                showSplash = false
                            }
                        }
                    }
            }else {
                TabView {
                    SecondTabView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    
                    FirstTabView()
                        .tabItem {
                            Label("About", systemImage: "questionmark.circle.fill")
                        }
                }
            }
        }
    }
    
    struct SplashScreen: View {
        var body: some View {
            VStack {
                Text("splash1")
                    .font(.system(size: 54, weight: .heavy))
                    .padding()
                
                
                Image("Logo")
                    .resizable()
                    .frame(width: 250, height: 250)
                Text("splash2")
                    .font(.system(size: 54, weight: .heavy))
                    .padding()
            }
            .background(Color(.systemBackground))
            .edgesIgnoringSafeArea(.all)
        }
    }
    struct OnboardingView: View{
        @Binding var shouldShowOnboarding: Bool
        var body: some View {
            TabView{
                PageView(title: "Welcome to iEmirati!", message: "Swipe to learn more >>>", imageName: "figure.wave",
                         showsDismissButton: false,
                         shouldShowOnboarding: $shouldShowOnboarding)
                PageView(title: "This app is in beta", message: "The app isn't complete yet, there's still more to work on!", imageName: "swift",
                         showsDismissButton: false,
                         shouldShowOnboarding: $shouldShowOnboarding)
                PageView(title: "iCloud Sync", message: "That feature is coming soon!", imageName: "icloud.circle",
                         showsDismissButton: true,
                         shouldShowOnboarding: $shouldShowOnboarding)
                
            }
            .tabViewStyle(PageTabViewStyle())
        }
    }
    struct PageView: View{
        let title: String
        let message: String
        let imageName: String
        let showsDismissButton: Bool
        @Binding var shouldShowOnboarding: Bool
        var body: some View{
            VStack{
                Image(systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.accent)
                    .frame(width: 200, alignment: .center)
                    .padding()
                Text(NSLocalizedString(title, comment: "onboarding"))
                    .font(.system(size: 42, weight: .heavy))
                    .multilineTextAlignment(.center)
                    .padding()
                Text(NSLocalizedString(message, comment: "onboarding"))
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(Color(.secondaryLabel))
                    .multilineTextAlignment(.center)
                    .padding()
                if showsDismissButton{
                    Button(action: {
                        shouldShowOnboarding.toggle()                },label:{
                            Text("Get Started")
                                .foregroundColor(Color.white)
                                .frame(width: 200, height: 50, alignment: .center)
                                .fontWeight(.heavy)
                                .background(Color.accent)
                                .cornerRadius(8
                                )                })
                }
                
            }
        }
    }
    struct FirstTabView: View {
        var body: some View {
            AboutMenu()
        }
    }
    
    struct SecondTabView: View {
        var body: some View {
            HomeScreen()
        }
    }
    
    

    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View{
            ContentView()
        }
        
        
    }
}
