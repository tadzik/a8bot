use a8bot;

my $bot = a8bot->new(
	channel	=> '#some-channel',
	server	=> 'irc.freenode.net',
	nick	=> 'a8bot',
	verbose	=> 1,
);

#$SIG{INT} = sub { $bot->cleanup };
#$SIG{TERM} = sub { $bot->cleanup };

$bot->run;
