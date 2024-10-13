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
    @State var scaleAmount: CGFloat = 1
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
                .frame(width: .infinity, height: .infinity)
            }
        }
        .ignoresSafeArea()
        .onAppear{
            //starting tiny
            withAnimation(.easeOut(duration: 1.2)){
                scaleAmount = 0.7
            }
            //zoom in
            withAnimation(.easeInOut(duration: 1).delay(1.2)){
                scaleAmount = 80
            }
            //fade to homescreen
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
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


