use inc::Module::Install;
name 'Config-Pit';
all_from 'lib/Config/Pit.pm';

requires 'Path::Class';
requires 'File::Temp' => 0.20;
requires 'YAML';
requires 'File::HomeDir';
requires 'File::Spec';
requires 'List::MoreUtils';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
