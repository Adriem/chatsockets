// =============================================================================
//  This file is the entry point for the whole application.
// =============================================================================

"use strict";
require('coffee-script/register'); //Enable coffeescript requiring files

var readline = require('readline');

var server = require('./server/index');
var port   = process.env.PORT || 3000;

// If on windows, emit SIGINT on ^C from stdin, watch
// http://stackoverflow.com/a/14861513/3376793 for more info
if (process.platform === 'win32') {
    var lineReader = readline.createInterface({
        input  : process.stdin,
        output : process.stdout
    });
    lineReader.on('SIGINT', function() { process.emit('SIGINT'); })
}

// Properly close server on Ctrl-c
process.on('SIGINT', function() {
    console.log("Closing server")
    server.close();
    process.exit();
});

// Start server
server.start(port);
console.log("Something beautiful is happening on port " + port);
