package a8bot::Plugin::WebTitle;
use Moose;
use LWP::Simple qw /get $ua/;
use Sys::SigAction qw /timeout_call/;
with 'a8bot::Plugin';

sub BUILD {
	my $self = shift;
	$self->passive_cb(sub { pubmsg(@_) });
}

sub pubmsg {
	my (%data) = @_;
	if ($data{msg} =~ /(http:\/\/[^ ]+)/) {
		$ua->max_size(1024);
		our $site;
		if (timeout_call(8, sub {$site = get($1)})){
			return undef;
		} else {
			my ($title) = $site =~ /<title>([^<]+)<\/title>/i;
			$title =~ s/\n/ /g;
			return "[ $title ]" if $title;
		}
	}
	return undef;
}

__PACKAGE__->meta->make_immutable;

1;
