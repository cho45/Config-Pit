
require "rubygems"
require "rake"
require "shipit"
require "pathname"

makefilepl = Pathname.new("Makefile.PL")

NAME = makefilepl.read[/name '([^']+)';/, 1]
#VERS = 
#DESCRIPTION =


task :default => :test

desc "make test"
task :test => ["Makefile", "MANIFEST"] do
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

desc "release"
task :release => [:test, :shipit]

Rake::ShipitTask.new do |s|
	ENV["LANG"] = "C"
	s.Step.new {
		# check
		system("svn", "up")
		raise "Any chages remain?\n#{`svn st`}" unless `svn st`.empty?
	}.and {}
	s.Step.new {
		raise "svn2cl.sh is not found" unless system("svn2cl.sh", "--version")
	}.and {
		system("svn2cl.sh --break-before-msg=2 --group-by-day  --include-rev --separate-daylogs")
	}
	s.Step.new {
		system "shipit", "-n"
		print "Check dry-run result and press Any Key to continue (or cancel by Ctrl-C)."
		$stdin.gets
	}.and {
		system "shipit"
	}
end


file "Makefile" => ["Makefile.PL"] do
	sh %{perl Makefile.PL}
end

file "Makefile.PL"

file "MANIFEST" => Dir["**/*"].delete_if {|i| i == "MANIFEST" }  do
	sh %{perl Makefile.PL}
	sh %{make}
	sh %{make manifest}
end
