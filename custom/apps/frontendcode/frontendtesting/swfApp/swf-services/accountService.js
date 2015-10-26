angular.module('slatwall')
    .factory('AccountFactory', ['$http', function($http) {
    
    
    var dataFactory = {};
    var formType    = {'Content-Type': 'application/x-www-form-urlencoded'};
    var toFormParams = function(data){
    	return data = $.param(data) || "";
    }
    
    dataFactory.$getAccount = function () {
    	var urlBase = '/index.cfm/api/scope/getAccount/?ajaxRequest=1';
        return $http.get(urlBase);
    };

    dataFactory.$updateAccount = function (data) {
    	var urlBase = '/index.cfm/api/scope/updateAccount/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };

    dataFactory.$saveAccount = function (data) {
    	var urlBase = '/index.cfm/api/scope/updateAccount/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$login = function (data) {
    	var urlBase = '/index.cfm/api/scope/login/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$loginGuestAccount = function (data) {
        var urlBase = '/index.cfm/api/scope/loginGuestAccount/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$logout = function () {
        var urlBase = '/index.cfm/api/scope/logout/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$guestAccountCreatePassword = function (data) {
        var urlBase = '/index.cfm/api/scope/guestAccountCreatePassword/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$forgotPassword = function (data) {
        var urlBase = '/index.cfm/api/scope/forgotPassword/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$createAccount = function (data) {
        var urlBase = '/index.cfm/api/scope/forgotPassword/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$resetPassword = function (data) {
        var urlBase = '/index.cfm/api/scope/forgotPassword/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$changePassword = function (data) {
        var urlBase = '/index.cfm/api/scope/changePassword/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$deleteAccountEmailAddress = function (data) {
        var urlBase = '/index.cfm/api/scope/deleteAccountEmailAddress/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$sendAccountEmailAddressVerificationEmail = function (data) {
        var urlBase = '/index.cfm/api/scope/sendAccountEmailAddressVerificationEmail/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$verifyAccountEmailAddress = function (data) {
        var urlBase = '/index.cfm/api/scope/verifyAccountEmailAddress/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$deletePhoneNumber = function (data) {
        var urlBase = '/index.cfm/api/scope/deletePhoneNumber/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$deleteAccountAddress = function (data) {
        var urlBase = '/index.cfm/api/scope/deleteAccountAddress/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$deleteAccountPaymentMethod = function (data) {
        var urlBase = '/index.cfm/api/scope/deleteAccountPaymentMethod/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$addAccountPaymentMethod = function (data) {
        var urlBase = '/index.cfm/api/scope/addAccountPaymentMethod/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$updateSubscription = function (data) {
        var urlBase = '/index.cfm/api/scope/updateSubscription/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$renewSubscription = function (data) {
        var urlBase = '/index.cfm/api/scope/renewSubscription/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$redeemGiftCard = function (data) {
        var urlBase = '/index.cfm/api/scope/redeemToAccount/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    return dataFactory;
}]);