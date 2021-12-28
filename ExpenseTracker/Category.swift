import Foundation
import SwiftUI

enum Category: String, CaseIterable {
    
    case food
    case entertainment
    case health
    case shopping
    case transportation
    case utilities
    case other
    
    var systemNameIcon: String {
        switch self {
            case .food: return "leaf.fill"
            case .entertainment: return "play.tv.fill"
            case .health: return "cross.case.fill"
            case .shopping: return "cart.fill"
            case .transportation: return "car"
            case .utilities: return "bolt.fill"
            case .other: return "tag.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .food: return Color(#colorLiteral(red: 0.298039215686275, green: 0.780392156862745, blue: 0.298039215686275, alpha: 1))
        case .entertainment: return Color(#colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1))
        case .health: return Color(#colorLiteral(red: 0.2, green: 0.6, blue: 1, alpha: 1))
        case .shopping: return Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))
        case .transportation: return Color(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1))
        case .utilities: return Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
        case .other: return Color(#colorLiteral(red: 1, green: 0.6, blue: 0.6, alpha: 1))
        }
    }
}

extension Category: Identifiable {
    var id: String { rawValue }
}
