
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

file "Makefile" do
	sh %{perl Makefile.PL}
end
