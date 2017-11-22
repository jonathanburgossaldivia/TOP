#!/usr/bin/ruby

require 'socket'
require 'timeout'

iph = ARGV[0]
sum = 0
hilos = []

puts ""
puts "Tool by Jonathan Burgos Saldivia >"
puts ""
for i in 1..1024 do
	hilos << Thread.new(i) do |j|
		begin
			Timeout::timeout(5){TCPSocket.new(iph, j)}
		rescue
			next
		else
			print "[+] Host #{iph} | Open port #{j}\n"
			sum+= 1
		end
	end
end

hilos.each do |t|
	t.join
end

puts ""
puts "[!] Done! | Target: #{iph} | Total open ports: #{sum}."