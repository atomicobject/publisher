publisher
* http://rubyforge.org/projects/atomicobjectrb/
* http://atomicobjectrb.rubyforge.org/publisher

== DESCRIPTION:
  
publisher is a module for extending a class with event subscription and firing capabilities.  This is helpful for implementing objects that participate in the Observer design pattern.

== FEATURES:
  
* Nice syntax for declaring events that can be subscribed for
* Convenient event firing syntax
* Subscribe / unsubscribe functionality
* Several method name aliases give you the flexibility to make your code more readable (eg, *fire*, *notify*, *emit*)

== SYNOPSIS:

  require 'rubygems'
  require 'publisher'

  class CustomerListHolder
    extend Publisher
    can_fire :customer_added, :list_cleared

    def add_customer(cust)
      (@list ||= []) << cust
      fire :customer_added, cust
    end

    def clear_list
      @list.clear
      fire :list_cleared
    end
  end

  holder = CustomerListHolder.new
  holder.when :customer_added do |cust|
    puts "Customer added! #{cust}"
  end
  holder.when :list_cleared do
    puts "All gone."
  end

  holder.add_customer("Croz")
  holder.add_customer("Matt")
  holder.clear_list

== INSTALL:

* sudo gem install publisher

== LICENSE:

(The MIT License)

Copyright (c) 2007 Atomic Object

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
