use Test::More;
eval q{ use Test::Spelling };
plan skip_all => "Test::Spelling is not installed." if $@;
add_stopwords(map { split /[\s\:\-]/ } <DATA>);
$ENV{LANG} = 'C';
# from MacPort
# sudo port install aspell
# sudo port install aspell-dict-en
set_spell_cmd("aspell list");
all_pod_files_spelling_ok('lib');
__DATA__
cho45
rubygems
ppit
