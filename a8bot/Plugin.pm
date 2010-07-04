package a8bot::Plugin;
use feature ':5.10';
use Moose::Role;

has 'bot' => (
	is		=> 'ro',
	isa		=> 'a8bot',
	required	=> 1,
	documentation	=> 'The a8bot object owning the plugins',
);

has 'keyword' => (
	is		=> 'rw',
	isa		=> 'Str',
	documentation	=> 'A specific keyword plugin reacts on',
);

has 'keyword_cb' => (
	is		=> 'rw',
	isa		=> 'CodeRef',
	traits		=> [ 'Code' ],
	handles		=> {
		handle_direct	=> 'execute',
	},
	default		=> sub { sub {} },
);

has 'passive_cb' => (
	is		=> 'rw',
	isa		=> 'CodeRef',
	traits		=> [ 'Code' ],
	handles		=> {
		handle_passive	=> 'execute',
	},
	default		=> sub { sub {} },
);

sub handle_resp {
	my ($self, $channel, $resp) = @_;
	if (ref $resp eq 'ARRAY') {
		$self->bot->send_srv(PRIVMSG => $channel, $_) for (@$resp);
	} elsif (defined $resp and $resp ne '') {
		$self->bot->send_srv(PRIVMSG => $channel, $resp);
	}
}

sub pubmsg_cb {
	my ($self, $params) = @_;
	my ($channel, $nick, $host, $msg);
	($nick, $host) = split(/!/, $params->{prefix});
	($channel, $msg) = @{$params->{params}};
	my %args = (
		nick	=> $nick,
		host	=> $host,
		command	=> $params->{command},
		channel	=> $channel,
		msg	=> $msg,
	);
	$self->handle_resp($channel, $self->handle_passive(%args));
	if ($self->keyword) {
		my $nick = $self->bot->nick;
		my $comm = $self->keyword;
		if ($msg =~ /^$nick:?,? ($comm) ?(.+)?$/) {
			if ($2) {
				my @foo = split / /, $2;
				$args{args} = \@foo;
			}
			$self->handle_resp(
				$channel,
				$self->handle_direct(%args),
			);
		}
	}
}

sub registered_cb {
	my $self = shift;
	return unless $self->can('registered');
	my $resp = $self->registered;
	if (ref $resp eq 'ARRAY') {
		$self->bot->send_srv(@$resp);
	}
}

1;
