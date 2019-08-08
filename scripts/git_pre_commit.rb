#!/usr/bin/env ruby

require 'trent'

ci = Trent.new(:local => true)

ci.sh("./Example/Pods/SwiftFormat/CommandLineTool/swiftformat ./")
ci.sh("bundle exec jazzy")
ci.sh("git add .")