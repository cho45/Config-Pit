use inc::Module::Install;
name 'Config-Pit';
all_from 'lib/Config/Pit.pm';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
