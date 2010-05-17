package a8bot::Plugin::WebTitle;
use LWP::Simple qw /get $ua/;

sub init {
	return { publicmsg => \&pubmsg };
}

sub pubmsg {
	my ($bot, $data) = @_;
	if ($data->{msg} =~ /(http:\/\/[^ ]+)/) {
		$ua->max_size(1024);
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
