var previousLanes = global.Lanes;

var Lanes = ( global.Lanes || (global.Lanes = {}) );

Lanes.Skr = ( Lanes.Skr || {} );

Lanes.Skr.Vendor = ( Lanes.Skr.Vendor || {} );

Lanes.Skr.Vendor.Card = require('card/src/coffee/card');
Lanes.Skr.Vendor.Payment = require('payment/src/payment');
