package MooseX::NonMoose::InsideOut;

use Moose::Exporter;

# ABSTRACT: easy subclassing of non-Moose non-hashref classes
# VERSION

=head1 SYNOPSIS

  package Term::VT102::NBased;
  use Moose;
  use MooseX::NonMoose::InsideOut;
  extends 'Term::VT102';

  has [qw/x_base y_base/] => (
      is      => 'ro',
      isa     => 'Int',
      default => 1,
  );

  around x => sub {
      my $orig = shift;
      my $self = shift;
      $self->$orig(@_) + $self->x_base - 1;
  };

  # ... (wrap other methods)

  no Moose;
  # no need to fiddle with inline_constructor here
  __PACKAGE__->meta->make_immutable;

  my $vt = Term::VT102::NBased->new(x_base => 0, y_base => 0);

=head1 DESCRIPTION

=cut

my ($import, $unimport, $init_meta) = Moose::Exporter->build_import_methods(
    class_metaroles => {
        class       => ['MooseX::NonMoose::Meta::Role::Class'],
        constructor => ['MooseX::NonMoose::Meta::Role::Constructor'],
        instance    => ['MooseX::InsideOut::Role::Meta::Instance'],
    },
    install => [qw(import unimport)],
);

sub init_meta {
    my $package = shift;
    my %options = @_;
    my $meta = Moose::Util::find_meta($options{for_class});
    Carp::cluck('Roles have no use for MooseX::NonMoose')
        if $meta && $meta->isa('Moose::Meta::Role');
    $package->$init_meta(@_);
}

=begin Pod::Coverage

  init_meta

=end Pod::Coverage

=cut

1;
