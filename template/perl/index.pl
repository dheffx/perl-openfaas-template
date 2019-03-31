use strict;
use warnings;

use JSON::XS;
use function::handler;

=pod

=h1 main
    Grab STDIN and pass it to the function handler
    If the function handler returns an arrayref or hashref, it is encoded as json
    Returns a string of the function response.
=cut

sub main {
    my $ctx = get_stdin();
    my $result = function::handler::handle($ctx);
    if (ref($result)) {
      print(encode_json($result));
    } else {
      print($result);
    }
}

sub get_stdin {
    my $str = do { local $/; <STDIN> };
    return $str;
}

main();
