package a8bot::Plugin::Powiedz;
use Moose;
use Hash::MultiValue;
with 'a8bot::Plugin';

has 'db' => (
	is	=> 'rw',
	isa	=> 'Hash::MultiValue',
	default	=> sub { Hash::MultiValue->new },
);

sub BUILD {
	my $self = shift;
	$self->keyword('powiedz');
	$self->keyword_cb( sub { active($self, @_) } );
	$self->passive_cb( sub { passive($self, @_) } );
}

sub active {
	my ($self, %data) = @_;
	#number of elements in $data{args} arrayref
	my @args = @{$data{args} // []};
	if ($#args < 1) {
		return "$data{nick}: Usage: powiedz <nick> <wiadomosc>";
	} else {
		$self->db->add($args[0] => [
				$data{nick},
				join(' ', @args[1..$#args]),
				]
		);
		return "$data{nick}: ok, powiem mu jak się pojawi.";
	}
}

sub passive {
	my ($self, %data) = @_;
	if ($self->db->get($data{nick})) {
		my @msgs = $self->db->get_all($data{nick});
		my $resp = '';
		for my $msg (@msgs) {
			if ($resp ne '') {
				$resp .= ' Poza tym, ';
			}
			$resp .= "$msg->[0] kazał Ci powiedzieć: $msg->[1].";
		}
		$self->db->remove($data{nick});
		return "$data{nick}: $resp";
	}
	return undef;
}

__PACKAGE__->meta->make_immutable;

1;
