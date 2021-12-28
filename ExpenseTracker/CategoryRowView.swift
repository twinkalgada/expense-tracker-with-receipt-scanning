import SwiftUI

struct CategoryRowView: View {
    
    let category: Category
    let sum: Float
    
    var body: some View {
        HStack {
            CategoryImageView(category: category)
            Text(category.rawValue.capitalized)
            Spacer()
            Text(sum.formattedCurrencyText).font(.headline)
        }
    }
    
}

