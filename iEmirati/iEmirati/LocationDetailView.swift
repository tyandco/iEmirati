//
//  LocationDetailView.swift
//  iEmirati
//
//  Created by TY on 28-10-2024.
//

import SwiftUICore
import _MapKit_SwiftUI

struct LocationDetailView: View {
    let location: Location
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Map(coordinateRegion: .constant(
                MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
            ), interactionModes: [.zoom, .pan])
            .frame(height: 300)
            .cornerRadius(10)
            
            Text(location.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(location.description)
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
        }
        .padding()
        .navigationTitle(location.name)
    }
}
