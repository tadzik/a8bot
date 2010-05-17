package a8bot::Plugin::Odzywki;
use Tie::RegexpHash;

tie my %db, 'Tie::RegexpHash';

%db = (
	qr/.*kurwa.*/i		=> \&kurwa,
	qr/.*ty chuju.*/i	=> \&ty_chuju,
	qr/.*chuj.*/i		=> \&chuj,
	qr/.*dupa.*/i		=> \&dupa,
	qr/.*spierdalaj.*/i	=> \&spierdalaj,
	qr/.*jeb[ię|ać|ie|e].*/ => \&jebac
);


sub init {
	return { publicmsg => \&pubmsg };
}

sub pubmsg {
	my ($bot, $data) = @_;
	if (my $resp = $db{$data->{msg}}->()) {
		return "$data->{nick}: " . $resp;
	}

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
		'Kurwa, Bomba, jesteś głuchy, czy pierdolnięty?',
		'Jako i Ty szlachetny Panie.'
	);
	return $resp[rand($#resp)];
}

sub dupa {
	my @resp = (
		'Wypiąć bardziej, niech nie kuli jak pies przy kupci.',
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
		'To be, kurwa! Or nor to be!',
		'Dżizus, kurwa, ja pierdolę!',
		'Dawno temu ja też zaufałem pewnej kobiecie, wtedy dałbym sobie za nią rękę uciąć. I wiesz, co... I bym teraz, kurwa, nie miał ręki!',
		'Trzeba płacić. W paszczu pięćdziesiąt, a za seks...',
		'Lubisz to suko!'
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

1;
