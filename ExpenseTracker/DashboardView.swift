import SwiftUI
import CoreData

struct DashboardView: View {
    
    @Environment(\.managedObjectContext)
    var context: NSManagedObjectContext
    
    @State var totalExpenses: Float?
    @State var categoriesSum: [CategorySum]?
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 4) {
                if totalExpenses != nil {
                    Text("Total expenses")
                        .font(.headline)
                    if totalExpenses != nil {
                        Text(totalExpenses!.formattedCurrencyText)
                            .font(.largeTitle)
                    }
                }
            }
            
            if categoriesSum != nil {
                if totalExpenses != nil && totalExpenses! > 0 {
                    PieChartView(
                        data: categoriesSum!.map { ($0.sum, $0.category.color) },
                        style: Styles.pieChartStyleOne,
                        form: CGSize(width: 300, height: 240),
                        dropShadow: false
                    )
                    
                    
                    Divider()
                    
                    List {
                        Text("Breakdown").font(.headline)
                        ForEach(self.categoriesSum!) {
                            CategoryRowView(category: $0.category, sum: Float($0.sum))
                        }
                    }.listStyle(PlainListStyle())
                }
            }
            
            if totalExpenses == nil && categoriesSum == nil {
                Text("No expenses data\nPlease add your expenses from the logs tab")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding(.horizontal)
            }
        }
        .padding(.top)
        .onAppear(perform: fetchTotalSums)
    }
    func fetchTotalSums() {
        ExpenseLog.fetchAllCategoriesTotalAmountSum(context: self.context) { (results) in
            guard !results.isEmpty else {
                self.totalExpenses = nil
                self.categoriesSum = nil
                return
                
            }
            
            let totalSum = results.map { $0.sum }.reduce(0, +)
            self.totalExpenses = Float(totalSum)
            self.categoriesSum = results.map({ (result) -> CategorySum in
                return CategorySum(sum: Float(result.sum), category: result.category)
            })
        }
    }
}

struct CategorySum: Identifiable, Equatable {
    let sum: Float
    let category: Category
    
    var id: String { "\(category)\(sum)" }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
