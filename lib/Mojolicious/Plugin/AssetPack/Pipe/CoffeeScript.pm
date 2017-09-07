package Mojolicious::Plugin::AssetPack::Pipe::CoffeeScript;
use Mojo::Base 'Mojolicious::Plugin::AssetPack::Pipe';
use Mojolicious::Plugin::AssetPack::Util qw(diag $CWD DEBUG);

sub process {
  my ($self, $assets) = @_;

  $assets->each(
    sub {
      my ($asset, $index) = @_;
      return if $asset->processed or $asset->format ne 'coffee';
      $self->run([qw(coffee --compile --stdio)], \$asset->content, \my $js);
      $asset->content($js)->format('js');
    }
  );
}

sub _install_coffee {
  my $self = shift;
  my $path = $self->app->home->rel_file('node_modules/.bin/coffee');
  return $path if -e $path;
  local $CWD = $self->app->home->to_string;
  $self->app->log->warn(
    'Installing coffee-script... Please wait. (npm install coffee-script)');
  $self->run([qw(npm install coffee-script)]);
  return $path;
}

1;

=encoding utf8

=head1 NAME

Mojolicious::Plugin::AssetPack::Pipe::CoffeeScript - Process CoffeeScript

=head1 DESCRIPTION

L<Mojolicious::Plugin::AssetPack::Pipe::CoffeeScript> will process
L<http://coffeescript.org/> files into JavaScript.

This module require the C<coffee> program to be installed. C<coffee> will be
automatically installed using L<https://www.npmjs.com/> unless already
installed.

=head1 METHODS

=head2 process

See L<Mojolicious::Plugin::AssetPack::Pipe/process>.

=head1 SEE ALSO

L<Mojolicious::Plugin::AssetPack>.

=cut
