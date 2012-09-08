require File.expand_path(File.dirname(__FILE__) + '/test_helper')
require 'publisher'

class PublisherTest < Test::Unit::TestCase


	#
	# TESTS
	#
  
  def test_unsubscribe_will_remove_subscription_for_correct_event
    obj = SeveralWays.new
    out = []

    obj.on :eviction do
      out << 'boom'
    end
    obj.on :cry do
      out << 'pow'
    end
    obj.on :employee do
      out << 'kaboom'
    end

    obj.unsubscribe :cry, self

    obj.do_eviction
    obj.do_cry
    obj.do_employee
    assert_equal ['boom','kaboom'], out
  end
  
  def test_unsubsribe_will_raise_if_event_not_valid
		obj = SeveralWays.new
		assert_raise RuntimeError do
			obj.unsubscribe :not_there, self
		end
  end

  def test_unsubscribe_will_not_care_if_no_previous_subscription_was_made
		obj = SeveralWays.new
    obj.unsubscribe :cry, self
  end

  def test_unsubscribe_can_be_called_multiple_times
		obj = SeveralWays.new
    out = []
    obj.on :cry do
      out << 'a'
    end
    obj.unsubscribe :cry, self
    obj.unsubscribe :cry, self
    obj.do_cry
    assert_equal [], out
  end 

  def test_unsubscribe_only_unsubscribes_the_unsubscriber
    something = Something.new
    watcher = SomethingWatcher.new something

    out = [] 
    something.on :boom do
      out << 'boom'
    end
    
    something.do_boom
    assert_equal ['boom'], out
    assert_equal ['boom'], watcher.observations

    something.unsubscribe :boom, watcher
    something.do_boom
    assert_equal ['boom','boom'], out
    assert_equal ['boom'], watcher.observations
  end

  def test_unsubscribe_removes_all_subscriptions_for_the_event_being_listened_for
    something = Something.new
    out = []
    something.on :boom do
      out << 'a'
    end
    something.on :boom do
      out << 'b'
    end
    something.on :boom do
      out << 'c'
    end
    something.do_boom
    assert_equal ['a','b','c'], out
    something.unsubscribe :boom, self
    something.do_boom
    assert_equal ['a','b','c'], out
  end

  def test_unsubscribe_all_unsubscribes_the_unsubscriber_from_all_events
    something = Something.new
    watcher = SomethingWatcher.new something

    out = []
    something.on :boom do
      out << 'a'
    end
    something.on :boom do
      out << 'b'
    end
    something.on :pow do
      out << 'c'
    end

    something.do_boom
    something.do_pow
    assert_equal ['a','b','c'], out
    assert_equal ['boom'], watcher.observations

    something.unsubscribe_all self
    something.do_boom
    something.do_pow
    assert_equal ['a','b','c'], out
    assert_equal ['boom','boom'], watcher.observations
  end

	def test_subscribe_and_fire
		obj = Something.new

		out = []
		obj.subscribe :boom do out << 'boom' end
		obj.do_boom
		assert_equal ['boom'], out

		out = []
		obj.subscribe :pow do out << 'pow' end
		obj.do_pow
		assert_equal ['pow'], out
	end

	def test_alternate_event_declarators
		obj = ManyEvents.new
		[:a, :b, :c, :crunch, :rip, :shred, :rend].each do |event|
			out = nil
			obj.subscribe event do out = event end
			obj.relay(event)
			assert_equal event, out
		end
	end

	def test_alternate_subscribe_and_fire_methods
		obj = SeveralWays.new
		out = nil
		obj.subscribe :employee do out = :employee end
		obj.on :cry do out = :cry end
		obj.when :eviction do out = :eviction end

		out = nil
		obj.do_employee
		assert_equal :employee, out

		out = nil
		obj.do_cry
		assert_equal :cry, out

		out = nil
		obj.do_eviction
		assert_equal :eviction, out
	end

	def test_fire_is_not_public
		obj = Something.new
		err = assert_raise NoMethodError do
			obj.fire :boom
		end
		assert_match(/protected/i, err.message)
	end

	def test_subscribe_for_non_event
		obj = Something.new
		assert_raise RuntimeError  do
			obj.subscribe :not_there
		end

		obj = Nobody.new
		assert_raise NoMethodError do
			obj.subscribe :huh
		end
	end

	def test_fire_non_event
		obj = Broken.new
		assert_raise RuntimeError  do
			obj.go
		end
	end

	def test_fire_with_parameters
		obj = Somebody.new
		out = nil
		obj.on :eat_this do |food|
			out = food
		end
		obj.go "burger"
		assert_equal "burger", out
	end

	def test_fire_when_nobodys_listening
		# Make sure this doesn't explode
		Something.new.do_boom
	end

	def test_parameter_mismatch_between_event_and_handler
		obj = Somebody.new
		out = nil
		obj.on :eat_this do
			out = 'huh'
		end
		obj.go "ignore me"
		assert_equal 'huh', out
	end

	def test_extending_publisher_doesnt_affect_normal_inheritance
		obj = Billy.new('wheel')
		assert_equal 'wheel', obj.chair
		out = nil
		obj.subscribe :weapons do out = 'bang' end

		obj.go
		assert_equal 'bang', out
	end

	def test_has_any_event
		sh = SuperHoss.new
		got = nil
		sh.when :awesome do |data|
			got = data
		end

		sh.go "right on"
		assert_equal "right on", got
	end

	def test_can_fire_anything
		sdh = SuperDuperHoss.new
		got = nil
		sdh.when :really_awesome do |data|
			got = data
		end

		sdh.go "right on"
		assert_equal "right on", got
	end

	def test_multiple_subscriptions_for_same_event
		obj = Somebody.new
		out1 = nil
		out2 = nil
		obj.on :eat_this do |food|
			out1 = food
		end
		obj.on :eat_this do |food|
			out2 = food
		end
		obj.go "burger"
		assert_equal "burger", out1, "First subscription no go"
		assert_equal "burger", out2, "Second subscription no go"
	end

  def test_subclasses_inherit_events
    a = []
    grampa = Grandfather.new
    grampa.on :cannons do
      a <<  "grampa's cannons" 
    end

    dad = Dad.new
    dad.on :cannons do
      a <<  "dad's cannons" 
    end

    dave = Dave.new
    dave.on :cannons do
      a <<  "dave's cannons" 
    end
    dave.on :specific do
      a <<  "dave's specific" 
    end

    grampa.go
    dad.go
    dave.go
    dave.doit

    assert_equal [ 
      "grampa's cannons",
      "dad's cannons",
      "dave's cannons",
      "dave's specific"
    ], a
  end

  def test_subclasses_inherit_wide_open_events
    a = []
    dynamo = Dynamo.new
    dynamo.when :surprise do
      a << "surprise"
    end
    dynamo.go(:surprise)

    son = SonOfDynamo.new
    son.when :hooray do
      a << "hooray"
    end
    son.kick_it(:hooray)

    assert_equal [ "surprise", "hooray" ], a
  end

  def test_new_subscribe_syntax
    @args = nil
    shawn = Shawn.new
    shawn.when :boom, self, :do_it
    shawn.go(:a, :b)
    assert_equal @args, [:a, :b]
  end

  def test_new_unsubscribe_syntax
    @args = nil
    shawn = Shawn.new
    shawn.when :boom, self, :do_it
    shawn.unsubscribe :boom, self
    shawn.go(:a, :b)
    assert_nil @args
  end
 
	#
	# HELPERS
	#

  def do_it(*args)
    @args = args
  end

  class SomethingWatcher
    attr_reader :observations
    def initialize(something)
      @observations = []
      something.on :boom do
        @observations << 'boom'
      end
    end
  end

	class Something
		extend Publisher
		has_events :boom, :pow

		def do_boom
			fire :boom
		end

		def do_pow
			fire :pow
		end
	end

	class ManyEvents
		extend Publisher
		has_events :a, :b, :c
		has_event :crunch
		can_fire :rip
		can_fire :shred, :rend
		def relay(evt_sym)
			fire evt_sym
		end
	end

	class SeveralWays
		extend Publisher
		can_fire :cry, :eviction, :employee

		def do_employee
			fire :employee
		end
		def do_eviction
			notify :eviction
		end
		def do_cry
		  emit :cry
		end 
	end

	class Broken
		extend Publisher
		can_fire :stuff

		def go
			fire :oops
		end
	end

	class Nobody
		extend Publisher
	end

	class Somebody
		extend Publisher
		can_fire :eat_this
		def go(food)
			fire :eat_this, food
		end
	end

	class Grampa
		attr_accessor :chair
		def initialize(ch)
			@chair = ch
		end
	end
	class Billy < Grampa
		extend Publisher
		can_fire :weapons
		def go
			fire :weapons
		end
	end

	class SuperHoss
		extend Publisher
		has_any_event

		def go(arg)
			fire :awesome, arg
		end
	end

	class SuperDuperHoss
		extend Publisher
		can_fire_anything

		def go(arg)
			fire :really_awesome, arg
		end
	end

  class Grandfather 
    extend Publisher
    can_fire :cannons

    def go
      fire :cannons
    end
  end

  class Dad < Grandfather
  end

  class Dave < Dad
    can_fire :specific

    def doit
      fire :specific
    end
  end
  
  class Dynamo
    extend Publisher
    can_fire_anything
    def go(sym)
      fire sym
    end
  end

  class SonOfDynamo < Dynamo
    def kick_it(sym)
      fire sym
    end
  end

  class Shawn
    extend Publisher
    can_fire :boom
    def go(*args)
      fire :boom, *args
    end
  end

end
