use strict;
use warnings;
use Time::HiRes qw( time sleep );
use SDL;
use SDLx::App;
use SDL::Event;
use SDL::Events;

use SDLx::Controller::Object;
my $app = SDLx::App->new( w => 200, h => 200, title => "timestep" );

#The initial x and y for this object. 
my $spring = SDLx::Controller::Object->new( x => 100, y => 100 );

#we have a constant x velocity of 20
my $constant = SDLx::Controller::Object->new( x => 0, y => 20, v_x => 20 );

#NO need to send an acceleration for x,y or rotation
$constant->set_acceleration( sub { return ( 0, 0, 0 ) } );

#a hooke's law acceleration for the spring
my $accel = sub {
	my ( $t, $state ) = @_;
	my $k  = 10;
	my $b  = 1;
	my $ax = ( ( -1 * $k ) * ( $state->x ) - $b * $state->v_x );
	
	return ( $ax, 0, 0 );
};
$spring->set_acceleration($accel);

#This is how we will render the spring. Notice the x, and y are not tied to how they will show on the screen
my $render = sub {
	my $state = shift;
	$app->draw_rect( [ 100 - $state->x, $state->y, 2, 2 ], 0xFF0FFF );
};

#an event handler to exit
my $event = sub {
	return 0 if $_[0]->type == SDL_QUIT;
	return 1;
};


$app->add_event_handler($event);

#clear the screen
$app->add_show_handler( sub{ $app->draw_rect([0,0,$app->w, $app->h], 0x000000)} );

#add the spring
$app->add_object( $spring, $render );

#add the constant_velocity
$app->add_object(
	$constant,
	sub {
		my $state = shift;
		$app->draw_rect( [ $state->x, $state->y, 4,       4 ],       0xFFFFFF );
	}
);

#add the final update
$app->add_show_handler( sub{ $app->update() } );

$app->run_test();


