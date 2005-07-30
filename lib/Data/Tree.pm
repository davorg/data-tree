package Data::Tree;

use 5.006;
use strict;
use warnings;

use Carp;

our $VERSION = '0.01';

sub new {
  my $class = shift;

  my $self = bless {}, $class;

  my %parms = @_;

  $self->{$_} = $parms{$_} || $_ for qw(id parent);

  if ($parms{file}) {
    $self->_init_from_file(%parms);
  } elsif ($parms{array}) {
    $self->_init_from_array(%parms);
  }

  return $self;
}

sub _init_from_file {
  my $self = shift;

  my %parms = @_;

  my $file = $parms{file};
  local *FILE;
  open FILE, $file or croak "Can't open $file: $!";

  my $sep = $parms{separator} || '\t';

  chomp(my $head = <FILE>);
  my @head = split /$sep/, $head;

  my @array;
  while (<FILE>) {
    chomp;
    my %rec;
    @rec{@head} = split /$sep/;
    push @array, \%rec;
  }

  $self->_init_from_array(%parms, array => \@array);
}

sub _init_from_array {
  my $self = shift;

  my %parms = @_;
  my @array = @{$parms{array}};

  my (@order, %tree, %all);
  foreach (@array) {
    if ($_->{$self->{parent}}) {
      push @{$all{$_->{$self->{parent}}}{children}}, $_;
    } else {
      $tree{$_->{$self->{id}}} = $_;
    }
    $all{$_->{$self->{id}}} = $_;
    push @order, $_->{$self->{id}};
  }

  $self->{order} = \@order;
  $self->{tree}  = \%tree;
  $self->{all}   = \%all;

  return $self;
}

sub is_parent {
  my $self = shift;
  my ($p, $c) = @_;

  my $child = $self->{all}{$c};

  return $child->{parent} eq $p;
}

sub is_ancestor {
  my $self = shift;
  my ($p, $c) = @_;

  my $child = $self->{all}{$c};

  while ($child->{parent}) {
    return 1 if $child->{parent} eq $p;
    $child = $self->{all}{$child->{parent}};
  }

  return;
}

sub is_child {
  my $self = shift;

  return $self->is_parent($_[1], $_[0]);
}

sub is_descendent {
  my $self = shift;

  return $self->is_ancestor($_[1], $_[0]);
}

sub ancestors {
  my $self = shift;
  my $c = shift;

  my @ancestors;
  my $child = $self->{all}{$c};

  if ($child->{parent}) {
    return $self->{all}{$child->{parent}}, $self->ancestors($child->{parent});
  } else {

  }
}

sub level {
  my $self = shift;
  my $c = shift;

  my @a = $self->ancestors($c);

  return scalar @a;
}

1;
__END__

=head1 NAME

Data::Tree - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Data::Tree;
  blah blah blah

=head1 ABSTRACT

  This should be the abstract for Data::Tree.
  The abstract is used when making PPD (Perl Package Description) files.
  If you don't want an ABSTRACT you should also edit Makefile.PL to
  remove the ABSTRACT_FROM option.

=head1 DESCRIPTION

Stub documentation for Data::Tree, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Dave Cross, E<lt>dave@mag-sol.demon.co.ukE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2002 by Dave Cross

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
