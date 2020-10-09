#!/usr/bin/env perl 
use Mojo::Base -strict, -signatures;
use Pod::Usage;
use Getopt::Long;
our $DEBUG = 0;

our %debug = ( 
    header => "Calculating Levenshtein distance for '%s' and '%s'",
    step => "Index i: %s, Index j: %s",
);

sub max {
    my $m = shift || 0;

    while ( my $v = shift ) {
        $m = $v if $m < $v;
    }
    return $m;
}

sub min {
    my $m = shift || 0;

    while ( my $v = shift ) {
        $m = $v if $m > $v;
    }

    return $m;
}

# The indicator function
sub ind ( $a, $b, $i, $j ) {
    my @a = split //, $a;
    my @b = split //, $b;
    return $a[ $i - 1 ] eq $b[ $j - 1 ] ? 0 : 1;
}

# The Levenshtein distance
sub lev ( $a, $b, $i = length($a), $j = length($b) ) {
    return max( $i, $j ) if $i <= 0 or $j <= 0 or min( $i, $j ) == 0;

    say sprintf( $debug{ step }, $i, $j ) if $DEBUG;
    return min(
        lev( $a, $b, $i - 1, $j ) + 1,
        lev( $a, $b, $i,     $j - 1 ) + 1,
        lev( $a, $b, $i - 1, $j - 1 ) + ind( $a, $b, $i, $j )
    );
}

sub run_example ( $a, $b ) {
    say sprintf( $debug{header}, $a, $b ) if $DEBUG;
    my $res = lev( $a, $b );

    print <<EOT;
This is the example calculate the Levenshtein distance (lev) for two words:
( Use --debug to see details in steps )
"$a" and "$b" :  $res
EOT
}

sub main {
    my %opt;
    GetOptions( \%opt, "help|?", "man", "debug" ) || pod2usage(2);
    pod2usage(1)                              if ( $opt{help} );
    pod2usage( -exitval => 0, -verbose => 2 ) if ( $opt{man} );
    $DEBUG = 1                                if ( $opt{debug} );
    run_example( 'kitten', 'sitting' );
}

MAIN:
main;

__END__

=encoding utf-8

=head1 NAME

Levenshtein Distance

=head1 DESCRIPTION

This is straightforward implementation of the algorithm defined in:

1. Levenshtein distance. In: Wikipedia [Internet]. 2020 [cited 2020 Jul 12]. Available from: https://en.wikipedia.org/w/index.php?title=Levenshtein_distance&oldid=957760169

=head1 OPTIONS

 --debug: to see the algorithm in steps and detailed info
=cut
