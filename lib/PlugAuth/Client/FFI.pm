package PlugAuth::Client::FFI;

use strict;
use warnings;
use FFI::CheckLib;
use FFI::Platypus;
use base qw( Exporter );

# ABSTRACT: PlugAuth client based on libplugauth via FFI
# VERSION

=head1 SYNOPSIS

 use PlugAuth::Client::FFI;
 
 my $client = PlugAuth::Client::FFI->new("http://127.0.0.1:3001");
 if($client->auth($username, $password) == PLUGAUTH_AUTHORIZED)
 {
   # we're in!
 }
 else
 {
   # bogus, wrong username/password
 }

=head1 DESCRIPTION

This module provides a very basic interface to libplugauth, which is a
C library that acts as a L<PlugAuth> client.

=head1 CONSTRUCTOR

=head2 new

 my $client = PlugAuth::Client::FFI->new($url);

Create a new instance of the plugauth client.  Takes exactly one argument,
which is the URL of the L<PlugAuth> server.

=cut

my $ffi = FFI::Platypus->new;
$ffi->lib(find_lib_or_die(lib => 'plugauth'));

$ffi->attach( [ 'plugauth_client_new' => '_new' ] => ['string'] => 'opaque');

sub new
{
  my($class, $url) = @_;
  my $ptr = _new($url);
  die "invalid url: @{[ $url || 'undef' ]}" unless $ptr;
  bless \$ptr, $class;
}

$ffi->attach( [ 'plugauth_client_free' => 'DESTROY' ] => ['opaque'] => 'void' => sub {
  my($sub, $self) = @_;
  $sub->($$self);
});

=head1 METHODS

=head2 get_base_url

 my $url = $client->get_base_url;

Returns the base URL for the L<PlugAuth> server.

=cut


$ffi->attach( [ 'plugauth_client_get_base_url' => 'get_base_url' ] => ['opaque'] => 'string' => sub {
  my($sub, $self) = @_;
  $sub->($$self);
});

=head2 get_auth_url

 my $url = $client->get_auth_url;

Returns the authentication URL for the L<PlugAuth> server.  This is usually the base
URL plus "/auth".

=cut

$ffi->attach( [ 'plugauth_client_get_auth_url' => 'get_auth_url' ] => ['opaque'] => 'string' => sub {
  my($sub, $self) = @_;
  $sub->($$self);
});

=head2 get_auth

 my $ret = $cient->get_auth;

Returns the authorization result to the last call to C<auth>.

=cut

$ffi->attach( [ 'plugauth_client_get_auth' => 'get_auth' ] => ['opaque'] => 'int' => sub {
  my($sub, $self) = @_;
  $sub->($$self);
});

=head2 get_error

 my $error = $client->get_error;

Returns a human readable string that describes the error in the last request.
If there is any.

=cut

$ffi->attach( [ 'plugauth_client_get_error' => 'get_error' ] => ['opaque'] => 'string' => sub {
  my($sub, $self) = @_;
  $sub->($$self);
});

use constant PLUGAUTH_NOTHING      => 000;
use constant PLUGAUTH_AUTHORIZED   => 200;
use constant PLUGAUTH_UNAUTHORIZED => 403;
use constant PLUGAUTH_ERROR        => 600;

our @EXPORT = qw( PLUGAUTH_NOTHING PLUGAUTH_AUTHORIZED PLUGAUTH_UNAUTHORIZED PLUGAUTH_ERROR );

=head2 auth

 my $ret = $client->auth($username, $password);

Returns one of:

=over 4

=item PLUGAUTH_AUTHORIZED

The user is authenticated with the given username and password.

=item PLUGAUTH_UNAUTHORIZED

The user is not authenticated with the given username and password.

=item PLUGAUTH_ERROR

The request returned an error.  See C<get_error> for a human readable rationale.

=back

These constants are exported by default when you use L<PlugAuth::Client::FFI>.  You can also
fully qualify them if you prefer.

=cut

$ffi->attach( [ 'plugauth_client_auth' => 'auth' ] => ['opaque', 'string', 'string'] => 'int' => sub {
  my($sub, $self, $user, $pass) = @_;
  my $ret = $sub->($$self, $user, $pass);
  $ret == PLUGAUTH_AUTHORIZED
    ? 1 : $ret == PLUGAUTH_UNAUTHORIZED ? 0 : die $self->get_error;
});

=head2 version

 my version = PlugAuth::Client::FFI->version;

The version of C<libplugauth> as a single integer.

=cut

$ffi->attach( [ 'plugauth_client_version_string' => 'version' ] => [] => 'string' );

=head2 version_string

 my $version = PlugAuth::Client::FFI->version_string;

The version of C<libplugauth> as a string.

=cut

$ffi->attach( [ 'plugauth_client_init' => '_init' ] => [] => 'void' );

_init();

1;
