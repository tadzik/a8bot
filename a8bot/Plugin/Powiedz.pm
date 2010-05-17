package a8bot::Plugin::Powiedz;
use strict;
use warnings;

my @db;

sub init {
	return { publicmsg => \&pubmsg };
}

sub pubmsg {
	my ($bot, $data) = @_;
	my $resp;
	if ($data->{msg} =~ /^$bot->{nick},?:? powiedz ([^,: ]+)[:,]? (.+)$/) {
		push @db, "$1: $data->{nick} kazał Ci powiedzieć: $2";
		$resp = "$data->{nick}: ok, powiem mu jak się pojawi";
	}
	my @wanted = grep /^$data->{nick}: /, @db;
	if (@wanted) {
	$resp = join ' ', @wanted;
		@db = grep !/^$data->{nick}: /, @db;
	}
	return $resp;
}

1;
