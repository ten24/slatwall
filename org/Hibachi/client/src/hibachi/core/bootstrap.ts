/*jshint browser:true */
'use strict';

require('./vendor.ts')();
var appModule = require('../hibachi.module');
var loggerModule = require('../logger/logger.module');
angular.bootstrap(document, [loggerModule.name,appModule.name], {
  //strictDi: true
      
});
