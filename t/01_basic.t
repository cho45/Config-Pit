use strict;
use warnings;

use Test::More tests => 2;
use File::Temp;

use Config::Pit;

use Data::Dumper;
sub p($) { warn Dumper shift }

my $dir = File::Temp->newdir();
$Config::Pit::directory = $dir->dirname;
p $Config::Pit::directory;

my $config = Config::Pit::get("test");
is(ref($config), "HASH", "get returned value");
is(ref($config->{foo}), "");

#my $config = Config::Pit::get("test", require => {
#	"foo" => "foo test",
#	"bar" => "bar test"
#});
#p $config;
# TODO
