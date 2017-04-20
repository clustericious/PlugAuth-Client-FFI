use Test2::Bundle::Extended;
use PlugAuth::Client::FFI;

my $client = PlugAuth::Client::FFI->new("http://1.2.3.4/");
isa_ok $client, 'PlugAuth::Client::FFI';
is( $client->get_base_url, 'http://1.2.3.4/' );
is( $client->get_auth_url, 'http://1.2.3.4/auth' );

ok( PLUGAUTH_AUTHORIZED, "has PLUGAUTH_AUTHORIZED" );
note "value = ", PLUGAUTH_AUTHORIZED;
ok( PLUGAUTH_UNAUTHORIZED, "has PLUGAUTH_UNAUTHORIZED" );
note "value = ", PLUGAUTH_UNAUTHORIZED;
ok( PLUGAUTH_ERROR, "has PLUGAUTH_ERROR" );
note "value = ", PLUGAUTH_ERROR;

done_testing;
