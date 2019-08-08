require 'trent'

ci = Trent.new(:local => true)

ci.sh("./Example/Pods/SwiftLint/swiftlint --strict")