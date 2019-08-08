import Foundation

/// Errors thrown by Swapper.
public enum SwapperError: Error {
    /// The view you would like to swap to does not exist.
    case viewToSwapToDoesNotExist(viewIndicator: String)
}

extension SwapperError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .viewToSwapToDoesNotExist(let viewIndicator): return "View you want to swap to with indicator of: \(viewIndicator), has not been added."
        }
    }
}
