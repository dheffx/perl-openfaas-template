use strict;

use function::handler;

sub main {
    my $ctx = get_stdin();
    my $res = function::handler::handle($ctx);
    if ($res) {
        print($res)
    }
}

sub get_stdin {
    my $str = do { local $/; <STDIN> };
    return $str;
}

main();