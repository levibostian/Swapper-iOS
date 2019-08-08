require 'trent'

ci = Trent.new(:color => :light_blue)

ci.sh("pod trunk push --podspec Swapper.podspec --allow-warnings")