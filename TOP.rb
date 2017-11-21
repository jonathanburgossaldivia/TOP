#!/usr/bin/ruby
require 'optparse'
require 'socket'
require 'timeout'

ips = ARGV[0]
sum = 0
hilos = []

puts ""
puts "Tool by Jonathan Burgos Saldivia >"
puts ""
for i in 1..1024 do
	hilos << Thread.new(i) do |j|
		begin
			Timeout::timeout(3){TCPSocket.new(ips, j)}
		rescue => ex
			
		else
		puts "[+] Host #{ips} | Open port #{j}"
		sum+= 1
		end
	end
end

hilos.each do |t|
	t.join
end
puts ""
puts "[!] Done! | Target: #{ips} | Total open ports: #{sum}."