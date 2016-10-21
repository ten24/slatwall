"use strict";
var hibachiinterceptor_1 = require("./services/hibachiinterceptor");
var hibachipathbuilder_1 = require("./services/hibachipathbuilder");
var publicservice_1 = require("./services/publicservice");
var accountservice_1 = require("./services/accountservice");
var cartservice_1 = require("./services/cartservice");
var utilityservice_1 = require("./services/utilityservice");
var selectionservice_1 = require("./services/selectionservice");
var observerservice_1 = require("./services/observerservice");
var orderservice_1 = require("./services/orderservice");
var orderpaymentservice_1 = require("./services/orderpaymentservice");
var formservice_1 = require("./services/formservice");
var expandableservice_1 = require("./services/expandableservice");
var metadataservice_1 = require("./services/metadataservice");
var rbkeyservice_1 = require("./services/rbkeyservice");
var hibachiservice_1 = require("./services/hibachiservice");
var localstorageservice_1 = require("./services/localstorageservice");
var hibachiservicedecorator_1 = require("./services/hibachiservicedecorator");
var hibachiscope_1 = require("./services/hibachiscope");
var requestservice_1 = require("./services/requestservice");
var hibachivalidationservice_1 = require("./services/hibachivalidationservice");
var entityservice_1 = require("./services/entityservice");
var globalsearch_1 = require("./controllers/globalsearch");
var percentage_1 = require("./filters/percentage");
var entityrbkey_1 = require("./filters/entityrbkey");
var swtrim_1 = require("./filters/swtrim");
var datefilter_1 = require("./filters/datefilter");
var swactioncaller_1 = require("./components/swactioncaller");
var swtypeaheadsearch_1 = require("./components/swtypeaheadsearch");
var swtypeaheadinputfield_1 = require("./components/swtypeaheadinputfield");
var swtypeaheadsearchlineitem_1 = require("./components/swtypeaheadsearchlineitem");
var swcollectionconfig_1 = require("./components/swcollectionconfig");
var swcollectionfilter_1 = require("./components/swcollectionfilter");
var swcollectioncolumn_1 = require("./components/swcollectioncolumn");
var swactioncallerdropdown_1 = require("./components/swactioncallerdropdown");
var swcolumnsorter_1 = require("./components/swcolumnsorter");
var swconfirm_1 = require("./components/swconfirm");
var swentityactionbar_1 = require("./components/swentityactionbar");
var swentityactionbarbuttongroup_1 = require("./components/swentityactionbarbuttongroup");
var swexpandablerecord_1 = require("./components/swexpandablerecord");
var swgravatar_1 = require("./components/swgravatar");
var swlistingdisplay_1 = require("./components/swlistingdisplay");
var swlistingcontrols_1 = require("./components/swlistingcontrols");
var swlistingaggregate_1 = require("./components/swlistingaggregate");
var swlistingcolorfilter_1 = require("./components/swlistingcolorfilter");
var swlistingcolumn_1 = require("./components/swlistingcolumn");
var swlistingfilter_1 = require("./components/swlistingfilter");
var swlistingfiltergroup_1 = require("./components/swlistingfiltergroup");
var swlistingorderby_1 = require("./components/swlistingorderby");
var swlogin_1 = require("./components/swlogin");
var swnumbersonly_1 = require("./components/swnumbersonly");
var swloading_1 = require("./components/swloading");
var swscrolltrigger_1 = require("./components/swscrolltrigger");
var swtooltip_1 = require("./components/swtooltip");
var swrbkey_1 = require("./components/swrbkey");
var swoptions_1 = require("./components/swoptions");
var swselection_1 = require("./components/swselection");
var swclickoutside_1 = require("./components/swclickoutside");
var swdirective_1 = require("./components/swdirective");
var swexportaction_1 = require("./components/swexportaction");
var swhref_1 = require("./components/swhref");
var swprocesscaller_1 = require("./components/swprocesscaller");
var swsortable_1 = require("./components/swsortable");
var swlistingglobalsearch_1 = require("./components/swlistingglobalsearch");
var coremodule = angular.module('hibachi.core', [
    'ngAnimate',
    'ngSanitize',
    'ui.bootstrap'
]).config(['$httpProvider', '$logProvider', '$filterProvider', '$provide', 'hibachiPathBuilder', 'appConfig', function ($httpProvider, $logProvider, $filterProvider, $provide, hibachiPathBuilder, appConfig) {
        hibachiPathBuilder.setBaseURL(appConfig.baseURL);
        hibachiPathBuilder.setBasePartialsPath('/org/Hibachi/client/src/');
        $logProvider.debugEnabled(appConfig.debugFlag);
        $filterProvider.register('likeFilter', function () {
            return function (text) {
                if (angular.isDefined(text) && angular.isString(text)) {
                    return text.replace(new RegExp('%', 'g'), '');
                }
            };
        });
        $filterProvider.register('truncate', function () {
            return function (input, chars, breakOnWord) {
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
                    }
                    else {
                        while (input.charAt(input.length - 1) === ' ') {
                            input = input.substr(0, input.length - 1);
                        }
                    }
                    return input + '...';
                }
                return input;
            };
        });
        $filterProvider.register('pretruncate', function () {
            return function (input, chars, breakOnWord) {
                if (isNaN(chars))
                    return input;
                if (chars <= 0)
                    return '';
                if (input && input.length > chars) {
                    input = input.slice('-' + chars);
                    if (!breakOnWord) {
                        var lastspace = input.lastIndexOf(' ');
                        if (lastspace !== -1) {
                            input = input.substr(0, lastspace);
                        }
                    }
                    else {
                        while (input.charAt(input.length - 1) === ' ') {
                            input = input.substr(0, input.length - 1);
                        }
                    }
                    return '...' + input;
                }
                return input;
            };
        });
        hibachiPathBuilder.setBaseURL(appConfig.baseURL);
        hibachiPathBuilder.setBasePartialsPath('/org/Hibachi/client/src/');
        $httpProvider.interceptors.push('hibachiInterceptor');
    }])
    .run(['$rootScope', '$hibachi', '$route', '$location', function ($rootScope, $hibachi, $route, $location) {
        $rootScope.buildUrl = $hibachi.buildUrl;
        var original = $location.path;
        $location.path = function (path, reload) {
            if (reload === false) {
                var lastRoute = $route.current;
                var un = $rootScope.$on('$locationChangeSuccess', function () {
                    $route.current = lastRoute;
                    un();
                });
            }
            return original.apply($location, [path]);
        };
    }])
    .constant('hibachiPathBuilder', new hibachipathbuilder_1.HibachiPathBuilder())
    .constant('corePartialsPath', 'core/components/')
    .service('publicService', publicservice_1.PublicService)
    .service('utilityService', utilityservice_1.UtilityService)
    .service('selectionService', selectionservice_1.SelectionService)
    .service('observerService', observerservice_1.ObserverService)
    .service('expandableService', expandableservice_1.ExpandableService)
    .service('formService', formservice_1.FormService)
    .service('metadataService', metadataservice_1.MetaDataService)
    .service('rbkeyService', rbkeyservice_1.RbKeyService)
    .provider('$hibachi', hibachiservice_1.$Hibachi)
    .decorator('$hibachi', hibachiservicedecorator_1.HibachiServiceDecorator)
    .service('hibachiInterceptor', hibachiinterceptor_1.HibachiInterceptor.Factory())
    .service('hibachiScope', hibachiscope_1.HibachiScope)
    .service('localStorageService', localstorageservice_1.LocalStorageService)
    .service('requestService', requestservice_1.RequestService)
    .service('accountService', accountservice_1.AccountService)
    .service('orderService', orderservice_1.OrderService)
    .service('orderPaymentService', orderpaymentservice_1.OrderPaymentService)
    .service('cartService', cartservice_1.CartService)
    .service('hibachiValidationService', hibachivalidationservice_1.HibachiValidationService)
    .service('entityService', entityservice_1.EntityService)
    .controller('globalSearch', globalsearch_1.GlobalSearchController)
    .filter('dateFilter', ['$filter', datefilter_1.DateFilter.Factory])
    .filter('percentage', [percentage_1.PercentageFilter.Factory])
    .filter('trim', [swtrim_1.SWTrim.Factory])
    .filter('entityRBKey', ['rbkeyService', entityrbkey_1.EntityRBKey.Factory])
    .directive('swCollectionConfig', swcollectionconfig_1.SWCollectionConfig.Factory())
    .directive('swCollectionColumn', swcollectioncolumn_1.SWCollectionColumn.Factory())
    .directive('swCollectionFilter', swcollectionfilter_1.SWCollectionFilter.Factory())
    .directive('swTypeaheadSearch', swtypeaheadsearch_1.SWTypeaheadSearch.Factory())
    .directive('swTypeaheadInputField', swtypeaheadinputfield_1.SWTypeaheadInputField.Factory())
    .directive('swTypeaheadSearchLineItem', swtypeaheadsearchlineitem_1.SWTypeaheadSearchLineItem.Factory())
    .directive('swActionCaller', swactioncaller_1.SWActionCaller.Factory())
    .directive('swActionCallerDropdown', swactioncallerdropdown_1.SWActionCallerDropdown.Factory())
    .directive('swColumnSorter', swcolumnsorter_1.SWColumnSorter.Factory())
    .directive('swConfirm', swconfirm_1.SWConfirm.Factory())
    .directive('swEntityActionBar', swentityactionbar_1.SWEntityActionBar.Factory())
    .directive('swEntityActionBarButtonGroup', swentityactionbarbuttongroup_1.SWEntityActionBarButtonGroup.Factory())
    .directive('swExpandableRecord', swexpandablerecord_1.SWExpandableRecord.Factory())
    .directive('swGravatar', swgravatar_1.SWGravatar.Factory())
    .directive('swListingDisplay', swlistingdisplay_1.SWListingDisplay.Factory())
    .directive('swListingControls', swlistingcontrols_1.SWListingControls.Factory())
    .directive('swListingAggregate', swlistingaggregate_1.SWListingAggregate.Factory())
    .directive('swListingColorFilter', swlistingcolorfilter_1.SWListingColorFilter.Factory())
    .directive('swListingColumn', swlistingcolumn_1.SWListingColumn.Factory())
    .directive('swListingFilter', swlistingfilter_1.SWListingFilter.Factory())
    .directive('swListingFilterGroup', swlistingfiltergroup_1.SWListingFilterGroup.Factory())
    .directive('swListingOrderBy', swlistingorderby_1.SWListingOrderBy.Factory())
    .directive('swLogin', swlogin_1.SWLogin.Factory())
    .directive('swNumbersOnly', swnumbersonly_1.SWNumbersOnly.Factory())
    .directive('swLoading', swloading_1.SWLoading.Factory())
    .directive('swScrollTrigger', swscrolltrigger_1.SWScrollTrigger.Factory())
    .directive('swRbkey', swrbkey_1.SWRbKey.Factory())
    .directive('swOptions', swoptions_1.SWOptions.Factory())
    .directive('swSelection', swselection_1.SWSelection.Factory())
    .directive('swTooltip', swtooltip_1.SWTooltip.Factory())
    .directive('swClickOutside', swclickoutside_1.SWClickOutside.Factory())
    .directive('swDirective', swdirective_1.SWDirective.Factory())
    .directive('swExportAction', swexportaction_1.SWExportAction.Factory())
    .directive('swHref', swhref_1.SWHref.Factory())
    .directive('swProcessCaller', swprocesscaller_1.SWProcessCaller.Factory())
    .directive('sw:sortable', swsortable_1.SWSortable.Factory())
    .directive('swListingGlobalSearch', swlistingglobalsearch_1.SWListingGlobalSearch.Factory());
exports.coremodule = coremodule;
//# sourceMappingURL=core.module.js.map