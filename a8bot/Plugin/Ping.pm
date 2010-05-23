package a8bot::Plugin::Ping;
use Moose;
with 'a8bot::Plugin';

sub BUILD {
	my $self = shift;
	$self->keyword('ping');
	$self->keyword_cb(sub { pubmsg(@_) });
}

sub pubmsg {
	my (%data) = @_;
	return "$data{nick}: pong";
}

__PACKAGE__->meta->make_immutable;

1;
