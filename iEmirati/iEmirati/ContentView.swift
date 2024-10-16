//
//  ContentView.swift
//  iEmirati
//
//  Created by TY on 10/13/24.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    @AppStorage("shouldShowOnboarding") var shouldShowOnboarding: Bool = true
    @State var isHomeRootScreen = false
    @State var scaleAmount: CGFloat = 0
    @State var LogoOpacity: CGFloat = 0
    var body: some View {
        ZStack{
            Color("bg_color")
            if isHomeRootScreen{
                HomeScreen()
                    .modelContainer(for: Item.self, inMemory: true)
            }else{
                Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scaleAmount)
                .opacity(LogoOpacity)
                .frame(width: .infinity, height: .infinity)
            }
        }
        .ignoresSafeArea()
        .onAppear{
            //starting tiny
            withAnimation(.easeInOut(duration: 2)){
                scaleAmount = 0.7
                LogoOpacity = 1
            }
            //zoom in
            withAnimation(.easeOut(duration: 0.4).delay(3)){
                scaleAmount = 0
                LogoOpacity = 0
            }
            //fade to homescreen
            DispatchQueue.main.asyncAfter(deadline: .now() + 4){
                isHomeRootScreen = true
            }
        }
        .fullScreenCover(isPresented: $shouldShowOnboarding) {
            OnboardingView(shouldShowOnboarding: $shouldShowOnboarding)
        }
    }
}
struct OnboardingView: View{
    @Binding var shouldShowOnboarding: Bool
    var body: some View {
        TabView{
            PageView(title: "Welcome to iEmirati!", message: "Swipe to learn more >>>", imageName: "figure.wave",
                     showsDismissButton: false,
                     shouldShowOnboarding: $shouldShowOnboarding)
                .background(Color.bg)
            PageView(title: "This app is in beta", message: "The app isn't complete yet, there's still more to work on!", imageName: "swift",
                     showsDismissButton: false,
                     shouldShowOnboarding: $shouldShowOnboarding)
                .background(Color.bg)
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
            Text(title)
                .font(.system(size: 42, weight: .heavy))
                .multilineTextAlignment(.center)
                .padding()
            Text(message)
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
struct ContentView_Previews: PreviewProvider {
    static var previews: some View{
        ContentView()
    }
}


