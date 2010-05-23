package a8bot::Plugin::Odzywki;
use feature ':5.10';
use Moose;
with 'a8bot::Plugin';

has 'lastresponse' => (is => 'rw', isa => 'Int', default => sub { 0 });

sub BUILD {
	my $self = shift;
	$self->passive_cb(sub { pubmsg($self, @_) });
}

sub pubmsg {
	my ($self, %data) = @_;
	my $resp;
	return if time - $self->lastresponse < 120;
	given ($data{msg}) {
		when (/kurwa/i) { $resp = $self->kurwa };
		when (/ty chuju/i) { $resp = $self->ty_chuju };
		when (/chuj/i) { $resp = $self->chuj };
		when (/dupa/i) { $resp = $self->dupa };
		when (/spierdalaj/i) { $resp = $self->spierdalaj };
		when (/jeb[ię|ać|ie|e]/i) { $resp = $self->jebac };
		default { return undef };
	}
	$self->lastresponse(time);
	return "$data{nick}: $resp";
}

sub chuj {
	my @resp = (
		'Nasi dziadowie na mchu jadali!',
		'Trzy ruchy i suchy?',
		'Chuj Ci w dupie chodzi!',
		'Musisz przyznać, że jak tatuś zrobi dzióbek, to nie ma chuja we wsi.',
		'Grozisz mi!?',
		'A na chuj mnie ten kaktus?!',
		'Repeat, please: „My pen is...”.',
		'Jako i Ty szlachetny Panie.'
	);
	return $resp[rand($#resp)];
}

sub dupa {
	my @resp = (
		'Poglądy są jak dupa, każdy jakieś ma, ale po co od razu pokazywać...'
	);
	return $resp[rand($#resp)];
}

sub jebac {
	my @resp = (
		'Zamilcz kobieto, bo nie wiesz co czynisz!'
	);
	return $resp[rand($#resp)];
}

sub kurwa {
	my @resp = (
		'Też kobieta. Tylko pizda nie ta.',
		'O! Ty też?',
		'Też dziewczyna. Tylko krocze ma robocze.',
	);
	return $resp[rand($#resp)];
}

sub spierdalaj {
	my @resp = (
		'Jakie „spierdalaj”, sam spierdalaj z tym bufetem, bo mi tapicerkę zapaćkasz!',
		'Dobra! To chuj ci w dupę, stary! Ja tu na deszczu, wilki jakieś! Przyrzekaliśmy sobie ten film od lat, ale jak nie, to nie!'
	);
	return $resp[rand($#resp)];
}

sub ty_chuju {
	my @resp = (
		'Jak śmiesz nazywać mnie cwelem, pierdolona cioto! Moja dupa jest ciasna jak po praniu! A twoja matka to chuj!',
		'Nigdy cię nie lubiłem. Nie okazywałaś mi szacunku, w twoich oczach widziałem tylko pogardę. A to boli. Jak drzazga w fiucie.'
		);
	return $resp[rand($#resp)];
}

__PACKAGE__->meta->make_immutable;

1;
