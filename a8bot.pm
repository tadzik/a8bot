package a8bot;
use feature ':5.10';
use a8bot::Plugin;
use threads;
use Moose;
use MooseX::NonMoose;
use Module::Pluggable sub_name => 'pluggable', require => 1;
use AnyEvent;
use AnyEvent::IRC::Client;
# temporary?
use Carp::Always::Color;
use Data::Dumper;

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
				my $thr = threads->create(
					sub { $plugin->publicmsg(@_) },
					$channel,
					$params,
				);
				$thr->detach();
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

__END__

=pod

=head2 Small guide to orders

A plugin's callback function should return an array of orders for the bot to execute.
Order is a hash, with an obligatory key 'type', and some other, depending on a type.
Something like this:

  return [
  	{ type => 'privmsg', arg1 => 'foo', arg2 => 'bar' },
	{ type => 'other', args => ['foo', 'bar', 'baz'] },
  ];

Where type should be one of the following:

=over 4

=item privmsg

Arguments for privmsg should be:

=over 2

=item to (string)

User (or channel) to send a message to.

=item msg (string)

The message itself. Simple, huh?

=back

=item mode

Arguments for mode

=over 2

=item args (array)

Array of arguments for AnyEvent's MODE call.
B<Note>: this is likely to suck less in the near future.

Example: { type => 'mode', args = ['username', '+b'] }

=back

=back

=cut
