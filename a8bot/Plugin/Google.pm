package a8bot::Plugin::Google;
use Moose;
use REST::Google::Search;
use HTML::Entities;
use Encode;
with 'a8bot::Plugin';

sub BUILD {
	my $self = shift;
	$self->keyword('g');
	$self->keyword_cb(sub { pubmsg(@_) });
}

sub pubmsg {
	my (%data) = @_;
	my @args = @{$data{args} // []};
	if ($#args < 0) {
		return "$data{nick}: Usage: g <keywords>";
	}
	REST::Google::Search->http_referer('http://www.autom8.pl');
	my $res = REST::Google::Search->new(
		q => join(' ', @args)
	);
	my $pres = $res->{responseData}->{results}->[0];
	if ($pres) {
		decode_entities($pres->{titleNoFormatting});
		return encode('utf8', "$data{nick}: [ $pres->{titleNoFormatting} ] -- $pres->{unescapedUrl}");
	} else {
		return "$data{nick}: nic nie znaleziono.";
	}
}

__PACKAGE__->meta->make_immutable;

1;
