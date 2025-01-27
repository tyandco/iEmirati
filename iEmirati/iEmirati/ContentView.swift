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
    @State private var showSplash = true
    @State private var scaleAmount: CGFloat = 0 // For splash screen animation
    @State private var logoOpacity: CGFloat = 0 // For splash screen animation
    @State private var onboardingOpacity: Double = 0 // For onboarding fade-in
    @State private var tabViewOpacity: Double = 0 // For TabView fade-in

    var body: some View {
        ZStack {
            if showSplash {
                SplashScreen()
                    .scaleEffect(scaleAmount)   // Apply scaling
                    .opacity(logoOpacity)       // Apply opacity
                    .onAppear {
                        // Delay for splash screen visibility
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
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
                                if shouldShowOnboarding {
                                    withAnimation(.easeInOut(duration: 1)) {
                                        onboardingOpacity = 1
                                    }
                                }
                            }
                        }
                    }
            } else if shouldShowOnboarding {
                OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
                    .opacity(onboardingOpacity)
                    .onDisappear {
                        // Trigger TabView fade-in when onboarding is completed
                        withAnimation(.easeInOut(duration: 1)) {
                            tabViewOpacity = 1
                        }
                    }
            } else {
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
                .opacity(tabViewOpacity) // Apply opacity to TabView
                .onAppear {
                    // Ensure TabView starts at full opacity if already shown
                    if tabViewOpacity == 0 {
                        withAnimation(.easeInOut(duration: 1)) {
                            tabViewOpacity = 1
                        }
                    }
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
struct OnboardingView: View {
    @Binding var shouldShowOnboarding: Bool
    @State private var currentPage = 0 // Track the current page

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                PageView(
                    title: "Welcome to iEmirati!",
                    message: "Swipe to learn more >>>",
                    imageName: "Logo",
                    showsDismissButton: false,
                    shouldShowOnboarding: $shouldShowOnboarding
                )
                .tag(0)
                
                PageView(
                    title: "This app is in beta",
                    message: "The app isn't complete yet, there's still more to work on!",
                    imageName: "Xcode",
                    showsDismissButton: false,
                    shouldShowOnboarding: $shouldShowOnboarding
                )
                .tag(1)
                
                PageView(
                    title: "onboardingremind",
                    message: "eoe",
                    imageName: "Progreset",
                    showsDismissButton: false,
                    shouldShowOnboarding: $shouldShowOnboarding
                )
                .tag(2)
                
                PageView(
                    title: "iCloud Sync",
                    message: "That feature is coming soon!",
                    imageName: "iCloud",
                    showsDismissButton: true,
                    shouldShowOnboarding: $shouldShowOnboarding
                )
                .tag(3)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always)) // Native dots
            
            Spacer()
        }
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.systemBrown // Active dot color
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.secondarySystemFill // Inactive dots color
        }
    }
}
struct PageView: View {
    let title: String
    let message: String
    let imageName: String
    let showsDismissButton: Bool
    @Binding var shouldShowOnboarding: Bool
    @State private var buttonColor: Color = .accentColor // Default button color

    var body: some View {
        VStack {
            ZStack {
                            // Blurred frame
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 250)
                                .blur(radius: 10)

                                .opacity(1)
                            
                            // Main image
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 250)
                        }

            Text(NSLocalizedString(title, comment: "onboarding"))
                .font(.system(size: 42, weight: .heavy))
                .multilineTextAlignment(.center)
                .padding()

            Text(NSLocalizedString(message, comment: "onboarding"))
                .font(.system(size: 24, weight: .regular))
                .foregroundColor(Color(.secondaryLabel))
                .multilineTextAlignment(.center)
                .padding()

            if showsDismissButton {
                Button(action: {
                    shouldShowOnboarding.toggle()
                }) {
                    Text("Get Started")
                        .foregroundColor(.white)
                        .frame(width: 135, height: 50)
                        .fontWeight(.bold)
                        .background(Color.accentColor)
                        .cornerRadius(23)
                }
                .padding()// Animate button color change
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

