use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name        => 'App::Prove::Plugin::ProgressBar',
    license            => 'perl',
    dist_author        => 'Curtis "Ovid" Poe <ovid@cpan.org>',
    dist_version_from  => 'lib/App/Prove/Plugin/ProgressBar.pm',
    requires           => { 'Term::ProgressBar' => '2.09' },
    build_requires     => { 'Test::More' => 0, },
    add_to_cleanup     => ['App-Prove-Plugin-ProgressBar-*'],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
