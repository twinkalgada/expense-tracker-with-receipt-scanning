import SwiftUI
import CoreData

struct ExpenseAddView: View {
    
    var viewContext: NSManagedObjectContext
    
    @Environment (\.presentationMode) var presentationMode
    
    @State var category: Category = .other
    
    var logToEdit: ExpenseLog?
    
    var viewTitle: String {
        logToEdit == nil ? "Create Expense Log" : "Edit Expense Log"
    }
    
    @State var title: String = ""
    @State var total:Float = 0
    @State var date:Date = Date()
      
    var body: some View {
          NavigationView {
              Form {
                  Section {
                      TextField("Title", text: $title)
                  }
                  Section {
                      Picker(selection: $category, label: Text("Category")) {
                          ForEach(Category.allCases) { category in
                              Text(category.rawValue.capitalized).tag(category)
                          }
                      }
                  }
                  Section {
                      TextField("Total", value: $total, formatter: Utility.numberFormatter)
                          .keyboardType(.decimalPad)
                  }
                  Section {
                      DatePicker(selection: $date, displayedComponents: .date){
                          Text("Date")
                      }
                  }
              }
              .navigationBarItems(
                leading: Button(action: self.onCancel) {
                    Text("Cancel")
                },
                trailing: Button(action: self.onSave) {
                    Text("Save")
                }.disabled(self.title.isEmpty || self.total<=0)
              ).navigationBarTitle(viewTitle)
          }
      }
    
    private func onCancel() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func onSave(){
        let logData: ExpenseLog
        if let expenseLog = self.logToEdit {
            logData = expenseLog
        }else {
            logData = ExpenseLog(context: self.viewContext)
            logData.id = UUID()
        }
        logData.title = self.title
        logData.category = (self.category).rawValue
        logData.total = self.total
        logData.date = self.date
        do {
            try viewContext.save()
        }catch let error as NSError {
            print(error.localizedDescription)
        }
        self.presentationMode.wrappedValue.dismiss()
    }
    
}

