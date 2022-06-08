//
//  ContentView.swift
//  BasicFeatures
//
//  Created by Cristian Díaz on 03.06.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Annotations") {
                    AnnotationsView()
                }
                NavigationLink("Clustered Annotations") {
                    ClusteredAnnotationsView()
                }
            }
            .navigationTitle("Basic Map Features")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
