package Seen;
use POSIX 'strftime';

my %log;

sub init {
	return { publicmsg => \&pubmsg };
}

sub pubmsg {
	my ($bot, $data) = @_;
	my $resp;
	if ($data->{msg} =~ /seen (.+)$/) {
		my $entry = $log{$1};
		if (defined $entry) {
			$resp = "$data->{nick}: $1 was last seen on @$entry[0] -- \"@$entry[1]\"";
		} else {
			$resp = "$data->{nick}: I have not seen $1";
		}
	}
	$log{$data->{nick}} = [strftime("%x %X", localtime), $data->{msg}];
	return $resp;
}
1;
