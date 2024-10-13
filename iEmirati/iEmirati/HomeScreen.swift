//
//  ContentView.swift
//  iEmirati
//
//  Created by TY on 10/12/24.
//

import SwiftUI

struct HomeScreen: View {
    @State var inView = false
    @State var textOpacity: CGFloat = 0.0
    var body: some View {
        NavigationStack{
            if inView{
                Text("This is the base app.\n The interface is not ready yet.")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .opacity(1)
                Text("The things being tested are:")
                    .font(.title2.bold())
                    .opacity(1)
                Text("App Icon")
                    .font(.title3.bold())
                    .opacity(1)
                Text("Splash Screen")
                    .font(.title3.bold())
                    .opacity(1)
                Text("Up Next:")
                    .font(.title2.bold())
                    .opacity(1)
                Text("Welcome Screen")
                    .font(.title3.bold())
                    .opacity(1)
            }else{
                Text("This is the base app.\n The interface is not ready yet.")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .opacity(textOpacity)
                Text("The things being tested are:")
                    .font(.title2.bold())
                    .opacity(textOpacity)
                Text("App Icon")
                    .font(.title3.bold())
                    .opacity(textOpacity)
                Text("Splash Screen")
                    .font(.title3.bold())
                    .opacity(textOpacity)
                Text("Up Next:")
                    .font(.title2.bold())
                    .opacity(textOpacity)
                Text("Welcome Screen")
                    .font(.title3.bold())
                    .opacity(textOpacity)
            }
        }
        .onAppear{
            withAnimation(.easeOut(duration: 0.5)){
                textOpacity = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                inView = true
            }
        }
    }
}
struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View{
        HomeScreen()
    }
}
