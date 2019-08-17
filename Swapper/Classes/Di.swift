import Foundation

// Dependnecy injection. Used for testing.
internal class Di {
    static var instance: Di = Di()

    var threadUtil: ThreadUtil = SwapperThreadUtil()
}
