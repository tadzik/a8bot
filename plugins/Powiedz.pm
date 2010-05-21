package Powiedz;
use strict;
use warnings;
use Hash::MultiValue;

my $db = Hash::MultiValue->new;

sub init {
	return { publicmsg => \&pubmsg };
}

sub pubmsg {
	my ($bot, $data) = @_;
	my $resp = '';
	if ($data->{msg} =~ /^$bot->{nick},?:? powiedz ([^,: ]+)[:,]? (.+)$/) {
		$db->add($1 => [$data->{nick}, $2]);
		$resp = "$data->{nick}: ok, powiem mu jak się pojawi.";
	}
	if ($db->get($data->{nick})) {
		my @msgs = $db->get_all($data->{nick});
		for my $msg (@msgs) {
			if ($resp ne '') {
				$resp .= ' Poza tym, ';
			}
			$resp .= "$msg->[0] kazał Ci powiedzieć: $msg->[1].";
		}
		$db->remove($data->{nick});
	}
	if ($resp ne '') {
		return $resp;
	} else {
		return undef;
	}
}

1;
