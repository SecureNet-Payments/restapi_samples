// Example of calling SecureNet Charge API from Node
var https = require('https');
var auth = 'Basic ODAwNTAyMzpwdVJsVGtMZmlVdkc='; // Replace with your auth key
var charge = {
  amount: 8.00,
  card: {
    number: '4111111111111111',
    cvv: '123',
    expirationDate: '07/2018',
    address: {
      company: 'Nov8 Inc',
      line1: '123 Main St.',
      city: 'Austin',
      state: 'TX',
      zip: '78759'
    }
  },
  extendedInformation: {
    typeOfGoods: 'PHYSICAL'
  },
  developerApplication: {
    developerId: 12345678,
    version: '1.2'
  }
};

var json = JSON.stringify(charge);                      // Convert to JSON string  
var options = {                                         // HTTP call options
  host: 'gwapi.demo.securenet.com',                     // Host address
  port: 443,                                            // SSL port
  path: '/api/Payments/Charge',                         // Path for charge API
  method: 'POST',                                       // HTTP POST request
  headers: {                                            // HTTP headers
    'Content-Type': 'application/json',                 // Body is JSON
    'Content-Length': Buffer.byteLength(json, 'utf8'),  // Necessary!
    'Authorization': auth                               // Basic auth header
  }
};

var req = https.request(options, function(res) {        // New request, with callback
  var body = '';                                        // Place for response body
  res.on('data', function(d) { body += d; });           // Collect response body data
  res.on('end', function () {                           // Act when call is complete
    var r = JSON.parse(body);                           // Convert string to object
    console.log("http response code: ", res.statusCode);
    console.log("success: " + r.success);
    console.log("result: " + r.result);
    console.log("message: " + r.message);
    console.log("transactionId: " + r.transaction.transactionId);
  });
});

req.on('error', function(e) { console.error(e); });     // Handle connection errors
req.write(json);                                        // Make the call
req.end();                                              // Close the connection
