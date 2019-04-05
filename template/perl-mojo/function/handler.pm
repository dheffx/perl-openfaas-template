package function::handler;
use strict;
use warnings;

sub handle {
  my ($c) = @_;
  $c->render(json => { message => "Hello Mojo" }, status => 200);
}

1;
