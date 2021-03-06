package a8bot;
use feature ':5.10';
use a8bot::Plugin;
use Module::Load;
use Moose;
use MooseX::NonMoose;
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
	isa		=> 'ArrayRef',
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
		error => sub {
			my (undef, $code, $message, $ircmsg) = @_;
			$self->log("Error $code: $message");
		},
		publicmsg => sub {
			my $params = $_[2];
			foreach my $plugin ($self->list_plugins) {
				$plugin->pubmsg_cb($params);
			}
		},
		registered => sub {
			my $client = shift;
			$client->send_srv(JOIN => $self->channel);
			# TODO: Some callback maybe? Rather for
			# logging purposes
			$client->enable_ping(60);
			foreach my $plugin ($self->list_plugins) {
				$plugin->registered_cb;
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

sub load_plugin {
	my ($self, $plugin) = @_;
	load $plugin;
	my $plug = $plugin->new(bot => $self);
	$self->add_plugin($plug);
}

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
