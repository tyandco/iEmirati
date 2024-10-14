//
//  ContentView.swift
//  iEmirati
//
//  Created by TY on 10/13/24.
//
import SwiftUI
import SwiftData

struct ContentView: View {
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
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View{
        ContentView()
    }
}


