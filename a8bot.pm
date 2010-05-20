package a8bot;
use feature ':5.10';
use a8bot::Plugin;
use Moose;
use MooseX::NonMoose;
use Module::Pluggable sub_name => 'pluggable', require => 1;
use AnyEvent;
use AnyEvent::IRC::Client;

extends 'AnyEvent::IRC::Client';

has 'channel' => (
	is		=> 'ro',
	isa		=> 'Str',
	required	=> 1,
	documentation	=> 'A channel on which bot resides on',
);

has 'server' => (
	is		=> 'ro',
	isa		=> 'Str',
	required	=> 1,
	documentation	=> 'A server bot connects to',
);

has 'nick' => (
	is		=> 'ro',
	isa		=> 'Str',
	default		=> 'a8bot',
	documentation	=> 'An IRC nickname bot is using',
);

has 'passwd' => (
	is		=> 'ro',
	isa		=> 'Str',
	documentation	=> 'An IRC password',
);

has 'plugins' => (
	is		=> 'rw',
	isa		=> 'ArrayRef[a8bot::Plugin]',
	default		=> sub { [] },
	traits		=> [ 'Array' ],
	handles		=> {
		add_plugin	=> 'push',
		list_plugins	=> 'elements',
	},
	documentation	=> 'Array of plugins we use',
);

has 'port' => (
	is		=> 'ro',
	isa		=> 'Int',
	default		=> '6667',
	documentation	=> 'A port of a server bot is connecting to',
);

has 'verbose' => (
	is		=> 'rw',
	isa		=> 'Bool',
	default		=> 0,
	documentation	=> 'Whether to enable verbosity',
);

has 'wantconnection' => (
	is		=> 'rw',
	isa		=> 'Bool',
	default		=> 1,
	documentation	=> 'Whether to reconnect on disconnect event',
);

sub BUILD {
	my $self = shift;
	foreach my $plugin ($self->pluggable) {
		my $plug = a8bot::Plugin->new(
			bot => $self,
			plugin => $plugin,
		);
		$self->add_plugin($plug);
	}
	$self->reg_cb(
		disconnect => sub {
			if ($self->wantconnection) {
				$self->log("We still want connection, reconnecting");
				$self->connect(
					$self->server,
					$self->port,
					{ nick => $self->nick,
					password => $self->passwd },
				);
			}
		},
		publicmsg => sub {
			my ($client, $channel, $params) = @_;
			foreach my $plugin ($self->list_plugins) {
				$plugin->publicmsg($channel, $params);
			}
		},
		registered => sub {
			my $client = shift;
			$client->send_srv(JOIN => $self->channel);
			# TODO: Some callback maybe? Rather for
			# logging purposes
			$client->enable_ping(60);
			foreach my $plugin ($self->list_plugins) {
				$plugin->registered;
			}
		},
	);
}

#sub cleanup {
#	my $self = shift;
#	say "Exiting";
#	$self->wantconnection(0);
#	$self->disconnect;
#	# TODO: Let the plugins know
#	exit 0;
#}

sub log {
	my ($self, @args) = @_;
	if ($self->verbose) {
		say @args;
	}
}

# Tu się zaczyna ten cały burdel
sub run {
	my $self = shift;
	my $j = AnyEvent->condvar;
	$self->connect(
		$self->server,
		$self->port,
		{ nick => $self->nick, password => $self->passwd }
	);
	$j->wait;
}

__PACKAGE__->meta->make_immutable;

1;
