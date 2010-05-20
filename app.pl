use a8bot;

my $bot = a8bot->new(
	channel	=> '#somechannel',
	server	=> 'irc.freenode.pl',
	nick	=> 'a8bot',
	verbose	=> 1,
);

$bot->load_plugin('Ping');

#$SIG{INT} = sub { $bot->cleanup };
#$SIG{TERM} = sub { $bot->cleanup };

$bot->run;
