package a8bot::Plugin::Odzywki;
use Tie::RegexpHash;

tie my %db, 'Tie::RegexpHash';

%db = (
	qr/.*kurwa.*/i		=> \&kurwa,
	qr/.*ty chuju.*/i	=> \&ty_chuju,
	qr/.*chuj.*/i		=> \&chuj,
	qr/.*dupa.*/i		=> \&dupa,
	qr/.*spierdalaj.*/i	=> \&spierdalaj,
	qr/.*jeb[ię|ać|ie|e]/.* => \&jebac
);


sub init {
	return { publicmsg => \&pubmsg };
}

sub pubmsg {
	my ($bot, $data) = @_;
	if(eval '$db{$data->{msg}}->()'){
		return "$data->{nick}: ".$db{$data->{msg}}->();
	}
	
}

sub chuj {
	my $rand = int(rand(100)/11);
	CASE: {
		if($rand == 0){return 'Nasi dziadowie na mchu jadali!'; last CASE}
		if($rand == 1){return 'Trzy ruchy i suchy?'; last CASE}
		if($rand == 2){return 'Chuj Ci w dupie chodzi!'; last CASE}
		if($rand == 3){return 'Musisz przyznać, że jak tatuś zrobi dzióbek, to nie ma chuja we wsi.'; last CASE}
		if($rand == 4){return 'A na chuj mnie ten kaktus?!'; last CASE}
		if($rand == 5){return 'Grozisz mi!?'; last CASE}
		if($rand == 6){return 'Repeat, please: „My pen is...”.'; last CASE}
		if($rand == 7){return 'Kurwa, Bomba, jesteś głuchy, czy pierdolnięty?'; last CASE}
		if($rand == 8){return 'Jako i Ty szlachetny Panie.'; last CASE}
	}
}

sub dupa {
	my $rand = int(rand(100)/30);
	CASE: {
		if($rand == 0){return 'Wypiąć bardziej, niech nie kuli jak pies przy kupci.'; last CASE}
		if($rand == 1){return 'Poglądy są jak dupa, każdy jakieś ma, ale po co od razu pokazywać...'; last CASE}
	}
}

sub jebac {
	my $rand = init(rand(100)/90);
	CASE: {
		if($rand == 0){return 'Zamilcz kobieto, bo nie wiesz co czynisz!'; last CASE}
	}
}

sub kurwa {
	my $rand = int(rand(100)/11);
	CASE: {
		if($rand == 0){return 'Też kobieta. Tylko pizda nie ta.'; last CASE}
		if($rand == 1){return 'O! Ty też?'; last CASE}
		if($rand == 2){return 'Też dziewczyna. Tylko krocze ma robocze.'; last CASE}
		if($rand == 3){return 'To be, kurwa! Or nor to be!', last CASE}
		if($rand == 4){return 'Dżizus, kurwa, ja pierdolę!'; last CASE}
		if($rand == 5){return 'Dawno temu ja też zaufałem pewnej kobiecie, wtedy dałbym sobie za nią rękę uciąć. I wiesz, co... I bym teraz, kurwa, nie miał ręki!'; last CASE}
		if($rand == 6){return 'Trzeba płacić. W paszczu pięćdziesiąt, a za seks...'; last CASE}
		if($rand == 7){return 'Lubisz to suko!'; last CASE}
	}
}

sub spierdalaj {
	my $rand = int(rand(100)/25);
	CASE: {
		if($rand == 0){return 'Jakie „spierdalaj”, sam spierdalaj z tym bufetem, bo mi tapicerkę zapaćkasz! '; last CASE}
		if($rand == 1){return 'Dobra! To chuj ci w dupę, stary! Ja tu na deszczu, wilki jakieś! Przyrzekaliśmy sobie ten film od lat, ale jak nie, to nie!'; last CASE}
	}
}

sub ty_chuju {
	my $rand = int(rand(100)/30);
	CASE: {
		if($rand == 0){return 'Jak śmiesz nazywać mnie cwelem, pierdolona cioto! Moja dupa jest ciasna jak po praniu! A twoja matka to chuj!'; last CASE}
		if($rand == 1){return 'Nigdy cię nie lubiłem. Nie okazywałaś mi szacunku, w twoich oczach widziałem tylko pogardę. A to boli. Jak drzazga w fiucie. '; last CASE}
	}
}

1;
