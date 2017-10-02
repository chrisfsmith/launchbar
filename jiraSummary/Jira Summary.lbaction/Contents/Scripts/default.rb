#!/usr/bin/env ruby
#
# See https://github.com/chrisfsmith/jira-summary
#
# LaunchBar Action Script
#
require 'yaml'
require 'net/http'
require 'json'

class Hash
  # take keys of hash and transform those to a symbols
  def self.transform_keys_to_symbols(value)
    return value if not value.is_a?(Hash)
    hash = value.inject({}) { |memo, (k, v)| memo[k.to_sym] = Hash.transform_keys_to_symbols(v); memo }
    return hash
  end
end

if File.file?(ENV['HOME']+'/.jira_sum.yaml')
  config = YAML.load_file(ENV['HOME']+'/.jira_sum.yaml')
  config = Hash.transform_keys_to_symbols(config)
=begin
YAML CONFIG EXAMPLE
---
jira:
  hostname: 'http://example.atlassian.net'
  username: 'me'
  password: 'secret'
=end
end

opts = {}

syms = [:hostname, :username, :password]
syms.each { |x|
  if config[:jira][x]
    opts[x] = config[:jira][x]
  else
    puts 'Please provide a ' + x.to_s + ' value in the config file.'
    exit 1
  end
}

if ARGV[0]
  opts[:issue] = ARGV[0]
else
  puts 'Please provide a Jira issue (e.g., TEST-1).'
  exit 1
end

# JIRA Configuration
JIRA_BASE_URL = opts[:hostname]
USERNAME = opts[:username]
PASSWORD = opts[:password]

ISSUE = opts[:issue]

#
# Get the issue summary
#
uri = URI(JIRA_BASE_URL + '/rest/api/latest/issue/' + ISSUE)

Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
  request = Net::HTTP::Get.new(uri)
  request.basic_auth USERNAME, PASSWORD
  response = http.request request

  if response.code =~ /20[0-9]{1}/
    data = JSON.parse(response.body)

    puts data["key"] + ': ' + data["fields"]["summary"]
    #puts JSON.pretty_generate(data)
  else
    raise StandardError, "Unsuccessful response code " + response.code + " for issue " + ISSUE
  end
end
