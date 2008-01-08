use strict;
use warnings;

use Test::More tests => 3;
use File::Temp;
use Path::Class;

plan skip_all => "ruby required" unless `ruby --version` =~ /^ruby/;

use Config::Pit;

use Data::Dumper;
sub p($) { warn Dumper shift }

my $dir = File::Temp->newdir();
$Config::Pit::directory = dir($dir->dirname);

my $config;

$config = Config::Pit::set("test", data => {
		"foo" => "0100",
});
is($config->{foo}, "0100", "string like octal number (set returned value)");

$config = Config::Pit::get("test");
is($config->{foo}, "0100", "string like octal number (get returned value)");

my $profile = $Config::Pit::directory->file("default.yaml");

my $ruby_res = `ruby -rpathname -ryaml -e 'print YAML.load_file(%($profile))["test"]["foo"]'`;
is($ruby_res, "0100", "ruby yaml");

1;
