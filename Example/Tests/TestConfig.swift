import Foundation

class TestConfig {
    static let defaultWait: Double = 3.0

    static let defaultAnimationDuration: Double = 0.001 // Set duration super low to make tests go fast, but not 0.0 because then animations will not run which is not accurate to an app running.
}
