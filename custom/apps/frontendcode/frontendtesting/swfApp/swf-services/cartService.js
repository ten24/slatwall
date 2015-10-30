angular.module('slatwall')
    .factory('CartFactory', ['$http', function($http) {
    
    var dataFactory = {};
    var formType    = {'Content-Type': 'application/x-www-form-urlencoded'};
    var toFormParams = function(data){
        return data = $.param(data) || "";
    }
    
    dataFactory.$getCart = function () {
    	var urlBase = '/index.cfm/api/scope/getCart/?ajaxRequest=1';
        return $http.get(urlBase);
    };
    
    dataFactory.$getOrder = function () {
    	var urlBase = '/index.cfm/api/scope/getCart/?ajaxRequest=1';
        return $http.get(urlBase);
    };
    
    dataFactory.$updateOrder = function (data) {
        var urlBase = '/index.cfm/api/scope/updateOrder/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$clearOrder = function (data) {
        var urlBase = '/index.cfm/api/scope/clearOrder/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$changeOrder = function (data) {
        var urlBase = '/index.cfm/api/scope/changeOrder/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$deleteOrder = function (data) {
        var urlBase = '/index.cfm/api/scope/deleteOrder/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$placeOrder = function (data) {
        var urlBase = '/index.cfm/api/scope/placeOrder/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$duplicateOrder = function (data) {
        var urlBase = '/index.cfm/api/scope/duplicateOrder/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$addOrderItem = function (data) {
        var urlBase = '/index.cfm/api/scope/addOrderItem/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$removeOrderItem = function (data) {
        var urlBase = '/index.cfm/api/scope/removeOrderItem/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$updateOrderFulfillment = function (data) {
        var urlBase = '/index.cfm/api/scope/updateOrderFulfillment/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$updateOrderFulfillment = function (data) {
        var urlBase = '/index.cfm/api/scope/updateOrderFulfillment/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$addPromotionCode = function (data) {
        var urlBase = '/index.cfm/api/scope/addPromotionCode/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$removePromotionCode = function (data) {
        var urlBase = '/index.cfm/api/scope/removePromotionCode/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$addOrderPayment = function (data) {
        var urlBase = '/index.cfm/api/scope/addOrderPayment/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$removeOrderPayment = function (data) {
        var urlBase = '/index.cfm/api/scope/removeOrderPayment/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    dataFactory.$addProductReview = function (data) {
        var urlBase = '/index.cfm/api/scope/addProductReview/?ajaxRequest=1';
        return $http.post(urlBase, toFormParams(data), {headers: formType});
    };
    
    return dataFactory;
}]);