use a8bot;

my $bot = a8bot->new(
	channel	=> '#bottest',
	server	=> 'irc.pirc.pl',
	nick	=> 'm18',
	verbose	=> 1,
);

$bot->load_plugin('Ping');

#$SIG{INT} = sub { $bot->cleanup };
#$SIG{TERM} = sub { $bot->cleanup };

$bot->run;
