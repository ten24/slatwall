"use strict";
var slatwallAdmin;
(function(slatwallAdmin) {
  angular.module('slatwalladmin', ['ngSlatwall', 'ui.bootstrap', 'ngAnimate', 'ngRoute']).config(["$provide", '$logProvider', '$filterProvider', '$httpProvider', '$routeProvider', '$injector', '$locationProvider', 'datepickerConfig', 'datepickerPopupConfig', function($provide, $logProvider, $filterProvider, $httpProvider, $routeProvider, $injector, $locationProvider, datepickerConfig, datepickerPopupConfig) {
    datepickerConfig.showWeeks = false;
    datepickerConfig.format = 'MMM dd, yyyy hh:mm a';
    datepickerPopupConfig.toggleWeeksText = null;
    if (slatwallAngular.hashbang) {
      $locationProvider.html5Mode(false).hashPrefix('!');
    }
    $provide.constant("baseURL", $.slatwall.getConfig().baseURL);
    var _partialsPath = $.slatwall.getConfig().baseURL + '/admin/client/partials/';
    $provide.constant("partialsPath", _partialsPath);
    $provide.constant("productBundlePartialsPath", _partialsPath + 'productbundle/');
    angular.forEach(slatwallAngular.constantPaths, function(constantPath, key) {
      var constantKey = constantPath.charAt(0).toLowerCase() + constantPath.slice(1) + 'PartialsPath';
      var constantPartialsPath = _partialsPath + constantPath.toLowerCase() + '/';
      $provide.constant(constantKey, constantPartialsPath);
    });
    $logProvider.debugEnabled($.slatwall.getConfig().debugFlag);
    $filterProvider.register('likeFilter', function() {
      return function(text) {
        if (angular.isDefined(text) && angular.isString(text)) {
          return text.replace(new RegExp('%', 'g'), '');
        }
      };
    });
    $filterProvider.register('truncate', function() {
      return function(input, chars, breakOnWord) {
        if (isNaN(chars))
          return input;
        if (chars <= 0)
          return '';
        if (input && input.length > chars) {
          input = input.substring(0, chars);
          if (!breakOnWord) {
            var lastspace = input.lastIndexOf(' ');
            if (lastspace !== -1) {
              input = input.substr(0, lastspace);
            }
          } else {
            while (input.charAt(input.length - 1) === ' ') {
              input = input.substr(0, input.length - 1);
            }
          }
          return input + '...';
        }
        return input;
      };
    });
    $httpProvider.interceptors.push('slatwallInterceptor');
    $routeProvider.when('/entity/:entityName/', {
      template: function(params) {
        var entityDirectiveExists = $injector.has('sw' + params.entityName + 'ListDirective');
        if (entityDirectiveExists) {
          return '<sw-' + params.entityName.toLowerCase() + '-list>';
        } else {
          return '<sw-list></sw-list>';
        }
      },
      controller: 'routerController'
    }).when('/entity/:entityName/:entityID', {
      template: function(params) {
        var entityDirectiveExists = $injector.has('sw' + params.entityName + 'DetailDirective');
        if (entityDirectiveExists) {
          return '<sw-' + params.entityName.toLowerCase() + '-detail>';
        } else {
          return '<sw-detail></sw-detail>';
        }
      },
      controller: 'routerController'
    }).otherwise({templateUrl: $.slatwall.getConfig().baseURL + '/admin/client/js/partials/otherwise.html'});
  }]).run(['$rootScope', '$filter', '$anchorScroll', '$slatwall', 'dialogService', function($rootScope, $filter, $anchorScroll, $slatwall, dialogService) {
    $anchorScroll.yOffset = 100;
    $rootScope.openPageDialog = function(partial) {
      dialogService.addPageDialog(partial);
    };
    $rootScope.closePageDialog = function(index) {
      dialogService.removePageDialog(index);
    };
    $rootScope.loadedResourceBundle = false;
    $rootScope.loadedResourceBundle = $slatwall.hasResourceBundle();
    var rbListener = $rootScope.$watch('loadedResourceBundle', function(newValue, oldValue) {
      if (newValue !== oldValue) {
        $rootScope.$broadcast('hasResourceBundle');
        rbListener();
      }
    });
  }]).filter('entityRBKey', ['$slatwall', function($slatwall) {
    return function(text) {
      if (angular.isDefined(text) && angular.isString(text)) {
        text = text.replace('_', '').toLowerCase();
        text = $slatwall.getRBKey('entity.' + text);
        return text;
      }
    };
  }]);
})(slatwallAdmin || (slatwallAdmin = {}));

//# sourceMappingURL=../modules/slatwalladmin.js.map