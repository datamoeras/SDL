package SDL::TTF;
use strict;
use warnings;
use vars qw(@ISA @EXPORT @EXPORT_OK);
require Exporter;
require DynaLoader;
use SDL::Constants ':SDL::TTF';
our @ISA = qw(Exporter DynaLoader);

use SDL::Internal::Loader;
internal_load_dlls(__PACKAGE__);

bootstrap SDL::TTF;

use base 'Exporter';
our @EXPORT      = @{ $SDL::Constants::EXPORT_TAGS{'SDL::TTF'} };
our %EXPORT_TAGS = (
	all     => \@EXPORT,
	hinting => $SDL::Constants::EXPORT_TAGS{'SDL::TTF/hinting'},
	style   => $SDL::Constants::EXPORT_TAGS{'SDL::TTF/style'}
);

1;
