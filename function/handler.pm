package function::handler;

=pod

=h1 handle
    handle a request to the function
    Args:
        context (str): request context
=cut

sub handle {
    my ($context) = @_;
    return "hello world";
}

1;
