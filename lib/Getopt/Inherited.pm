package Getopt::Inherited;
use 5.008;
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
our $VERSION = '0.01';
use base qw(
  Class::Accessor::Complex
  Data::Inherited
);
__PACKAGE__->mk_hash_accessors(qw(opt));
Getopt::Long::Configure('no_ignore_case');

use constant GETOPT => (qw(help man logfile|log=s verbose|v+ version|V));
use constant GETOPT_DEFAULTS => ();

sub usage {
    my $self = shift;
    require Pod::Usage;
    Pod::Usage::pod2usage(@_);
}

sub do_getopt {
    my $self = shift;
    my %opt;
    GetOptions(\%opt, $self->every_list('GETOPT')) or $self->usage(2);
    $self->usage(1) if $opt{help};
    $self->usage(-exitstatus => 0, -verbose => 2) if $opt{man};
    my %defaults = $self->every_hash('GETOPT_DEFAULTS');
    while (my ($key, $value) = each %defaults) {
        next if defined $opt{$key};
        $opt{$key} = $value;
    }
    $self->opt(%opt);
    $self;
}
1;
__END__

=head1 NAME

Getopt::Inherited - Handling inherited command-line options

=head1 SYNOPSIS

    use base 'Getopt::Inherited';

    use constant GETOPT => qw(foo=s);
    my $app = __PACKAGE__->new;
    $app->do_getopt;

=head1 DESCRIPTION

By subclassing this mixin class, your program gets the ability to inherit
command-line option specifications. If you have several programs that share
common code and common command-line options you don't want to have to write
the command-line processing code again and again. Using this class you can
abstract command-line options shared by your programs into a superclass from
which your programs then inherit. Additionally, this class defines certain
common command-line options itself.

You can also define defaults for command-line options.

=head1 METHODS

=over 4

=item C<GETOPT>

This accessor, which is accumulated across the class hierarchy using
L<Data::Inherited>, is used to define command-line options in the same format
as L<Getopt::Long> expects. This class, L<Getopt::Inherited>, itself defines
the following options:

    use constant GETOPT =>
        (qw(help man logfile|log=s verbose|v+ version|V));

=item C<GETOPT_DEFAULTS>

This accessor, which is also accumulated across the class hierarchy, can be
used to define defaults for the options given in C<GETOPT()>. For example, to
define a command-line option called <foo> which takes a string and to give it
a default, you would use:

    use constant GETOPT => qw(foo=s);
    use constant GETOPT_DEFAULTS => (foo => 'my_default');

=item C<opt>

This is a hash accessor per L<Class::Accessor::Complex> in which the option
hash is stored when it has been parsed and after default values have been
applied.

=item C<usage>

This method is called by C<do_getopt()> after the command-line options have
been processed with L<Getopt::Long>'s C<GetOptions>. It uses L<Pod::Usage> to
display help information if there was either an error during processing, or if
the C<--help> or C<--man> options have been given.

=item C<do_getopt>

Does the actual command-line processing. It accumulates the values of
L<GETOPT()> across the hierarchy, parses them, calls C<usage()> if necessary,
applies L<GETOPT_DEFAULTS()>, then assigns the finished options hash to
C<opt()>.

=back

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://rt.cpan.org>.

=head1 INSTALLATION

See perlmodinstall for information and options on installing Perl modules.

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you. Or see L<http://search.cpan.org/dist/Getopt-Inherited/>.

The development version lives at L<http://github.com/hanekomu/getopt-inherited/>.
Instead of sending patches, please fork this project using the standard git
and github infrastructure.

=head1 AUTHORS

Marcel GrE<uuml>nauer, C<< <marcel@cpan.org> >>

=head1 COPYRIGHT AND LICENSE

Copyright 2009 by Marcel GrE<uuml>nauer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
