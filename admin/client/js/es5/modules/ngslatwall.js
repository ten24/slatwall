/// <reference path="../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../client/typings/slatwallTypeScript.d.ts" />
(function () {
    var ngSlatwall = angular.module('ngSlatwall', []);
})();
var ngSlatwall;
(function (ngSlatwall) {
    var $Slatwall = (function () {
        function $Slatwall() {
            //            _deferred={};
            //            _config={
            //                dateFormat : 'MM/DD/YYYY',
            //                timeFormat : 'HH:MM',
            //                rbLocale : '',
            //                baseURL : '/',
            //                applicationKey : 'Slatwall',
            //                debugFlag : true,
            //                instantiationKey : '84552B2D-A049-4460-55F23F30FE7B26AD'
            //            };
            //           if(slatwallAngular.slatwallConfig){
            //               angular.extend(this._config, slatwallAngular.slatwallConfig);
            //           }
        }
        $Slatwall.slatwallFactory = function () {
            setJsEntities = function () {
            };
        };
        $Slatwall.prototype.$get = function ($q, $http, $timeout, $log, $rootScope, $location, $anchorScroll, utilityService, formService) {
            return $Slatwall.slatwallFactory.bind($Slatwall);
        };
        return $Slatwall;
    })();
    ngSlatwall.$Slatwall = $Slatwall;
    angular.module('ngSlatwall').provider('$slatwall', $Slatwall);
})(ngSlatwall || (ngSlatwall = {}));

//# sourceMappingURL=../modules/ngslatwall.js.map