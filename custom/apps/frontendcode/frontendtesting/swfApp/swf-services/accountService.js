angular.module('slatwall')
    .factory('AccountFactory', ['$http', function($http) {
    var urlBase = '/index.cfm/api/scope/getAccount/?ajaxRequest=1';
    var dataFactory = {};
    var serializeJson = function(data){
    	return data = $.param({formData: JSON.stringify(data)});
    }
    
    dataFactory.$getAccount = function (errorCallbackFunction) {
        return $http.get(urlBase).error(errorCallbackFunction);
    };

    dataFactory.$updateAccount = function (errorCallbackFunction) {
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };

    dataFactory.$saveAccount = function (data, errorCallbackFunction) {
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$login = function (data, errorCallbackFunction) {
    	var urlBase = '/index.cfm/api/scope/login/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$loginGuestAccount = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/loginGuestAccount/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$logout = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/logout/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$guestAccountCreatePassword = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/guestAccountCreatePassword/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$forgotPassword = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/forgotPassword/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$createAccount = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/forgotPassword/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$resetPassword = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/forgotPassword/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$changePassword = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/changePassword/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$deleteAccountEmailAddress = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/deleteAccountEmailAddress/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$sendAccountEmailAddressVerificationEmail = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/sendAccountEmailAddressVerificationEmail/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$verifyAccountEmailAddress = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/verifyAccountEmailAddress/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$deletePhoneNumber = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/deletePhoneNumber/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$deleteAccountAddress = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/deleteAccountAddress/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$deleteAccountPaymentMethod = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/deleteAccountPaymentMethod/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$addAccountPaymentMethod = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/addAccountPaymentMethod/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$updateSubscription = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/updateSubscription/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$renewSubscription = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/renewSubscription/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$redeemGiftCard = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/redeemToAccount/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    return dataFactory;
}]);