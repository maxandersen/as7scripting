#!/usr/bin/perl
##
## in debian and its family...
## apt-get install libhttp-message-perl
## apt-get install libwww-perl
## apt-get install libjson-perl
##
## if desperate
## perl -MCPAN -e 'install HTTP::Request::Common'
## perl -MCPAN -e 'install Bundle::LWP'
## perl -MCPAN -e 'install JSON'
##
##
## Based on Jason Greene's AS7 perl video

use strict;
use warnings;
use Carp;

use HTTP::Request::Common;
use LWP::UserAgent;
use JSON;

my $filename       = 'node-info.war';
my $deploymentname = 'node-info.war';

my $ua = LWP::UserAgent->new();

my $resp = $ua->request(
    POST 'http://localhost:9990/management/add-content',
    Content_Type => 'form-data',
    Content =>
      [ file => [ $filename, Content_Type => 'application/octet-stream' ] ]
);

croak $resp->status_line
  unless $resp->is_success;

my $json = JSON->new()->allow_nonref();

my $hashref = $json->decode( $resp->decoded_content )->{'result'};

print 'The uploaded hash is ', $hashref->{BYTES_VALUE}, "\n";

my $deploy = $json->encode(
    {
        'operation' => 'add',
        'address'   => [ { 'deployment' => $deploymentname } ],
        'enabled'   => 'true',
        'content'   => [ { hash => $hashref } ]
    }
);

$resp =
  $ua->request( POST 'http://localhost:8888/management', Content => $deploy );

croak $resp->status_line
  unless $resp->is_success;

print "Success!!!\n"
