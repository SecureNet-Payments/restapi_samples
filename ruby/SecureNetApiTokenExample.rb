#!/usr/bin/ruby
# Example of calling SecureNet Token API from Ruby
# Step 1 - Create a temporary token for a card
# Step 2 - Execute a charge transaction using the token
require 'net/http'
require 'uri'
require 'json'

url = 'https://gwapi.demo.securenet.com/api/'      # Root URL for REST calls
secureNetId = '8005023'                            # Replace with your own ID
secureKey = 'puRlTkLfiUvG'                         # Replace with your own Key
publicKey = '2c28646f-abc4-48f9-af60-6060e5f533d8' # Replace with your own pubic key from VT

# Simplify making a POST request
def post_request(secureNetId, secureKey, url)
  uri = URI.parse(url)                       # Parse the URI
  http = Net::HTTP.new(uri.host, uri.port)   # New HTTP connection
  http.use_ssl = true                        # Must use SSL!
  req = Net::HTTP::Post.new(uri.request_uri) # HTTP POST request 
  body = {}                                  # Request body hash
  yield body                                 # Build body of request
  req.body = body.to_json                    # Convert hash to json string
  req["Content-Type"] = 'application/json'   # JSON body
  req["Origin"] = 'worldpay.com'             # CORS origin
  req.basic_auth secureNetId, secureKey      # HTTP basic auth
  res = http.request(req)                    # Make the call
  return JSON.parse(res.body)                # Convert JSON to hashmap
end

# Step 1 - Create a temporary token
puts "Sending token request"
token_res = post_request(secureNetId, secureKey, url + 'prevault/card') { |body| 
  body.merge!({
    publicKey: publicKey,
    card: {
      number: '4111111111111111',
      cvv: '123',
      expirationDate: '07/2018',
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
    },
    addToVault: false
  })
}

puts "success: #{token_res["success"]}"
puts "result: #{token_res["result"]}"
puts "message: #{token_res["message"]}"
puts "token: #{token_res["token"]}"

# Step 2 - Charge using the token
if token_res["success"]
  puts "Sending charge using token"
  charge_res = post_request(secureNetId, secureKey, url + 'payments/authorize') { |body| 
    body.merge!({
      amount: 11.00,
      paymentVaultToken: {
        paymentMethodId: token_res["token"],
        publicKey: publicKey
      },
      developerApplication: {
        developerId: 12345678,
        version: '1.2'
      }
    })
  }

  puts "success: #{charge_res["success"]}"
  puts "result: #{charge_res["result"]}"
  puts "message: #{charge_res["message"]}"
  puts "transactionId: #{charge_res["transaction"]["transactionId"]}"
end

