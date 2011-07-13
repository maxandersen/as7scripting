#/bin/env ruby

# sudo gem install json rest-client

require 'rubygems'
require 'rest_client'
require 'json'

hash = JSON.parse(RestClient.post("http://localhost:9990/management/add-content", :file => File.new("node-info.war", 'rb')))['result']['BYTES_VALUE']

print "The uploaded hash is #{hash}\n"

RestClient.post("http://localhost:9990/management", {
  'content' => [ 'hash' => { 'BYTES_VALUE' => hash } ],
  'address' => [ 'deployment' => 'node-info.war' ],
  'operation' => 'add',
  'enabled' => 'true'
}.to_json)

print "Success!!\n"
