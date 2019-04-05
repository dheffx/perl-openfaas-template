use strict;
use warnings;

use Mojolicious::Lite;

use function::handler;

=pod

=head1 mojo function wrapper

forwarded http request received from of-watchdog

=cut

get '/' => \&function::handler::handle;
post '/' => \&function::handler::handle;

app->log->level( $ENV{log_level} // 'error' );
app->start;
