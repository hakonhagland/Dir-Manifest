# NAME

Dir::Manifest

# VERSION

version 0.0.5

# SYNOPSIS

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

# DESCRIPTION

Here is the primary use case: you have several long texts (and/or binary blobs) that you
wish to load from the code (e.g: for the "want"/expected values of tests) and you wish to
conventiently edit them, track them and maintain them. Using [Dir::Manifest](https://metacpan.org/pod/Dir::Manifest) you can
put each in a separate file in a directory, create a manifest file listing all valid
filenames/key and then say something like
`my $text = $dir->text("deal24solution.txt", {lf => 1})`. And hopefully it will
be done securely and reliably.

# NAME

Dir::Manifest - treat a directory and a manifest file as a hash/dictionary of keys to texts or blobs

# VERSION

version 0.0.5

# METHODS

## $self->manifest\_fn()

The path to the manifest file.

## $self->dir()

The path to the directory containing the texts and blobs as files.

## $self->get\_keys()

Returns a sorted array reference containing the available keys as strings.

## $self->get\_obj($key)

Returns the [Dir::Manifest::Key](https://metacpan.org/pod/Dir::Manifest::Key) object associated with the string $key.
Throws an error if $key was not given in the manifest.

## my $contents = $self->text("$key", {%OPTS})

Slurps the key using [Dir::Manifest::Slurp](https://metacpan.org/pod/Dir::Manifest::Slurp)

## my $hash\_ref = $obj->texts\_dictionary( {slurp\_opts => {},} );

Returns a hash reference (a dictionary) containing all keys and their slurped contents
as values. `'slurp_opts'` is passed to text().

# DEDICATION

This code is dedicated to the memory of [Jonathan Scott Duff](https://metacpan.org/author/DUFF)
a.k.a PerlJam and perlpilot who passed away some days before the first release of
this code. For more about him, see:

- [https://p6weekly.wordpress.com/2018/12/30/2018-53-goodbye-perljam/](https://p6weekly.wordpress.com/2018/12/30/2018-53-goodbye-perljam/)
- [https://www.facebook.com/groups/perl6/permalink/2253332891599724/](https://www.facebook.com/groups/perl6/permalink/2253332891599724/)
- [https://www.mail-archive.com/perl6-users@perl.org/msg06390.html](https://www.mail-archive.com/perl6-users@perl.org/msg06390.html)
- [https://www.shlomifish.org/humour/fortunes/sharp-perl.html](https://www.shlomifish.org/humour/fortunes/sharp-perl.html)

# MEDIA RECOMMENDATION

[kristian vuljar](https://www.jamendo.com/artist/441226/kristian-vuljar) used to
have a jamendo track called "Keys" based on [Shine 4U](https://www.youtube.com/watch?v=B8ehY5tutHs) by Carmen and Camille. You can find it at [http://www.shlomifish.org/Files/files/dirs/kristian-vuljar--keys/](http://www.shlomifish.org/Files/files/dirs/kristian-vuljar--keys/) .

# SUPPORT

## Websites

The following websites have more information about this module, and may be of help to you. As always,
in addition to those websites please use your favorite search engine to discover more resources.

- MetaCPAN

    A modern, open-source CPAN search engine, useful to view POD in HTML format.

    [https://metacpan.org/release/Dir-Manifest](https://metacpan.org/release/Dir-Manifest)

- Search CPAN

    The default CPAN search engine, useful to view POD in HTML format.

    [http://search.cpan.org/dist/Dir-Manifest](http://search.cpan.org/dist/Dir-Manifest)

- RT: CPAN's Bug Tracker

    The RT ( Request Tracker ) website is the default bug/issue tracking system for CPAN.

    [https://rt.cpan.org/Public/Dist/Display.html?Name=Dir-Manifest](https://rt.cpan.org/Public/Dist/Display.html?Name=Dir-Manifest)

- AnnoCPAN

    The AnnoCPAN is a website that allows community annotations of Perl module documentation.

    [http://annocpan.org/dist/Dir-Manifest](http://annocpan.org/dist/Dir-Manifest)

- CPAN Ratings

    The CPAN Ratings is a website that allows community ratings and reviews of Perl modules.

    [http://cpanratings.perl.org/d/Dir-Manifest](http://cpanratings.perl.org/d/Dir-Manifest)

- CPANTS

    The CPANTS is a website that analyzes the Kwalitee ( code metrics ) of a distribution.

    [http://cpants.cpanauthors.org/dist/Dir-Manifest](http://cpants.cpanauthors.org/dist/Dir-Manifest)

- CPAN Testers

    The CPAN Testers is a network of smoke testers who run automated tests on uploaded CPAN distributions.

    [http://www.cpantesters.org/distro/D/Dir-Manifest](http://www.cpantesters.org/distro/D/Dir-Manifest)

- CPAN Testers Matrix

    The CPAN Testers Matrix is a website that provides a visual overview of the test results for a distribution on various Perls/platforms.

    [http://matrix.cpantesters.org/?dist=Dir-Manifest](http://matrix.cpantesters.org/?dist=Dir-Manifest)

- CPAN Testers Dependencies

    The CPAN Testers Dependencies is a website that shows a chart of the test results of all dependencies for a distribution.

    [http://deps.cpantesters.org/?module=Dir::Manifest](http://deps.cpantesters.org/?module=Dir::Manifest)

## Bugs / Feature Requests

Please report any bugs or feature requests by email to `bug-dir-manifest at rt.cpan.org`, or through
the web interface at [https://rt.cpan.org/Public/Bug/Report.html?Queue=Dir-Manifest](https://rt.cpan.org/Public/Bug/Report.html?Queue=Dir-Manifest). You will be automatically notified of any
progress on the request by the system.

## Source Code

The code is open to the world, and available for you to hack on. Please feel free to browse it and play
with it, or whatever. If you want to contribute patches, please send me a diff or prod me to pull
from your repository :)

[https://github.com/shlomif/Dir-Manifest](https://github.com/shlomif/Dir-Manifest)

    git clone https://github.com/shlomif/Dir-Manifest.git

# AUTHOR

Shlomi Fish <shlomif@cpan.org>

# BUGS

Please report any bugs or feature requests on the bugtracker website
[https://github.com/shlomif/dir-manifest/issues](https://github.com/shlomif/dir-manifest/issues)

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

# COPYRIGHT AND LICENSE

This software is Copyright (c) 2019 by Shlomi Fish.

This is free software, licensed under:

    The MIT (X11) License
