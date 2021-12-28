import SwiftUI

struct FilterView: View {
    
    @Binding var selectedFilter: Set<Filters>
    private let filter = Filters.allCases
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(filter) { filter_val in
                    FilterButtonView(
                        filter: filter_val,
                        isSelected: self.selectedFilter.contains(filter_val),
                        onTap: self.onTap
                    )
                    .padding(.leading, filter_val == self.filter.first ? 16 : 0)
                    .padding(.trailing, filter_val == self.filter.last ? 16 : 0)
                }
            }
        }
        .padding(.vertical)
    }
    
    func onTap(filter: Filters) {
        if selectedFilter.contains(filter) {
            selectedFilter.remove(filter)
        } else {
            selectedFilter.removeAll()
            selectedFilter.insert(filter)
        }
    }
}

struct FilterButtonView: View {
    
    var filter: Filters
    var isSelected: Bool
    var onTap: (Filters) -> ()
    
    var body: some View {
        Button(action: {
            self.onTap(self.filter)
        }) {
            HStack(spacing: 8) {
                Text(filter.rawValue.capitalized)
                    .fixedSize(horizontal: true, vertical: true)
                if isSelected {
                    Image(systemName: "xmark.circle.fill")
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(UIColor.lightGray), lineWidth: 1))
                .frame(height: 44)
        }
        .foregroundColor(Color(UIColor.gray))
    }
}

