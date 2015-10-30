var module = angular.module('slatwall', ['ngResource', 'hibachi']).run(function() {})
.factory('$exceptionHandler', function() {
  return function(exception, cause) {
    exception.message += ' (caused by "' + cause + '")';
    throw exception;
  };
});

module.paths = {
    root: '/custom/apps/frontendcode/frontendtesting/swfApp/',
    partials: '/custom/apps/frontendcode/frontendtesting/swfApp/swf-directive-partials/'
};

module.constant('ROOT', module.paths.root);
module.constant('PARTIALS', module.paths.partials);
