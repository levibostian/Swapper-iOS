import Foundation

// Dependnecy injection. Used for testing.
internal class Di { // swiftlint:disable:this type_name
    static var instance: Di = Di()

    var threadUtil: ThreadUtil = SwapperThreadUtil()
}
