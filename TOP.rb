#!/usr/bin/ruby

require 'optparse'
require 'socket'
require 'timeout'

options = {}
sum = 0
hilos = []

OptionParser.new do |opts|
	puts ""
	opts.banner += " [arguments...]"
	opts.separator ""
	opts.version = "0.1"
	opts.on('-t', '--target TARGET', 'Objective to scan, example: 192.168.0.1.') do |target|
		options[:target] = target;
	end
	opts.on('-r', '--range RANGE', 'Range of ports, example: 80.') do |range|
		options[:range] = range;
	end
	begin
		opts.parse!
	rescue OptionParser::ParseError => error
		$stderr.puts error
		$stderr.puts "[!] -h or --help to show valid options."
		exit 1
	end
end

if options[:target] == nil
	$stderr.puts "[!] -h or --help to show valid options."
	exit 1
end

range = options[:range].to_i

if range.to_s.empty?
	range  = 80
end

puts "Tool by Jonathan Burgos Saldivia >"
puts ""
for i in 1..range do
	hilos << Thread.new(i) do |j|
		begin
			Timeout::timeout(5){TCPSocket.new(options[:target], j)}
		rescue
			next
		else
			print "[+] Host #{options[:target]} | Open port #{j}\n"
			sum+= 1
		end
	end
end

hilos.each do |t|
	t.join
end

puts ""
puts "[!] Done! | Target: #{options[:target]} | Total open ports: #{sum}."
