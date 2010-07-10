package a8bot::Plugin::WebTitle;
use Moose;
use LWP::UserAgent;
use Sys::SigAction 'timeout_call';
use Encode;
with 'a8bot::Plugin';

has 'ua' => (
	is	=> 'ro',
	isa	=> 'LWP::UserAgent',
	default	=> sub { LWP::UserAgent->new },
);

sub BUILD {
	my $self = shift;
	$self->ua->max_size(1024);
	$self->ua->agent('Mozilla/5.0 (X11; U; Linux i686; en-US) AppleWebKit/534.2 (KHTML, like Gecko) Chrome/6.0.452.0 Safari/534.2');
	$self->passive_cb(sub { pubmsg($self, @_) });
}

sub pubmsg {
	my ($self, %data) = @_;
	if ($data{msg} =~ /(http:\/\/[^ ]+)/) {
		my $site;
		if (timeout_call(8, sub { $site = $self->ua->get($1) })){
			return undef;
		} else {
			if ($site->is_success) {
				$site = $site->decoded_content;
				my ($title) = $site =~ /<title>([^<]+)<\/title>/i;
				if ($title) {
					$title =~ s/^\s+//g;
					$title =~ s/\s+$//g;
					$title =~ s/\s+/ /g;
					return encode('utf-8', "[ $title ]");
				}
			} else {
				return '[ '.$site->status_line.' ]';
			}
		}
	}
	return undef;
}

__PACKAGE__->meta->make_immutable;

1;
