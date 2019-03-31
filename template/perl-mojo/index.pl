use strict;
use warnings;

use Mojolicious::Lite;

use function::handler;

=pod

=head1 app

expose the root endpoint of the function for both GET and POST with pointers to a middleware sub

set the log leve and start the app

=cut

get '/' => \&middleware;
post '/' => \&middleware;

app->log->level( $ENV{log_level} // 'error' );
app->start;


=head2 middleware

  Handler for HTTP requests.
  
  Creates a function context instance,
  parses OpenFaaS HTTP param variables into the query/path,
  then call the function handler with request and context

=cut

sub middleware {
  my $c = shift;
  my $context = function::context->new(\&callback, app->log);

  *callback = sub {
    my ($error, $result) = @_;
    if ($error) {
      print $error;
      $c->render(text => $error, status => 500);
    } else {
      my $format = ref($result) ? 'json' : 'text';
      $c->render($format => $result, status => $context->status);
    }
  };

  my $path = Mojo::Path->new($c->req->env->{Http_Path});
  $c->req->url->path($path);

  my $params = Mojo::Parameters->new($c->req->env->{Http_Query});
  $c->req->url->query($params);
  
  function::handler::handle($c->req, $context);
}

package function::context;

sub new {
  my ($class, $callback, $logger) = @_;
  return bless {
    _status => 200,
    _callback => $callback,
    _logger => $logger
  }, $class;
}

sub status {
  my ($self, $value) = @_;
  if(!$value) {
    return $self->{_status};
  }
  $self->{_status} = $value;
  return $self;
}

sub succeed {
  my ($self, $value) = @_;
  $self->{_callback}->(undef, $value);
}

sub fail {
  my ($self, $value) = @_;
  $self->{_callback}->($value, undef);
}

sub log {
  my $self = shift;
  return $self->{_logger};
}