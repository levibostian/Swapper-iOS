require 'trent'

ci = Trent.new(:color => :light_blue)

ci.sh("danger --fail-on-errors=true")
ci.sh("pod lib lint")