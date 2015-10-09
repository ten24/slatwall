/** This module wraps $.slatwall as an angular directive */
frontEndController
    .factory('$apihelper', ['$http', function($http) {
 
        var slatwallInstance = {
            account: {},
            cart: {},
            config: {
                dateFormat: 'MM/DD/YYYY',
                timeFormat: 'HH:MM',
                baseURL: '/',
                applicationKey: 'Hibachi',
                rbLocale: 'en'
            },
            setConfig: function(cfg) {
                $.extend(this.config, cfg);
            },
            getConfig: function() {
                return this.config;
            },
            getCart: function(reload, data, callBackSuccess, callBackFailure) {
                reload = reload || false;
                if (!reload && this.cart != undefined) {
                    return this.cart;
                }
                var doasync = arguments.length > 2;
                var s = callBackSuccess ||
                    function(r) {
                        result = r.cart;
                        this.cart = r.cart;
                    };
                var f = callBackFailure || s;
                var result = {};

                var request = $.ajax({
                    url: this.config.baseURL + '/index.cfm?slatAction=public:ajax.cart',
                    method: 'get',
                    async: doasync,
                    data: data,
                    dataType: 'json',
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader('X-Hibachi-AJAX', true)
                    },
                    success: s,
                    error: f
                });

                return request;
            },
            getAccount: function(reload, data, callBackSuccess, callBackFailure) {
                reload = reload || false;
                if (!reload && this.account != undefined) {
                    return this.account;
                }

                var doasync = arguments.length > 2;
                var s = callBackSuccess ||
                    function(r) {
                        result = r.account;
                        this.account = r.account;
                    };
                var f = callBackFailure || s;
                var result = {};

                $.ajax({
                    url: this.config.baseURL + '/index.cfm?slatAction=public:ajax.account',
                    method: 'get',
                    async: doasync,
                    data: data,
                    dataType: 'json',
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader('X-Hibachi-AJAX', true)
                    },
                    success: s,
                    error: f
                });

                return result;
            },
            getCollection: function(entityName, data, callBackSuccess, callBackFailure) {

                var doasync = arguments.length > 2;
                var s = callBackSuccess || function(r) {
                    result = r
                };
                var f = callBackFailure || s;
                var result = {};

                $.ajax({
                    url: this.config.baseURL + '/index.cfm?slatAction=admin:api.get&entityName=' + entityName,
                    method: 'get',
                    async: doasync,
                    dataType: 'json',
                    data: data,
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader('X-Hibachi-AJAX', true)
                    },
                    success: s,
                    error: f
                });

                return result;
            },
            getCollectionByID: function(entityName, entityID, callBackSuccess, callBackFailure) {

                var doasync = arguments.length > 2;
                var s = callBackSuccess || function(r) {
                    result = r
                };
                var f = callBackFailure || s;
                var result = {};

                $.ajax({
                    url: this.config.baseURL + '/index.cfm?slatAction=admin:api.get&entityName=' + entityName + '&entityID=' + entityID,
                    method: 'get',
                    async: doasync,
                    dataType: 'json',
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader('X-Hibachi-AJAX', true)
                    },
                    success: s,
                    error: f
                });

                return result;
            },
            /** This is a generic method for called any slataction */
            doAction: function(action, data, callBackSuccess, callBackFailure) {
                var doasync = arguments.length > 2;
                var success = callBackSuccess || function(r) {
                    result = r
                };
                var failure = callBackFailure || success;
                var result = {};

                $.ajax({
                    url: this.config.baseURL + '/index.cfm?slatAction=' + action,
                    method: 'post',
                    async: doasync,
                    data: data,
                    dataType: 'json',
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader('X-Hibachi-AJAX', true)
                    },
                    success: success,
                    error: failure
                });

                return result;
            },
            /** The remaining methods are convenience methods to make it easier to call specific slatactions */
            ajaxLogin: function(data, callBackSuccess, callBackFailure) {
                var doasync = arguments.length > 2;
                var success = callBackSuccess || function(r) {
                    result = r
                };
                var failure = callBackFailure || s;
                var result = {};

                $.ajax({
                    url: this.config.baseURL + '/index.cfm?slatAction=public:account.login',
                    method: 'post',
                    async: doasync,
                    data: data,
                    dataType: 'json',
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader('X-Hibachi-AJAX', true)
                    },
                    success: success,
                    error: failure
                });

                return result;
            },
            /** Updates and adds an order payment to an order. If billing is contained in the data, updates that as well. */
            addOrderPayment: function(data, callBackSuccess, callBackFailure) {
                var orderPaymentData = {
                    serializedJSONData: data
                };
                var doasync = arguments.length > 2;
                var success = callBackSuccess || function(r) {
                    result = r
                };
                var failure = callBackFailure || success;
                var result = {};

                $.ajax({
                    url: this.config.baseURL + '/index.cfm?slatAction=inc:main.addOrderPayment&ajaxRequest=1',
                    method: 'post',
                    async: doasync,
                    data: JSON.stringify(orderPaymentData),
                    dataType: 'json',
                    contentType: "application/json; charset=utf-8",
                    //beforeSend: function (xhr) { xhr.setRequestHeader('X-Hibachi-AJAX', true) },
                    success: success,
                    error: failure
                });

                return result;
            },
            /** Updates a subscription usage given a subscriptionUsageID */
            updateSubscriptionUsage: function(data, callBackSuccess, callBackFailure) {
                var doasync = arguments.length > 2;
                var success = callBackSuccess || function(r) {
                    result = r
                };
                var failure = callBackFailure || success;
                var result = {};

                $.ajax({
                    url: this.config.baseURL + '/index.cfm?slatAction=public:account.updateSubscriptionUsage',
                    method: 'get',
                    async: doasync,
                    data: data,
                    dataType: 'json',
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader('X-Hibachi-AJAX', true)
                    },
                    success: success,
                    error: failure
                });

                return result;
            },
            /** lookup email address by account
             */
            lookupAccountByEmailAddress: function(data, successCallback, errorCallback) {
                var _urlBase = '?slataction=inc:main.lookupAccountByEmailAddress&emailAddress=' + data.emailAddress;
                return $http({
                    method: 'GET',
                    url: _urlBase
                }).
                success(function(data) {
                    //console.log("Success Called");
                    data = angular.fromJson(data);
                    successCallback(data);
                }).
                error(function(data) {
                    //console.log("Error Called");
                    errorCallback(angular.fromJson(data));
                });
            },
            /** lookup email address by account
             */
            lookupAccountByCookie: function(data, successCallback, errorCallback) {
                var _urlBase = '?slataction=inc:main.lookupAccountByEmailAddress';
                return $http({
                    method: 'GET',
                    url: _urlBase
                }).
                success(function(data) {
                    //console.log("Success Called");
                    data = angular.fromJson(data);
                    successCallback(data);
                }).
                error(function(data) {
                    //console.log("Error Called");
                    errorCallback(angular.fromJson(data));
                });
            },
            /**get country and set the form based on that.
             */
            getStatesByCountryCode: function(data, callBackSuccess, callBackFailure) {
                var doasync = arguments.length > 2;
                var success = callBackSuccess || function(r) {
                    result = r
                };
                var failure = callBackFailure || success;
                var result = {};
                $http({
                    method: 'GET',
                    url: this.config.baseURL + '/index.cfm?slatAction=inc:main.getStatesByCountryCode' + "&countryCode=" + data + "&ajaxRequest=1",
                    data: data
                }).success(success).error(failure);

                return result;
            },
            getListOfCountries: function(callBackSuccess, callBackFailure) {
                var doasync = arguments.length > 2;
                var success = callBackSuccess || function(r) {
                    result = r
                };
                var failure = callBackFailure || success;
                var result = {};
                $http({
                    method: 'GET',
                    url: this.config.baseURL + '/index.cfm?slatAction=inc:main.getListOfCountries&ajaxRequest=1'
                }).success(success).error(failure);

                return result;
            },
            updateOrderFulfillment: function(data, callBackSuccess, callBackFailure) {
                var doasync = arguments.length > 2;
                var success = callBackSuccess || function(r) {
                    result = r
                };
                var failure = callBackFailure || success;
                var result = {};

                $.ajax({
                    url: this.config.baseURL + '/index.cfm?slatAction=inc:main.updateOrderFulfillment&ajaxRequest=1',
                    method: 'post',
                    async: doasync,
                    dataType: 'json',
                    data: data,
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader('X-Hibachi-AJAX', true)
                    },
                    success: success,
                    error: failure
                });

                return result;
            },
            /**get country and set the form based on that.
             */
            getIncAccountByAccountID: function(data, callBackSuccess, callBackFailure) {
                var doasync = arguments.length > 2;
                var success = callBackSuccess || function(r) {
                    result = r
                };
                var failure = callBackFailure || success;
                var result = {};

                $.ajax({
                    url: this.config.baseURL + '/index.cfm?slatAction=inc:main.lookupIncAccountByAccountID&accountID=641746&ajaxRequest=1',
                    method: 'get',
                    async: doasync,
                    dataType: 'json',
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader('X-Hibachi-AJAX', true) 
                    },
                    success: success,
                    error: failure
                });

                return result;
            },
            /** adds a promo to a order
             */
            addPromotionCode: function(data, successCallback, errorCallback) {

                var _urlBase = '/api/scope/addPromotionCode/?promotionCode=' + data.promotionCode + "&ajaxrequest=true";
                return $http({
                    method: 'GET',
                    url: _urlBase,
                    data: data,
                }).success(function(data, status, headers, config) {
                    successCallback(data);
                }).error(function(data, status, headers, config) {
                    errorCallback(data);
                });
            },
            /** removes a promo to a order
             */
            removePromotionCode: function(data, successCallback, errorCallback) {
                //console.log(new Date().getTime() / 1000);
                var _urlBase = '?slatAction=public:cart.removePromotionCode&promotionCodeID=' + data.promotionCodeID + "&ajaxrequest=true";
                return $http({
                    method: 'GET',
                    url: _urlBase
                }).
                success(function(data, status, headers, config) {
                    //This handles the success case.
                    //console.log(new Date().getTime() / 1000);
                    successCallback(data);
                }).
                error(function(data, status, headers, config) {
                    //This handles the error case.
                    errorCallback(data);
                });
            },
            /** login an account - working
             */
            login: function(data, successCallback, errorCallback) {
                var _urlBase = '/api/scope/login/';

                return $http({
                    url: _urlBase,
                    method: 'POST',
                    data: $.param(data),
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded'
                    },
                }).
                success(function(data, status, headers, config) {
                    successCallback(data);
                }).
                error(function(data, status, headers, config) {
                    //This handles the error case.
                    errorCallback(data);
                });
            },
            /** login an account - working
             */
            logout: function(data, successCallback, errorCallback) {
                var _urlBase = '/api/scope/logout/';
                return $http({
                    method: 'GET',
                    url: _urlBase
                }).
                success(function(data, status, headers, config) {
                    //This handles the success case.
                    successCallback(data);
                }).
                error(function(data, status, headers, config) {
                    //This handles the error case.
                    errorCallback(data);
                });
            },
            /** get orderitems 
             */
            getOrder: function(orderID, successCallback, errorCallback) {
                var _urlBase = '/api/order/' + orderID + "/";
                var data = {
                    orderID: orderID
                };
                return $http({
                    method: 'GET',
                    url: _urlBase
                }).
                success(function(data, status, headers, config) {
                    //This handles the success case.
                    successCallback(data);
                }).
                error(function(data, status, headers, config) {
                    //This handles the error case.
                    errorCallback(data);
                });
            },
            /** @description Generic Method for retrieving default account from the api.
             */
            getProducts: function(slatwallClient, successCallback, errorCallback) {
                var _urlBase = '/api/product/';
                return $http({
                    method: 'GET',
                    url: _urlBase
                }).
                success(function(data, status, headers, config) {
                    successCallback(data);
                }).
                error(function(data, status, headers, config) {
                    errorCallback(data);
                });
            },
            /** @description Grabs all the skus for a product
             */
            getSku: function(slatwallClient, successCallback, errorCallback) {
                var _urlBase = '/api/?entityName=sku&entityID=' + slatwallClient.skuID;
                return $http({
                    method: 'GET',
                    url: _urlBase
                }).
                success(function(data, status, headers, config) {
                    //This handles the success case.
                    successCallback(data);
                }).
                error(function(data, status, headers, config) {
                    //This handles the error case.
                    errorCallback(data);
                });
            },
            /** @description Grabs all the skus for a product
             */
            addOrderItem: function(slatwallClient, successCallback, errorCallback) {
                //console.log("Adding orderitem", slatwallClient.skuID, slatwallClient.quantity);
                var _urlBase = '/api/scope/?context=addOrderItem&skuID=' + slatwallClient.skuID + "&quantity=" + slatwallClient.quantity;
                return $http({
                    method: 'GET',
                    url: _urlBase
                }).
                success(function(data, status, headers, config) {
                    //This handles the success case.
                    successCallback(data);
                }).
                error(function(data, status, headers, config) {
                    //This handles the error case.
                    errorCallback(data);
                });
            }, //<--end add order item

            /** @description Adds an order payment.
             */
            addPaymentWithShipping: function(data, successCallback, errorCallback) {
                //console.log("Adding orderitem", slatwallClient.skuID, slatwallClient.quantity);
                var _urlBase = '?slataction=inc:main.addPaymentWithShipping&orderID=' + data.orderID;
                return $http({
                    method: 'GET',
                    url: _urlBase
                }).
                success(function(data, status, headers, config) {
                    //This handles the success case.
                    successCallback(data);
                }).
                error(function(data, status, headers, config) {
                    //This handles the error case.
                    errorCallback(data);
                });
            },
            /** @description Grabs all the skus for a product
             */
            removeOrderItem: function(data, successCallback, errorCallback) {
                var _urlBase = '/api/scope/removeOrderItem?orderID=' + data.orderID + "&orderItemID=" + data.orderItemID;
                return $http({
                    method: 'GET',
                    url: _urlBase
                }).
                success(function(data, status, headers, config) {
                    successCallback(data);
                }).
                error(function(data, status, headers, config) {
                    //This handles the error case.
                    errorCallback(data);
                });
            }
        };
        return slatwallInstance;
    }]);