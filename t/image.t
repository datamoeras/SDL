#!/usr/bin/perl -w
use strict;
use SDL;
use SDL::Config;
use SDL::Version;
use SDL::Image;
use SDL::RWOps;

use Test::More;
use lib 't/lib';
use SDL::TestTool;
if( !SDL::TestTool->init(SDL_INIT_VIDEO) )
{
    plan( skip_all => 'Failed to init video' );
}
elsif( !SDL::Config->has('SDL_image') )
{
    plan( skip_all => 'SDL_image support not compiled' );
}


my @done = qw/
linked_version
init
quit
load_rw
loadtyped_rw
is_PNG
is_BMP
is_GIF
is_JPG
is_LBM
is_PCX
is_PNM 
is_TIF
is_XCF
is_XPM
is_XV
/;

my $lver = SDL::Image::linked_version();

isa_ok($lver, "SDL::Version", '[linked_version] got version back!' );

diag ( 'Found version ('.$lver->major.'.'.$lver->minor.'.'.$lver->patch.')');

isa_ok( SDL::Image::load("test/data/highlight.png"), "SDL::Surface", "[load] Gets Surface"); 

my $file = SDL::RWOps->new_file("test/data/logo.png", "rb");

isa_ok (SDL::Image::load_rw($file, 1), "SDL::Surface", "[load_rw] Gets surface");

my $file2 = SDL::RWOps->new_file("test/data/menu.png", "rb");

isa_ok (SDL::Image::loadtyped_rw($file2, 1, "PNG"), "SDL::Surface", "[loadtyped_rw] Makes surface from png");

my $file3 = SDL::RWOps->new_file("test/data/menu.png", "rb");  
is(SDL::Image::is_PNG($file3), 1 ,"[is_PNG] gets correct value for png file");

is( SDL::Image::is_BMP($file3), 0 ,'[is_BMP] returned correct value');
is( SDL::Image::is_GIF($file3), 0 ,'[is_GIF] returned correct value');
is( SDL::Image::is_JPG($file3), 0 ,'[is_JPG] returned correct value');
is( SDL::Image::is_LBM($file3), 0 ,'[is_LMB] returned correct value');
is( SDL::Image::is_PCX($file3), 0 ,'[is_PCX] returned correct value');
is( SDL::Image::is_PNM($file3), 0 ,'[is_PNM] returned correct value');
is( SDL::Image::is_TIF($file3), 0 ,'[is_TIF] returned correct value');
is( SDL::Image::is_XCF($file3), 0 ,'[is_XCF] returned correct value');
is( SDL::Image::is_XPM($file3), 0 ,'[is_XPM] returned correct value');
is( SDL::Image::is_XV($file3) , 0 ,'[is_XV] returned correct value');



#need to get DEFINES to SDL::Image::Constants;
#IMG_INIT_JPG =?o
# IMG_INIT_JPG = 0x00000001,
# IMG_INIT_PNG = 0x00000002,
# IMG_INIT_TIF = 0x00000004  
SKIP:
{
	skip ' This is only for version >= 1.2.10', 1 unless !( $lver->major == 1 && $lver->minor ==2 &&  $lver->patch < 10);
	is (SDL::Image::init( 0x00000001 ), 0 , '[init] Inited jpg');
#	SDL::Image::quit();
	# 	pass '[quit] we can quit fine';

}


my @left = qw/
get_error
set_error
is_RW
/;
my $why
    = '[Percentage Completion] '
    . int( 100 * ( $#done + 1 ) / ( $#done + $#left + 2 ) )
    . "\% implementation. "
    . ( $#done + 1 ) . " / "
    . ( $#done + $#left + 2 );

TODO:
{
    local $TODO = $why;
    fail "Not Implmented $_" foreach(@left)
    
}
diag $why;

done_testing;