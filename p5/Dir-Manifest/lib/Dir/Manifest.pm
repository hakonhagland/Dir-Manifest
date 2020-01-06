package Dir::Manifest;

use strict;
use warnings;

use 5.014;

use Path::Tiny qw/ path /;
use Dir::Manifest::Key   ();
use Dir::Manifest::Slurp ();

use Moo;

has 'manifest_fn' => ( is => 'ro', required => 1 );
has 'dir'         => ( is => 'ro', required => 1 );

my $ALLOWED = qr/[a-zA-Z0-9_\-\.=]/;
my $ALPHAN  = qr/[a-zA-Z0-9_]/;

sub _is_valid_key
{
    my ( $self, $key ) = @_;
    if ( $key !~ /\A(?:$ALLOWED)+\z/ )
    {
        die
"Invalid characters in key \"$key\"! We only allow A-Z, a-z, 0-9, _, dashes and equal signs.";
    }
    if ( $key !~ /\A$ALPHAN/ )
    {
        die qq#Key does not start with an alphanumeric - "$key"!#;
    }
    if ( $key !~ /$ALPHAN\z/ )
    {
        die qq#Key does not end with an alphanumeric - "$key"!#;
    }

    return;
}

has '_keys' => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;

        my @lines = path( $self->manifest_fn )->lines( { chomp => 1 } );
        my $ret   = +{};

        foreach my $l (@lines)
        {
            $self->_is_valid_key($l);
            $ret->{$l} = 1;
        }
        return $ret;
    }
);

has '_dh' => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;
        return path( $self->dir );
    },
);

sub get_keys
{
    my ($self) = @_;

    return [ sort { $a cmp $b } keys %{ $self->_keys } ];
}

sub get_obj
{
    my ( $self, $key ) = @_;

    if ( not exists $self->_keys->{$key} )
    {
        die "No such key \"$key\"! Perhaps add it to the manifest.";
    }
    return Dir::Manifest::Key->new(
        { key => $key, fh => $self->_dh->child($key) } );
}

sub fh
{
    my ( $self, $key ) = @_;

    return $self->get_obj($key)->fh;
}

sub text
{
    my ( $self, $key, $opts ) = @_;

    return Dir::Manifest::Slurp::slurp( $self->fh($key), $opts );
}

sub texts_dictionary
{
    my ( $self, $args ) = @_;

    my $opts = $args->{slurp_opts};

    return +{ map { $_ => $self->text( $_, $opts ) } @{ $self->get_keys } };
}

sub add_key
{
    my ( $self, $args ) = @_;

    my $key      = $args->{key};
    my $utf8_val = $args->{utf8_val};

    if ( exists $self->_keys->{$key} )
    {
        die "Key \"$key\" already exists in the dictionary!";
    }

    $self->_is_valid_key($key);

    $self->_keys->{$key} = 1;

    path( $self->manifest_fn )->spew_raw( map { "$_\n" } @{ $self->get_keys } );
    $self->fh($key)->spew_utf8($utf8_val);

    return;
}

sub remove_key
{
    my ( $self, $args ) = @_;

    my $key = $args->{key};

    if ( not exists $self->_keys->{$key} )
    {
        die "Key \"$key\" does not exist in the dictionary!";
    }

    $self->fh($key)->remove;
    delete $self->_keys->{$key};

    path( $self->manifest_fn )->spew_raw( map { "$_\n" } @{ $self->get_keys } );

    return;
}

1;

__END__

=head1 NAME

Dir::Manifest - treat a directory and a manifest file as a hash/dictionary of keys to texts or blobs

=head1 SYNOPSIS

    use Dir::Manifest ();

    my $obj = Dir::Manifest->new(
        {
            manifest_fn => "./t/data/texts/list.txt",
            dir         => "./t/data/texts/texts",
        }
    );

    # TEST
    is (
        scalar(`my-process ...`),
        $obj->text("my-process-output1", {lf => 1,}),
        "Good output of my-process.",
    );

=head1 DESCRIPTION

Here is the primary use case: you have several long texts (and/or binary blobs) that you
wish to load from the code (e.g: for the "want"/expected values of tests) and you wish to
conventiently edit them, track them and maintain them. Using L<Dir::Manifest> you can
put each in a separate file in a directory, create a manifest file listing all valid
filenames/key and then say something like
C<<< my $text = $dir->text("deal24solution.txt", {lf => 1}) >>>. And hopefully it will
be done securely and reliably.

=head1 METHODS

=head2 $self->manifest_fn()

The path to the manifest file.

=head2 $self->dir()

The path to the directory containing the texts and blobs as files.

=head2 $self->get_keys()

Returns a sorted array reference containing the available keys as strings.

=head2 $self->get_obj($key)

Returns the L<Dir::Manifest::Key> object associated with the string $key.
Throws an error if $key was not given in the manifest.

=head2 $self->fh($key)

Returns the L<Path::Tiny> objects for the key, which is usable as a path
in string context. Equivalent to C<<< $self->get_obj($key)->fh() >>>.

(Added in version 0.2.0. ).

=head2 my $contents = $self->text("$key", {%OPTS})

Slurps the key using L<Dir::Manifest::Slurp>

=head2 my $hash_ref = $obj->texts_dictionary( {slurp_opts => {},} );

Returns a hash reference (a dictionary) containing all keys and their slurped contents
as values. C<'slurp_opts'> is passed to text().

=head2 $obj->add_key( {key => "new_key", utf8_val => $utf8_text, } );

Adds a new key with a file with the new UTF-8 contents encoded as $utf8_text .
(Added in version 0.4.0).

=head2 $obj->remove_key( {key => "existing_key_id", } );

Removes the key from the dictionary while deleting its associated file.
(Added in version 0.4.0).

=head1 DEDICATION

This code is dedicated to the memory of L<Jonathan Scott Duff|https://metacpan.org/author/DUFF>
a.k.a PerlJam and perlpilot who passed away some days before the first release of
this code. For more about him, see:

=over 4

=item * L<https://p6weekly.wordpress.com/2018/12/30/2018-53-goodbye-perljam/>

=item * L<https://www.facebook.com/groups/perl6/permalink/2253332891599724/>

=item * L<https://www.mail-archive.com/perl6-users@perl.org/msg06390.html>

=item * L<https://www.shlomifish.org/humour/fortunes/sharp-perl.html>

=back

=head1 MEDIA RECOMMENDATION

L<kristian vuljar|https://www.jamendo.com/artist/441226/kristian-vuljar> used to
have a jamendo track called "Keys" based on L<Shine 4U|https://www.youtube.com/watch?v=B8ehY5tutHs> by Carmen and Camille. You can find it at L<http://www.shlomifish.org/Files/files/dirs/kristian-vuljar--keys/> .

=cut
