# PlugAuth::Client::FFI [![Build Status](https://secure.travis-ci.org/plicease/PlugAuth-Client-FFI.png)](http://travis-ci.org/plicease/PlugAuth-Client-FFI)

PlugAuth client based on libplugauth via FFI

# SYNOPSIS

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

# DESCRIPTION

This module provides a very basic interface to libplugauth, which is a
C library that acts as a [PlugAuth](https://metacpan.org/pod/PlugAuth) client.

# CONSTRUCTOR

## new

    my $client = PlugAuth::Client::FFI->new($url);

Create a new instance of the plugauth client.  Takes exactly one argument,
which is the URL of the [PlugAuth](https://metacpan.org/pod/PlugAuth) server.

# METHODS

## get\_base\_url

    my $url = $client->get_base_url;

Returns the base URL for the [PlugAuth](https://metacpan.org/pod/PlugAuth) server.

## get\_auth\_url

    my $url = $client->get_auth_url;

Returns the authentication URL for the [PlugAuth](https://metacpan.org/pod/PlugAuth) server.  This is usually the base
URL plus "/auth".

## get\_auth

    my $ret = $cient->get_auth;

Returns the authorization result to the last call to `auth`.

## get\_error

    my $error = $client->get_error;

Returns a human readable string that describes the error in the last request.
If there is any.

## auth

    my $ret = $client->auth($username, $password);

Returns one of:

- PLUGAUTH\_AUTHORIZED

    The user is authenticated with the given username and password.

- PLUGAUTH\_UNAUTHORIZED

    The user is not authenticated with the given username and password.

- PLUGAUTH\_ERROR

    The request returned an error.  See `get_error` for a human readable rationale.

These constants are exported by default when you use [PlugAuth::Client::FFI](https://metacpan.org/pod/PlugAuth::Client::FFI).  You can also
fully qualify them if you prefer.

## version

    my version = PlugAuth::Client::FFI->version;

The version of `libplugauth` as a single integer.

## version\_string

    my $version = PlugAuth::Client::FFI->version_string;

The version of `libplugauth` as a string.

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
