package App::Prove::Plugin::ProgressBar;

use Modern::Perl;

=head1 NAME

App::Prove::Plugin::ProgressBar::Formatter - Progress bar for 'prove'

=head1 SYNOPSIS

  prove -PProgressBar t/

=cut

our $VERSION = '0.01';

# XXX looks like a bug in TAP::Harness or in the docs. Can't pass an
# instantiated Formatter to formatter()
my $NUM_TESTS;

sub load {
    my ( $class, $p ) = @_;
    $NUM_TESTS = $p->{app_prove}->_get_tests;
    $p->{app_prove}->formatter('App::Prove::Plugin::ProgressBar::Formatter');
    return 1;
}

{
    package App::Prove::Plugin::ProgressBar::Formatter;
    use Term::ProgressBar;
    use parent 'TAP::Formatter::Console';
    __PACKAGE__->mk_methods(qw[progress curr_prog is_failing]);

    sub new {
        my ( $class, $args ) = @_;
        $args->{verbosity} = -2;
        my $self     = $class->SUPER::new($args);
        my $progress = Term::ProgressBar->new(
            {
                name  => 'Test Programs Run',
                count => $NUM_TESTS,
            }
        );
        $self->progress($progress);
        $self->curr_prog(1);
        $self->_set_colors('green');
        return $self;
    }

    sub open_test {
        my ( $self, $test, $parser ) = @_;
        $parser->callback(
            EOF => sub {
                $self->_set_colors('red') if $self->is_failing;
                $self->progress->update( $self->curr_prog );
                $self->_set_colors('reset');
                $self->curr_prog( $self->curr_prog + 1 );
            }
        );
        $parser->callback(
            test => sub {
                my $test = shift;
                if ( not $test->is_ok ) {
                    print "\r", ( ' ' x $self->progress->term_width );
                    $self->is_failing(1);
                }
            }
        );
        $self->SUPER::open_test( $test, $parser );
    }
}

1;

