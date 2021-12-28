import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View{
        TabView {
            DashboardView()
                .tabItem {
                    VStack {
                        Text("Dashboard")
                        Image(systemName: "chart.pie")
                    }
            }
            .tag(0)
            LogsView()
                .tabItem {
                    VStack {
                        Text("Logs")
                        Image(systemName: "list.bullet")
                    }
            }
            .tag(1)
            PreferencesView()
                .tabItem {
                    VStack {
                        Text("Preferences")
                        Image(systemName: "gear")
                    }
            }
            .tag(2)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
