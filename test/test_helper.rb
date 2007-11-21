here = File.expand_path(File.dirname(__FILE__))
$: << "#{here}/../lib"
$: << "#{here}/../test"

require 'test/unit'

class Test::Unit::TestCase
	# Prevent duplicate test methods 
	self.instance_eval { alias :old_method_added :method_added }
	def self.method_added(method)
		method = method.to_s
		case method
		when /^test_/
			@_tracked_tests ||= {}
			raise "Duplicate test #{method}" if @_tracked_tests[method]
			@_tracked_tests[method] = true
		end
		old_method_added method
	end
end
