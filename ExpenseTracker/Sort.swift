import Foundation

enum SortType: String, CaseIterable {
    case date
    case total
}

enum SortOrder: String, CaseIterable {
    case ascending
    case descending
}

extension SortType: Identifiable {
    var id: String { rawValue }
}

extension SortOrder: Identifiable {
    var id: String { rawValue }
}


struct ExpenseLogSort {
    var sortType: SortType
    var sortOrder: SortOrder
    
    var isAscending: Bool {
        sortOrder == .ascending ? true : false
    }
    
    var sortDescriptor: NSSortDescriptor {
        switch sortType {
        case .date:
            return NSSortDescriptor(keyPath: \ExpenseLog.date, ascending: isAscending)
        case .total:
            return NSSortDescriptor(keyPath: \ExpenseLog.total, ascending: isAscending)
        }
    }
}
