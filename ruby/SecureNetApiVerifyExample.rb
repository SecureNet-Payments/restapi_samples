#!/usr/bin/ruby
# Example of calling SecureNet Verify API from Ruby
require 'net/http'
require 'uri'
require 'json'

url = 'https://gwapi.demo.securenet.com/api/'
secureNetId = '8005023' # Replace with your own ID
secureKey = 'puRlTkLfiUvG' # Replace with your own Key

def post_request(secureNetId, secureKey, url)
  uri = URI.parse(url)                       # Parse the URI
  http = Net::HTTP.new(uri.host, uri.port)   # New HTTP connection
  http.use_ssl = true                        # Must use SSL!
  req = Net::HTTP::Post.new(uri.request_uri) # HTTP POST request 
  body = {}                                  # Request body hash
  yield body                                 # Build body of request
  req.body = body.to_json                    # Convert hash to json string
  req["Content-Type"] = 'application/json'   # JSON body
  req.basic_auth secureNetId, secureKey      # HTTP basic auth
  res = http.request(req)                    # Make the call
  return JSON.parse(res.body)                # Convert JSON to hashmap
end

puts "Sending verify request"
res = post_request(secureNetId, secureKey, url + 'payments/verify') { |body| 
  body.merge!({
    amount: 0,
    card: {
      number: '4444333322221111',
      cvv: '999',
      expirationDate: '04/2016',
      address: {
        line1: '123 Main St.',
        city: 'Austin',
        state: 'TX',
        zip: '78759'
      }
    },
    extendedInformation: {
      typeOfGoods: 'PHYSICAL',
    },
    developerApplication: {
      developerId: 12345678,
      version: '1.2'
    }
  })
}

puts "success: #{res["success"]}"
puts "result: #{res["result"]}"
puts "message: #{res["message"]}"
