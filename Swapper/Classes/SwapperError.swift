import Foundation

/// Errors thrown by Swapper.
public enum SwapperError: Error {
    /// The view you would like to swap to does not exist.
    case viewToSwapToNotAdded(viewIndicator: String)
    /// The view you would like to swap to no longer exists
    case viewToSwapToNoLongerExists(viewIndicator: String)
}

extension SwapperError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .viewToSwapToNotAdded(let viewIndicator): return "View you want to swap to with indicator of: \(viewIndicator), has not been added."
        case .viewToSwapToNoLongerExists(let viewIndicator): return "View you want to swap to with indicator of: \(viewIndicator), no longer exists. Maybe garbage collected?"
        }
    }
}
