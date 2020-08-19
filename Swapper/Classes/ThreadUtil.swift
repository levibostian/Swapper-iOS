import Foundation

internal protocol ThreadUtil {
    var isMain: Bool { get }
    var isBackground: Bool { get }
    func assertIsMain()
}

internal class SwapperThreadUtil: ThreadUtil {
    var isMain: Bool {
        Thread.isMainThread
    }

    var isBackground: Bool {
        !isMain
    }

    func assertIsMain() {
        if !isMain {
            fatalError("You must call this function on the main thread.")
        }
    }
}
