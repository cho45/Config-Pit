
require "rubygems"
require "rake"

task :default => :test


desc "make test"
task :test => ["Makefile"] do
	sh %{make test}
end

desc "make clean"
task :clean => ["Makefile"] do
	sh %{make clean}
end

desc "make install"
task :install => ["Makefile"] do
	sh %{sudo make install}
end

file "Makefile" => ["Makefile.PL"] do
	sh %{perl Makefile.PL}
end

file "Makefile.PL"
