package WebTitle;
use LWP::Simple qw /get $ua/;
use Sys::SigAction qw /timeout_call/;
use vars qw /$site/;

sub init {
	return { publicmsg => \&pubmsg };
}

sub pubmsg {
	my ($bot, $data) = @_;
	my $timeout = 10;
	if ($data->{msg} =~ /(http:\/\/[^ ]+)/) {
		$ua->max_size(1024);
		if (timeout_call($timeout, sub {$site = get($1)})){
			return undef;
		}
		else {
			my ($title) = $site =~ /<title>([^<]+)<\/title>/i;
			$title =~ s/\n/ /g;
			return "[ $title ]" if $title;
		}
	}
	return undef;
}

1;
