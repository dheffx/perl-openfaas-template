package function::handler;
use strict;
use warnings;

=pod

=h1 handle
    handle a request to the function
    Args:
      request (Mojo::Message::Request)
      context (function::context)
=cut

sub handle {
  my ($request, $context) = @_;

  my $result = {
    message => "Hello Mojo"
  };

  $context->status(200)
          ->succeed($result);
}

1;