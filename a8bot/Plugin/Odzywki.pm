package a8bot::Plugin::Odzywki;

my %db = (
	'kurwa'	=> 'Też kobieta. Tylko pizda nie ta',
);

sub init {
	return { publicmsg => \&pubmsg };
}

sub pubmsg {
	my ($bot, $data) = @_;
	if ($db{$data->{msg}}) {
		return "$data->{nick}: $db{$data->{msg}}";
	}
}

1;
