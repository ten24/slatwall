/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
module slatwalladmin {
    interface IPostFactory {
            dataFactory: {},
            GetInstance: () => {};
    }
    export class CartFactory implements IPostFactory {
        /**
         * DataFactory contains all endpoints available to the Account Object.
         */
        dataFactory = {
            formType: {'Content-Type': 'application/x-www-form-urlencoded'},
            
            $getCart ($http) {
                    var urlBase = '/index.cfm/api/scope/getCart/?ajaxRequest=1';
                   return $http.get(urlBase);
            },
                
            $getOrder ($http) {
                var urlBase = '/index.cfm/api/scope/getCart/?ajaxRequest=1';
                return $http.get(urlBase);
            },
            
            $updateOrder (data, $http) {
                var urlBase = '/index.cfm/api/scope/updateOrder/?ajaxRequest=1';
                return $http.post(urlBase, data.params, {headers: data.formType});
            },
            
            $clearOrder (data, $http) {
                var urlBase = '/index.cfm/api/scope/clearOrder/?ajaxRequest=1';
                return $http.post(urlBase, data.params, {headers: data.formType});
            },
            
            $changeOrder (data, $http) {
                var urlBase = '/index.cfm/api/scope/changeOrder/?ajaxRequest=1';
                return $http.post(urlBase, data.params, {headers: data.formType});
            },
            
            $deleteOrder (data, $http) {
                var urlBase = '/index.cfm/api/scope/deleteOrder/?ajaxRequest=1';
                return $http.post(urlBase, data.params, {headers: data.formType});
            },
            
            $placeOrder (data, $http) {
                var urlBase = '/index.cfm/api/scope/placeOrder/?ajaxRequest=1';
                return $http.post(urlBase, data.params, {headers: data.formType});
            },
            
            $duplicateOrder (data, $http) {
                var urlBase = '/index.cfm/api/scope/duplicateOrder/?ajaxRequest=1';
                return $http.post(urlBase, data.params, {headers: data.formType});
            },
            
            $addOrderItem (data, $http) {
                var urlBase = '/index.cfm/api/scope/addOrderItem/?ajaxRequest=1';
                return $http.post(urlBase, data.params, {headers: data.formType});
            },
            
            $removeOrderItem (data, $http) {
                var urlBase = '/index.cfm/api/scope/removeOrderItem/?ajaxRequest=1';
                return $http.post(urlBase, data.params, {headers: data.formType});
            },
            
            $updateOrderFulfillment(data, $http) {
                var urlBase = '/index.cfm/api/scope/updateOrderFulfillment/?ajaxRequest=1';
                return $http.post(urlBase, data.params, {headers: data.formType});
            },
            
            $addPromotionCode (data, $http) {
                var urlBase = '/index.cfm/api/scope/addPromotionCode/?ajaxRequest=1';
                return $http.post(urlBase, data.params, {headers: data.formType});
            },
            
            $removePromotionCode (data, $http) {
                var urlBase = '/index.cfm/api/scope/removePromotionCode/?ajaxRequest=1';
                return $http.post(urlBase, data.params, {headers: data.formType});
            },
            
            $addOrderPayment (data, $http) {
                var urlBase = '/index.cfm/api/scope/addOrderPayment/?ajaxRequest=1';
                return $http.post(urlBase, data.params, {headers: data.formType});
            },
            
            $removeOrderPayment (data, $http) {
                var urlBase = '/index.cfm/api/scope/removeOrderPayment/?ajaxRequest=1';
                return $http.post(urlBase, data.params, {headers: data.formType});
            },
            
            $addProductReview (data, $http) {
                var urlBase = '/index.cfm/api/scope/addProductReview/?ajaxRequest=1';
                return $http.post(urlBase, data.params, {headers: data.formType});
            },
            toFormParams(data, $http){
                return data = $.param(data, $http) || "";
            }
            
            
        };
        
        constructor() {}

        /**
         * Returns an instance of the dataFactory
         */
        GetInstance = (): {} =>{
            return this.dataFactory;
        }

    }
    angular.module('slatwalladmin').service('CartFactory',['$http',($http) => new CartFactory()]);
}





    