import SwiftUI
import CoreData

struct LogsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var sortType = SortType.date
    @State private var sortOrder = SortOrder.descending
    @State var isAddExpense: Bool = false
    @State var isReceiptScan: Bool = false
    @State var selectedFilter: Set<Filters> = Set()
    
    @StateObject var expenseToAdd = Expenses()
    @State private var recognizedText = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                FilterView(selectedFilter: $selectedFilter)
                Divider()
                SelectSortOrderView(sortType: $sortType, sortOrder: $sortOrder)
                Divider()
                ExpenseListView(predicate: ExpenseLog.predicate(with: Array(selectedFilter)),sortDescriptor: ExpenseLogSort(sortType: sortType, sortOrder: sortOrder).sortDescriptor)
            }
            .padding(.bottom, 0)
            .navigationTitle("My Expenses")
            .navigationBarItems(
                leading: EditButton(),
                trailing: HStack {
                    Button(action: {
                        isReceiptScan = true
                    }, label: {
                        Image(systemName: "camera")
                            .imageScale(.large)
                    })
                    Button(action: {
                        isAddExpense = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .imageScale(.large)
                    })
                }
            )
            .sheet(isPresented: $isAddExpense, onDismiss: {
                self.isAddExpense = false
                expenseToAdd.item.title = ""
                expenseToAdd.item.total = 0
                expenseToAdd.item.date = Date()
            }){
                ExpenseAddView(
                    viewContext: self.viewContext,
                    title: expenseToAdd.item.title,
                    total: expenseToAdd.item.total,
                    date: expenseToAdd.item.date)
            }
            .sheet(isPresented: $isReceiptScan, onDismiss: parseScannedText){
                ScanReceiptView(recognizedText: self.$recognizedText)
            }
        }
    }
    
    
    func parseScannedText() {
        if(self.recognizedText == "") {
            return
        }
        let text: [String] = self.recognizedText.components(separatedBy: CharacterSet.newlines)
        
        var foundTotal: Bool = false
        var totalString: String = ""
        for (index, line) in text.enumerated() {
            if("total" == line.lowercased() || "debit" == line.lowercased()){
                foundTotal = true
            }
            else if(index == 0) {
                expenseToAdd.item.title = line
            }
            else if(foundTotal) {
                totalString = line
                foundTotal = false
            }
        }
        totalString = totalString.replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal, range: nil)
        expenseToAdd.item.date = Date()
        expenseToAdd.item.total = Float(totalString) ?? 0
        self.recognizedText = ""
        self.isAddExpense = true
        self.isReceiptScan = false
    }
    
    struct ExpenseItem {
        var title: String = ""
        var total: Float = 0
        var date: Date = Date()
    }
    
    class Expenses: ObservableObject {
        @Published var item = ExpenseItem()
    }
    
}

