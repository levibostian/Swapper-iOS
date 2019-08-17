#!/usr/bin/env ruby

require 'trent'

ci = Trent.new(:local => true)

ci.sh("./Example/Pods/SwiftFormat/CommandLineTool/swiftformat ./")
ci.sh("echo \"----Remember to commit files that have been formatted-------------\"")
ci.sh("bundle exec jazzy")
ci.sh("git add docs")
