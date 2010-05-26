#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'App::Prove::Plugin::ProgressBar' );
}

diag( "Testing App::Prove::Plugin::ProgressBar $App::Prove::Plugin::ProgressBar::VERSION, Perl $], $^X" );
