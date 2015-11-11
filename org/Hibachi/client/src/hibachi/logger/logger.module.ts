/// <reference path="../../../typings/tsd.d.ts" />
/// <reference path="../../../typings/slatwallTypeScript.d.ts" />



import alertmodule = require('../alert/alert.module');
import exceptionHandler = require('./services/exceptionhandler');

export = angular.module('logger', [alertmodule.name])
.run([function() {
}])
.factory('$exceptionHandler', ['$injector', ($injector) => new exceptionHandler($injector)]);;
//angular.module('logger', []).factory('$exceptionHandler', ['$injector', ($injector) => new logger.ExceptionHandler($injector)]);




