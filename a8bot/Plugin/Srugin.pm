package a8bot::Plugin::Srugin;
use feature ':5.10';
use Moose;
with 'a8bot::Plugin';

sub BUILD {
    my $self = shift;
    $self->passive_cb(sub { pubmsg($self, @_) });
}

sub pubmsg {
    my ($self, %data) = @_;
    if ($data{msg} =~ /\?(\S+)\?/) {
        my $prev = $1;
        my $new = $prev;
        $new =~ s/^[^aeiouy]*/sr/;
        return "$prev $new!";
    }
}
