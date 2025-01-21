//
//  ContentView.swift
//  iEmirati
//
//  Created by TY on 10/13/24.
//
import SwiftUI
import SwiftData
import UIKit

extension UIImage {
    func dominantColor() -> UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x,
                                    y: inputImage.extent.origin.y,
                                    z: inputImage.extent.size.width,
                                    w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [
            kCIInputImageKey: inputImage,
            kCIInputExtentKey: extentVector
        ]) else { return nil }

        guard let outputImage = filter.outputImage else { return nil }
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255.0,
                       green: CGFloat(bitmap[1]) / 255.0,
                       blue: CGFloat(bitmap[2]) / 255.0,
                       alpha: CGFloat(bitmap[3]) / 255.0)
    }
}
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
            Image(imageName) // Load image from assets
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250) // Adjust size as needed
                .padding()
                .onAppear {
                    updateButtonColor()
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
                        .frame(width: 200, height: 50)
                        .fontWeight(.heavy)
                        .background(buttonColor)
                        .cornerRadius(8)
                }
                .padding()
                .animation(.easeInOut(duration: 0.5), value: buttonColor) // Animate button color change
            }
        }
    }

    private func updateButtonColor() {
        if let uiImage = UIImage(named: imageName),
           let dominantUIColor = uiImage.dominantColor() {
            let newColor = Color(dominantUIColor)
            withAnimation(.easeInOut(duration: 0.5)) {
                buttonColor = newColor // Smooth transition
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

