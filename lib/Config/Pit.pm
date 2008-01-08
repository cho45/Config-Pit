package Config::Pit;

use strict;
use 5.8.1;

use YAML ();
use File::HomeDir;
use File::Spec;
use File::Util;
use File::Temp;
use List::MoreUtils qw(all);

our $VERSION      = '0.01';
our $directory    = File::Spec->catdir(File::HomeDir->my_home, ".pit");
our $config_file  = File::Spec->catfile($directory, "config.yaml");
our $profile_file = undef;

my $futil = File::Util->new;

sub get {
	my ($name, %opts) = @_;
	my $profile = _load();
	if ($opts{require}) {
		unless (all { defined $profile->{$name}->{$_} } keys %{$opts{require}}) {
			# merge
			my %t = (%{$opts{require}}, %{$profile->{$name}});
			# system
			my $f = File::Temp->new(SUFFIX => ".yaml");
			print $f YAML::Dump(\%t);
			close $f;
			my $t = $futil->last_modified($f->filename);
			system $ENV{EDITOR}, $f->filename;
			if ($t == $futil->last_modified($f->filename)) {
				warn "No changes.";
			} else {
				$profile->{name} = set($name, data => YAML::LoadFile($f->filename));
			}
		}
	}
	return $profile->{$name} || {};
}

sub set {
	my ($name, %opts) = @_;
	my $result  = $opts{data} || {};
	my $profile = _load();
	$profile->{$name} = $result;
	YAML::DumpFile($profile_file, $profile);
	return $result;
}

sub switch {
	my ($name, %opts) = @_;
	$profile_file = File::Spec->catfile($directory, "$name.yaml");

	my $config = _config();
	$config->{profile} = $name;
	YAML::DumpFile($config_file, $config);
}


sub _load {
	my $config = _config();
	switch($config->{profile});

	unless (-e $profile_file) {
		YAML::DumpFile($profile_file, {});
	}
	return YAML::LoadFile($profile_file);
}

sub _config {
	$futil->make_dir($directory, 0700, qw/--if-not-exists/);

	my $config = eval { YAML::LoadFile($config_file) } || ({
		profile => "default"
	});
	return $config;
}


1;
__END__

=head1 NAME

Config::Pit - Manage settings

=head1 SYNOPSIS

  use Config::Pit;

  my $config = Config::Pit::get("twitter.com", require => {
    "username" => "your username on twitter",
    "password" => "your password on twitter"
  });
  # if the fields are not set, open setting by $EDITOR
  # with YAML-dumped default values (specified at C<require>).

  # use $config->{username}, $config->{password}

=head1 DESCRIPTION

Config::Pit is account setting management library.
Original library is written in Ruby and published as pit gem with management command.
You can install it by rubygems:

  $ sudo gem install pit
  $ pit set twitter.com
  # open setting of twitter.com with $EDITOR.

=over

=item Config::Pit::get(setting_name, opts)

Get setting named C<setting_name> from current profile.

  my $config = Config::Pit::get("twitter.com");

opts:

=over

=item require

  my $config = Config::Pit::get("twitter.com", require => {
    "username" => "your username on twitter",
    "password" => "your password on twitter"
  });

C<require> specified, module check the required fields all exist in setting.
If not exist, open the setting by $EDITOR with merged setting with current setting.

=back

=back

=head1 AUTHOR

cho45 E<lt>cho45@lowreal.netE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<pit gem|http://lowreal.rubyforge.org/pit/>

=cut
