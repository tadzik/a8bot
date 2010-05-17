package a8bot::Plugin;
use feature ':5.12';
use Moose;
use Data::Dumper;

has 'bot' => (
	is		=> 'ro',
	isa		=> 'a8bot',
	required	=> 1,
	documentation	=> 'The a8bot object owning the plugins',
);

# The actual module being handled
has 'plugin' => (
	is		=> 'ro', # why rw?
	required	=> 1,
	documentation	=> 'The module which is being handled',
);

# this keeps whether the plugin reacts on certain types
# of AE::IRC::Client events
has '_disconnect' => (
	is	=> 'rw',
	isa	=> 'CodeRef',
	traits	=> [ 'Code' ],
	handles	=> {
		call_disconnect => 'execute',
	},
);

has '_publicmsg' => (
	is	=> 'rw',
	isa	=> 'CodeRef',
	traits	=> [ 'Code' ],
	handles	=> {
		call_publicmsg	=> 'execute',
	},
);

has '_registered' => (
	is	=> 'rw',
	isa	=> 'CodeRef',
	traits	=> [ 'Code' ],
	handles	=> {
		call_registered => 'execute',
	},
);

sub BUILD {
	my $self = shift;
	my $events = $self->plugin->init;
	$self->_disconnect($events->{disconnect} // sub {});
	$self->_publicmsg($events->{publicmsg} // sub {});
	$self->_registered($events->{registered} // sub {});
}

sub publicmsg {
	my ($self, $channel, $params) = @_;
	my ($nick, $host, $msg);
	($nick, $host) = split(/!/, $params->{prefix});
	(undef, $msg) = @{$params->{params}};
	# TODO: Maybe just params itself,
	# as an additional arg, just in case
	my $resp = $self->call_publicmsg(
		{
			nick	=> $self->bot->nick,
		},
		{
			nick	=> $nick,
			host	=> $host,
			command	=> $params->{command},
			channel	=> $channel,
			msg	=> $msg,
		},
	);
	if (ref $resp eq 'ARRAY') {
		$self->bot->send_srv(@$resp);
	} elsif (defined $resp) {
		$self->bot->send_srv(PRIVMSG => $channel, $resp);
	}
}

sub registered {
#	my $self = shift;
#	my $resp = $self->call_registered({ nick => $self->bot->{nick} });
#	if (ref $resp eq 'ARRAY') {
#		$self->bot->send_srv(@$resp);
#	}
}

__PACKAGE__->meta->make_immutable;

1;

__END__
sub _mode {
	my ($self, @args) = @_;
	$self->send_srv(MODE => @args);
}

sub _privmsg {
	my ($self, $to, $msg) = @_;
	say "_privmsg: sending a message to $to";
	$self->send_srv(PRIVMSG => $to, $msg);
}
