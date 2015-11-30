var module = angular.module('slatwall', ['hibachi']).run(function() {})
.factory('$exceptionHandler', function() {
  return function(exception, cause) {
    exception.message += ' (caused by "' + cause + '")';
    throw exception;
  };
});

module.paths = {
    root: '/custom/apps/frontendcode/frontendtesting/slatwallFrontendLibrary/',
    partials: '/custom/apps/frontendcode/frontendtesting/slatwallFrontendLibrary/swf-directive-partials/'
};

module.constant('appRoot', module.paths.root);
module.constant('partialsPath', module.paths.partials);
