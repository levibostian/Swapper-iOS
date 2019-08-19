import Foundation

internal protocol ThreadUtil {
    var isMain: Bool { get }
    var isBackground: Bool { get }
    func assertIsMain()
}

internal class SwapperThreadUtil: ThreadUtil {
    var isMain: Bool {
        return Thread.isMainThread
    }

    var isBackground: Bool {
        return !isMain
    }

    func assertIsMain() {
        if !isMain {
            fatalError("You must call this function on the main thread.")
        }
    }
}
