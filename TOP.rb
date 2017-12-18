#!/usr/bin/ruby

require 'benchmark'
require 'optparse'
require 'socket'
require 'timeout'

options = {}

OptionParser.new do |opts|
	opts.banner = "\n Usage: ruby TOP.rb [options] [arguments...]"
	opts.separator ""
	opts.version = "0.1"
	opts.on('-s', '--start PORT', 'Port to start the scan, default value is 1.') do |startport|
		options[:startport] = startport;
	end
	opts.on('-e', '--end PORT', 'Port to end the scan, default value is 500.') do |endport|
		options[:endport] = endport;
	end
	opts.on('-t', '--target TARGET', "Target to scan ports, example: 192.168.0.1.\n\n") do |target|
		options[:target] = target;
	end
	begin
		opts.parse!
	rescue OptionParser::ParseError => error
		puts "\n [!] #{error}\n [!] -h or --help to show valid options.\n\n"
		exit 1
	end
end

begin
	host = Socket.ip_address_list[4].ip_address
rescue
	print "\n Connection to the network is required.\n\n"
	exit 1
end

@mi_array = Array.new
@mi_array1 = Array.new
@mi_hash = Hash.new
@n_fin = 124.to_i
@numero_hilo = 1.to_i
@cantidad = 0
@ip = host.split('.')[0..-2]
@iph = "#{@ip[0]}."+"#{@ip[1]}."+"#{@ip[2]}."
@startport = options[:startport].to_i
@startport = 1 if @startport == 0
@inicio = @startport
@endport = options[:endport].to_i
@endport = 500 if @endport == 0
@fin = @inicio + @n_fin
@range = @endport - @startport
@fin  = @range + 1 if @range < 51
@fin2 = @range + @inicio
@target = options[:target]
if @target == nil
	puts "\n [!] -h or --help to show valid options.\n\n"
	exit 1
end

print "\n " + "TOP v0.2 (TCP open port scanner) by Jonathan Burgos Saldivia >\n\n"
print " PORT".ljust(10) +"STATE".ljust(8) +"\n" 

def top
	while @numero_hilo < @range
		(@inicio..@fin).each { |i|
			@mi_array << Thread.new(i) { |i|
				begin
					@numero_hilo += 1
					Timeout::timeout(2){TCPSocket.new(@target, i).close}
				rescue
					next
				else
					@mi_hash [:"#{i}"]  = "UP" if i <= @fin2
				end
			}
		}
		@inicio += @n_fin.to_i
		@fin += @n_fin.to_i
		@mi_array.each { |t| t.join}
		salida = @mi_hash.sort
		@cantidad += @mi_hash.count
		salida.each { |key, value| print " #{key}".ljust(10)+"#{value}".ljust(8) +"\n" }
		@mi_hash.clear
	end
end

tiempo = Benchmark.realtime {top}.round(3)

print "\n Found #{@cantidad} host(s) in #{tiempo} seconds | Range: #{@startport}-#{@endport}.\n\n"