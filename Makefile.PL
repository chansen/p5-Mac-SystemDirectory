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
    DEFINE => '-DHAS_BOOL',
);

# fix compilation issues on Darwin: see RT#73539
{
  package MY;
  sub xs_c {
    my $s = shift->SUPER::xs_c(@_);
    $s .= "\n\t\$(MV) \$*.c \$*.m";
    return $s;
  }
  sub c_o {
    my $s = shift->SUPER::c_o(@_);
    $s =~ s/\*\.c/\*.m/g;
    return $s;
  }
  sub xs_o {
    my $s = shift->SUPER::xs_o(@_);
    $s =~ s/\*\.c/\*.m/g;
    return $s;
  }
  sub special_targets {
    my $s = shift->SUPER::special_targets(@_);
    $s =~ s/\.xs \.c/.xs .m .c/;
    return $s;
  }
}
