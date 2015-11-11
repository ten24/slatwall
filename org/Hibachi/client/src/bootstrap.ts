/*jshint browser:true */
'use strict';

require('./vendor.ts')();
var appModule = require('./slatwall/slatwalladmin.module');
var loggerModule = require('./hibachi/logger/logger.module');
angular.bootstrap(document, [loggerModule.name,appModule.name], {
  //strictDi: true
      
});
