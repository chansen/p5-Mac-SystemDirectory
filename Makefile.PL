use strict;
use warnings;

$^O eq 'darwin' or die "OS unsupported\n";

use lib 'inc';
use ExtUtils::MakeMaker::Dist::Zilla::Develop;
use ExtUtils::HasCompiler 0.014 'can_compile_loadable_object';

die "Requires a compiler\n" if not can_compile_loadable_object(quiet => 1);

use Config;

WriteMakefile(
    NAME => 'Mac::SystemDirectory',
    VERSION_FROM => 'lib/Mac/SystemDirectory.pm',
    INSTALLMAN1DIR => 'none',
    INSTALLMAN3DIR => 'none',
    NORECURS => 1,
    LDDLFLAGS => $Config{lddlflags} . ' -lobjc -framework CoreFoundation -framework Foundation',
    DEFINE => '-ObjC -DHAS_BOOL',
);
