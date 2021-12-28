import SwiftUI
import CoreData

struct ExpenseListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: ExpenseLog.entity(),
                  sortDescriptors: [
                    NSSortDescriptor(keyPath: \ExpenseLog.date, ascending: false)
                  ])
    
    
    var expenseLogs: FetchedResults<ExpenseLog>
    
    @State var logToEdit: ExpenseLog?
    @State var currItemID: UUID = UUID()
    @State var currItemTitle = ""
    @State var currItemCategory = ""
    @State var currItemTotal: Float = 0
    @State var currItemDate: Date = Date()
    @State var isNavigationBarHidden: Bool = true
    @State var isAddExpense = false
    @State var isReceiptScan = false
    @State var isUpdateExpense = false
    
    init(predicate: NSPredicate?,sortDescriptor: NSSortDescriptor) {
        let fetchRequest = NSFetchRequest<ExpenseLog>(entityName: ExpenseLog.entity().name ?? "ExpenseLog")
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        _expenseLogs = FetchRequest(fetchRequest: fetchRequest)
    }
    
    var body: some View{
        NavigationView {
            if !expenseLogs.isEmpty {
            List {
                ForEach(expenseLogs) { (expense) in
                    Button(action: {
                        self.logToEdit = expense
                    }) {
                        HStack(spacing: 15) {
                            CategoryImageView(category: Category(rawValue: expense.category) ?? .food)
                            VStack(alignment: .leading, spacing: 8) {
                                Text(expense.title).font(.headline)
                                Text("\(expense.dateText)").font(.subheadline)
                            }
                            Spacer()
                            Text("\(expense.total.formattedCurrencyText)").font(.headline)
                        }.padding(.vertical, 4)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        viewContext.delete(expenseLogs[index])
                    }
                    do{
                        try viewContext.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }.listStyle(PlainListStyle())
            .navigationBarTitle("Hidden Title")
                    .navigationBarHidden(self.isNavigationBarHidden)
                    .onAppear {
                        self.isNavigationBarHidden = true
                    }
            .sheet(item: $logToEdit, onDismiss: {
                self.logToEdit = nil
            }) { (expense: ExpenseLog) in
                ExpenseLogView(
                    viewContext : self.viewContext,
                    category : Category(rawValue: expense.category) ?? .food,
                    logToEdit: expense,
                    title : expense.title ,
                    total: expense.total,
                    date: expense.date)
                }
            } else {
                Text("No expenses data found")
                    .font(.headline)
                    .frame(height:250 ,alignment: .top)
            }
        }
    }
}

struct ExpenseListView_Previews: PreviewProvider {
    static var previews: some View {
        let sortDescriptor = ExpenseLogSort(sortType: .date, sortOrder: .descending).sortDescriptor
        ExpenseListView(predicate: nil,sortDescriptor: sortDescriptor)
    }
}
