/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
module slatwalladmin {
    interface IPostFactory {
            dataFactory: {},
            GetInstance: () => {};
    }
    export class AccountFactory implements IPostFactory {
        /**
         * DataFactory contains all endpoints available to the Account Object.
         */
        dataFactory = {
            formType: {'Content-Type': 'application/x-www-form-urlencoded'},
            
            $getAccount($http):any{
            var urlBase = '/index.cfm/api/scope/getAccount/?ajaxRequest=1';
            return $http.get(urlBase);
            },

            $updateAccount(data, $http):any{
            var urlBase = '/index.cfm/api/scope/updateAccount/?ajaxRequest=1';
            return $http.post(urlBase, data.params,{headers: data.formType});
            },
    
            $saveAccount(data, $http):any{
            var urlBase = '/index.cfm/api/scope/updateAccount/?ajaxRequest=1';
            return $http.post(urlBase, data.params, {headers: data.formType});
            },
        
            $login(data, $http) {
                var urlBase = '/index.cfm/api/scope/login/?ajaxRequest=1';
                console.log("Post Method", $http, this);
                return $http.post(urlBase, data.params, {headers: data.formType});
            },
        
            $loginGuestAccount(data, $http) {
                var urlBase = '/index.cfm/api/scope/loginGuestAccount/?ajaxRequest=1';
                return $http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $logout($http) {
                var urlBase = '/index.cfm/api/scope/logout/?ajaxRequest=1';
                return $http.get(urlBase);
            },
            
            $guestAccountCreatePassword(data, $http) {
                var urlBase = '/index.cfm/api/scope/guestAccountCreatePassword/?ajaxRequest=1';
                return $http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $forgotPassword(data, $http) {
                var urlBase = '/index.cfm/api/scope/forgotPassword/?ajaxRequest=1';
                return $http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $createAccount(data, $http) {
                var urlBase = '/index.cfm/api/scope/createAccount/?ajaxRequest=1';
                return $http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $resetPassword(data, $http) {
                var urlBase = '/index.cfm/api/scope/resetPassword/?ajaxRequest=1';
                return $http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $changePassword(data, $http) {
                var urlBase = '/index.cfm/api/scope/changePassword/?ajaxRequest=1';
                return $http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $deleteAccountEmailAddress(data, $http) {
                var urlBase = '/index.cfm/api/scope/deleteAccountEmailAddress/?ajaxRequest=1';
                return $http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $sendAccountEmailAddressVerificationEmail(data, $http) {
                var urlBase = '/index.cfm/api/scope/sendAccountEmailAddressVerificationEmail/?ajaxRequest=1';
                return $http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $verifyAccountEmailAddress(data, $http) {
                var urlBase = '/index.cfm/api/scope/verifyAccountEmailAddress/?ajaxRequest=1';
                return $http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $deletePhoneNumber(data, $http) {
                var urlBase = '/index.cfm/api/scope/deletePhoneNumber/?ajaxRequest=1';
                return $http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $deleteAccountAddress(data, $http) {
                var urlBase = '/index.cfm/api/scope/deleteAccountAddress/?ajaxRequest=1';
                return $http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $addAccountPaymentMethod(data, $http) {
                var urlBase = '/index.cfm/api/scope/addAccountPaymentMethod/?ajaxRequest=1';
                return $http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $deleteAccountPaymentMethod(data, $http) {
                var urlBase = '/index.cfm/api/scope/deleteAccountPaymentMethod/?ajaxRequest=1';
                return $http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $updateSubscription(data, $http) {
                var urlBase = '/index.cfm/api/scope/updateSubscription/?ajaxRequest=1';
                return $http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $renewSubscription(data, $http) {
                var urlBase = '/index.cfm/api/scope/renewSubscription/?ajaxRequest=1';
                return $http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $redeemGiftCard(data, $http) {
                var urlBase = '/index.cfm/api/scope/redeemToAccount/?ajaxRequest=1';
                return $http.post(urlBase,data.params, {headers: data.formType});
            },
            toFormParams(data){
                return data = $.param(data) || "";
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
    angular.module('slatwalladmin').service('AccountFactory',['$http',($http) => new AccountFactory()]);
}

