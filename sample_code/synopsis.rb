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

