import SwiftUI
import UserNotifications

struct PreferencesView: View {
    
    @State private var isNotifyOn = false
    @State var hourOfDay: Int = 0
    @State var minuteOfDay: Int = 0
    @State private var wakeUp:Date = Date()
    var calendar = Calendar.current
    
    var body: some View {
        NavigationView {
            VStack {
                Toggle("Notifications", isOn: $isNotifyOn)
                    .onChange(of: isNotifyOn) { value in
                                if(!value){
                                    turnOffReminder()
                                }
                    }
                Text("Turn on and receive daily reminders to log your expenses.")
                if(isNotifyOn) {
                    VStack {
                        DatePicker("Select a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                            .onChange(of: wakeUp, perform: { _ in
                                turnOnReminder()
                            })
                    }.padding()
                }
                Spacer()
            }.padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack {
                            Text("Preferences").font(.headline)
                        }
                    }
                }
            }
    }
    
    func turnOnReminder(){
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]){
                success, error in
                    if success {
                        print("Reminder set!")
                    }else if error != nil {
                        print(error!.localizedDescription)
                        }
                    }
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UIApplication.shared.applicationIconBadgeNumber = 0
        let content = UNMutableNotificationContent()
        content.title = "Reminder to log expenses."
        content.subtitle = "DO NOT forget to log your expenses for today."
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = calendar.component(.hour, from: wakeUp)
        dateComponents.minute = calendar.component(.minute, from: wakeUp)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func turnOffReminder() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

