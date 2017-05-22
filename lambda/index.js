'use strict';

exports.handler = function (event, context, callback) {
    console.log(`Processing ${JSON.stringify(event)}`);
    return callback(null, {
        message: "Done"
    });
};