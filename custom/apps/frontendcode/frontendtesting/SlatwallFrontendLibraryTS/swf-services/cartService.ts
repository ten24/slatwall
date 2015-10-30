/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwallFrontend {
    export interface IPostFactory {
            dataFactory: {},
            formType: {},
            toFormParams: (data?:any) => any;
            Get: () => {};
    }
    export class CartFactory implements IPostFactory {
        /**
         * DataFactory contains all endpoints available to the Account Object.
         */
        dataFactory = {
                $getCart () {
                    var urlBase = '/index.cfm/api/scope/getCart/?ajaxRequest=1';
                   return this.http.get(urlBase);
                },
                
                $getOrder () {
                    var urlBase = '/index.cfm/api/scope/getCart/?ajaxRequest=1';
                   return this.http.get(urlBase);
                },
                
                $updateOrder (data) {
                    var urlBase = '/index.cfm/api/scope/updateOrder/?ajaxRequest=1';
                   return this.http.post(urlBase, this.toFormParams(data), {headers: this.formType});
                },
                
                $clearOrder (data) {
                    var urlBase = '/index.cfm/api/scope/clearOrder/?ajaxRequest=1';
                   return this.http.post(urlBase, this.toFormParams(data), {headers: this.formType});
                },
                
                $changeOrder (data) {
                    var urlBase = '/index.cfm/api/scope/changeOrder/?ajaxRequest=1';
                   return this.http.post(urlBase, this.toFormParams(data), {headers: this.formType});
                },
                
                $deleteOrder (data) {
                    var urlBase = '/index.cfm/api/scope/deleteOrder/?ajaxRequest=1';
                   return this.http.post(urlBase, this.toFormParams(data), {headers: this.formType});
                },
                
                $placeOrder (data) {
                    var urlBase = '/index.cfm/api/scope/placeOrder/?ajaxRequest=1';
                   return this.http.post(urlBase, this.toFormParams(data), {headers: this.formType});
                },
                
                $duplicateOrder (data) {
                    var urlBase = '/index.cfm/api/scope/duplicateOrder/?ajaxRequest=1';
                   return this.http.post(urlBase, this.toFormParams(data), {headers: this.formType});
                },
                
                $addOrderItem (data) {
                    var urlBase = '/index.cfm/api/scope/addOrderItem/?ajaxRequest=1';
                   return this.http.post(urlBase, this.toFormParams(data), {headers: this.formType});
                },
                
                $removeOrderItem (data) {
                    var urlBase = '/index.cfm/api/scope/removeOrderItem/?ajaxRequest=1';
                   return this.http.post(urlBase, this.toFormParams(data), {headers: this.formType});
                },
                
                $updateOrderFulfillment(data) {
                    var urlBase = '/index.cfm/api/scope/updateOrderFulfillment/?ajaxRequest=1';
                   return this.http.post(urlBase, this.toFormParams(data), {headers: this.formType});
                },
                
                $addPromotionCode (data) {
                    var urlBase = '/index.cfm/api/scope/addPromotionCode/?ajaxRequest=1';
                   return this.http.post(urlBase, this.toFormParams(data), {headers: this.formType});
                },
                
                $removePromotionCode (data) {
                    var urlBase = '/index.cfm/api/scope/removePromotionCode/?ajaxRequest=1';
                   return this.http.post(urlBase, this.toFormParams(data), {headers: this.formType});
                },
                
                $addOrderPayment (data) {
                    var urlBase = '/index.cfm/api/scope/addOrderPayment/?ajaxRequest=1';
                   return this.http.post(urlBase, this.toFormParams(data), {headers: this.formType});
                },
                
                $removeOrderPayment (data) {
                    var urlBase = '/index.cfm/api/scope/removeOrderPayment/?ajaxRequest=1';
                   return this.http.post(urlBase, this.toFormParams(data), {headers: this.formType});
                },
                
                $addProductReview (data) {
                    var urlBase = '/index.cfm/api/scope/addProductReview/?ajaxRequest=1';
                   return this.http.post(urlBase, this.toFormParams(data), {headers: this.formType});
                }
        };
        
        formType    = {'Content-Type': 'application/x-www-form-urlencoded'},
        toFormParams(data){
            return data = $.param(data) || "";
        }
        private http: ng.IHttpService;
        static $inject = ['$http'];
        
        constructor($http: ng.IHttpService) {
            this.http = $http;
        }

        /**
         * Returns an instance of the dataFactory
         */
        Get(): {} {
            return this.dataFactory;
        }
    }
    angular.module('slatwallFrontend').service('CartFactory',['$http',($http) => new CartFactory($http)]);
}