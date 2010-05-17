package a8bot::Plugin::WebTitle;
use LWP::Simple;

sub init {
	return { publicmsg => \&pubmsg };
}

sub pubmsg {
	my ($bot, $data) = @_;
	if ($data->{msg} =~ /(http:\/\/[^ ]+)/) {
		print "Got url: $1\n";
		my $site = get($1);
		my ($title) = $site =~ /<title>([^<]+)<\/title>/;
		if ($title) {
			return "[ $title ]";
		} else {
			return undef;
		}
	}
}

1;
