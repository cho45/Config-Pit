use strict;
use warnings;

use Test::More tests => 8;
use File::Temp;
use Path::Class;

use Config::Pit;

use Data::Dumper;
sub p($) { warn Dumper shift }

my $dir = File::Temp->newdir();
$Config::Pit::directory = dir($dir->dirname);

my $config;

$config = Config::Pit::get("test");
is(ref($config), "HASH", "get returned value");
is(ref($config->{foo}), "");

$config = Config::Pit::set("test", data => {
		"foo" => "bar",
		"bar" => "baz",
});
is($config->{foo}, "bar", "set returned value");
is($config->{bar}, "baz", "set returned value");

$config = Config::Pit::get("test");
is($config->{foo}, "bar", "get returned value (after set)");
is($config->{bar}, "baz", "get returned value (after set)");

$config = pit_get("test");
is($config->{foo}, "bar", "get returned value (exported sub)");
is($config->{bar}, "baz", "get returned value (exported sub)");

#my $config = Config::Pit::get("test", require => {
#	"foo" => "foo test",
#	"bar" => "bar test"
#});
#p $config;
# TODO
