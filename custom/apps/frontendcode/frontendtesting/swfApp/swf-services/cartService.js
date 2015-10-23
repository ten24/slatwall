angular.module('slatwall')
    .factory('CartFactory', ['$http', function($http) {
    var urlBase = '/index.cfm/api/scope/getCart/?ajaxRequest=1';
    var dataFactory = {};
    var serializeJson = function(data){
        return data = $.param({json: JSON.stringify(data)});
    }
    
    dataFactory.$getCart = function (errorCallbackFunction) {
        return $http.get(urlBase).error(errorCallbackFunction);
    };
    
    dataFactory.$getOrder = function (errorCallbackFunction) {
        return $http.get(urlBase).error(errorCallbackFunction);
    };
    
    dataFactory.$updateOrder = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/updateOrder/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$clearOrder = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/clearOrder/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$changeOrder = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/changeOrder/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$deleteOrder = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/deleteOrder/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$placeOrder = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/placeOrder/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$duplicateOrder = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/duplicateOrder/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$addOrderItem = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/addOrderItem/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$removeOrderItem = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/removeOrderItem/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$updateOrderFulfillment = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/updateOrderFulfillment/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$updateOrderFulfillment = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/updateOrderFulfillment/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$addPromotionCode = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/addPromotionCode/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$removePromotionCode = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/removePromotionCode/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$addOrderPayment = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/addOrderPayment/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$removeOrderPayment = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/removeOrderPayment/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    dataFactory.$addProductReview = function (data, errorCallbackFunction) {
        var urlBase = '/index.cfm/api/scope/addProductReview/?ajaxRequest=1';
        return $http.post(urlBase, serializeJson(data)).error(errorCallbackFunction);
    };
    
    return dataFactory;
}]);