## 
## perl -MCPAN -e 'install HTTP::Request::Common'
## perl -MCPAN -e 'install Bundle::LWP'
## perl -MCPAN -e 'install JSON'
##

use HTTP::Request::Common;
use LWP::UserAgent;
use JSON;

$filename = 'pastecode.war';
$deploymentname = 'pastecode.war';

$ua = LWP::UserAgent->new;

$resp = $ua->request(POST 'http://localhost:9990/management/add-content',
                                    Content_Type => 'form-data',
                                    Content => [file => [$filename, Content_Type => "application/octet-stream"]]);

die $resp->status_line if ! $resp->is_success;

$json = JSON->new->allow_nonref;

$hash = \%{$json->decode($resp->decoded_content)->{'result'}};

print "The uploaded hash is " . $hash->{'BYTES_VALUE'} . "\n";

$deploy = $json->encode({"operation" => "add",
	  			     	    "address" => [{"deployment" => $deploymentname}],
                                            "enabled" => "true",
                                            "content" => [{hash => $hash}]});

$resp = $ua->request(POST 'http://localhost:8888/management', Content=>$deploy);

die $resp->status_line if ! $resp->is_success;
print "Success!!!\n"
