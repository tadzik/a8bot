package Ping;
# example plugin for a8bot

# a plugin MUST have an 'init' subroutine, returning a hash with keys
# 'publicmsg', 'disconnect' and/or 'registered'. The values are to be
# coderefs which would be run on the specified events
sub init {
	return { publicmsg => \&pubmsg };
}

sub pubmsg {
	my ($bot, $data) = @_;
	if ($data->{msg} =~ /^$bot->{nick}:?,? ping$/) {
		return [PRIVMSG => $data->{channel}, "$data->{nick}: pong"];
	}
}

1;
