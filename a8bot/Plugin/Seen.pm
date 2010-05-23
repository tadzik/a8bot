package a8bot::Plugin::Seen;
use Moose;
use POSIX 'strftime';
with 'a8bot::Plugin';

has 'log' => (
	is	=> 'rw',
	isa	=> 'HashRef',
	traits	=> [ 'Hash' ],
	handles	=> {
		set_entry => 'set',
		get_entry => 'get',
	},
	default	=> sub { {} },
);

sub BUILD {
	my $self = shift;
	$self->keyword('seen');
	$self->keyword_cb(sub { check($self, @_) });
	$self->passive_cb(sub { store($self, @_) });
}

sub store {
	my ($self, %data) = @_;
	$self->set_entry(
		$data{nick} => [strftime("%x %X", localtime), $data{msg}],
	);
	return undef;
}

sub check {
	my ($self, %data) = @_;
	return unless $data{args};
	my $who = $data{args}->[0];
	my $res = $self->get_entry($who);
	if (defined $res) {
		return "$data{nick}: $who was last seen " .
			"on $res->[0] -- \"$res->[1]\"";
	} else {
		return "$data{nick}: I have not seen $who";
	}
}

__PACKAGE__->meta->make_immutable;

1;
