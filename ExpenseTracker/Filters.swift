import Foundation
import SwiftUI

enum Filters: String, CaseIterable {
    case lastweek = "Last Week"
    case lastmonth = "Last Month"
}

extension Filters: Identifiable {
    var id: String { rawValue }
}
