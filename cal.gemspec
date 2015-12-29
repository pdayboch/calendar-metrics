# coding: utf-8
lib = File.expand_path('../lib', _FILE_)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
	spec.name 	= "cal"
	spec.version 	= '1.0'
	spec.authors 	= ["Philip Dayboch"]
	spec.email 	= ["philip245@gmail.com"]
	spec.summary	= %q{Obtain the events from a calendar}
	spec.description = %q{Display the metrics of all the calendar events in the past.}
	spec.homepage 	= "http://domainforproject.com/"
	spec.license 	= "MIT"

	spec.files	= ['lib/cal.rb']
	spec.executables = ['bin/cal']
	spec.test_files = ['tests/test_cal.rb']
	spec.require_paths = ["lib"]
end
