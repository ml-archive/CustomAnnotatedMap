import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("Annotations") {
                    AnnotationsView()
                }
                NavigationLink("Multi Annotations") {
                    MultiAnnotationsView()
                }
                NavigationLink("Clustered Annotations") {
                    ClusteredAnnotationsView()
                }
                NavigationLink("Multi Clustered Annotations") {
                    MultiClusteredAnnotationsView()
                }
                NavigationLink("User Location") {
                    UserLocationView()
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
