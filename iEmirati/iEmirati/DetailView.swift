//
//  DetailView.swift
//  iEmirati
//
//  Created by TY on 11-11-2024.
//

import SwiftUI
import MapKit

struct DetailView: View {
    var location: Location
    
    var body: some View {
        VStack {
            Map(coordinateRegion: .constant(MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )))
            .frame(height: 300)
            .cornerRadius(15)
            .padding()
            
            Text(location.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            Text(location.description)
                .font(.body)
                .padding()
            
            Spacer()
        }
        .navigationTitle(location.name)
    }
}
