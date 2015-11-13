/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
module slatwalladmin {
    interface IPostFactory {
            dataFactory: {},
            GetInstance: () => {};
    }
    export class AccountFactory implements IPostFactory {
        
        public formType:Object = {'Content-Type':"application/x-www-form-urlencoded"};
        
        constructor(public $http:ng.IHttpService) { }
        
        /**
         * DataFactory contains all endpoints available to the Account Object.
         */
        dataFactory = {
            
            
            $getAccount:():ng.IHttpPromise<Object> =>  {
            let urlBase = '/index.cfm/api/scope/getAccount/?ajaxRequest=1';
            return this.$http.get(urlBase);
            },

            $updateAccount:(data):ng.IHttpPromise<Object> => {
            let urlBase = '/index.cfm/api/scope/updateAccount/?ajaxRequest=1';
            return this.$http.post(urlBase, data.params,{headers: data.formType});
            },
    
            $saveAccount:(data):ng.IHttpPromise<Object> => {
            let urlBase = '/index.cfm/api/scope/updateAccount/?ajaxRequest=1';
            return this.$http.post(urlBase, data.params, {headers: data.formType});
            },
        
            $login:(data):ng.IHttpPromise<Object> => {
                let urlBase = '/index.cfm/api/scope/login/?ajaxRequest=1';
                return this.$http.post(urlBase, data.params, {headers: data.formType});
            },
        
            $loginGuestAccount:(data):ng.IHttpPromise<Object> => {
                let urlBase = '/index.cfm/api/scope/loginGuestAccount/?ajaxRequest=1';
                return this.$http.post(urlBase, data.params, {headers: data.formType});
            },
            
            $logout:($http):ng.IHttpPromise<Object> =>  {
                let urlBase = '/index.cfm/api/scope/logout/?ajaxRequest=1';
                return  this.$http.post(urlBase, {}, {headers: this.formType});
            },
            
            $guestAccountCreatePassword:(data):ng.IHttpPromise<Object> => {
                let urlBase = '/index.cfm/api/scope/guestAccountCreatePassword/?ajaxRequest=1';
                return this.$http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $forgotPassword:(data):ng.IHttpPromise<Object> =>  {
                let urlBase = '/index.cfm/api/scope/forgotPassword/?ajaxRequest=1';
                return this.$http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $createAccount:(data):ng.IHttpPromise<Object> =>  {
                let urlBase = '/index.cfm/api/scope/createAccount/?ajaxRequest=1';
                return this.$http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $resetPassword:(data):ng.IHttpPromise<Object> =>  {
                let urlBase = '/index.cfm/api/scope/resetPassword/?ajaxRequest=1';
                return this.$http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $changePassword:(data):ng.IHttpPromise<Object> =>  {
                let urlBase = '/index.cfm/api/scope/changePassword/?ajaxRequest=1';
                return this.$http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $deleteAccountEmailAddress:(data):ng.IHttpPromise<Object> =>  {
                let urlBase = '/index.cfm/api/scope/deleteAccountEmailAddress/?ajaxRequest=1';
                return this.$http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $sendAccountEmailAddressVerificationEmail:(data):ng.IHttpPromise<Object> =>  {
                let urlBase = '/index.cfm/api/scope/sendAccountEmailAddressVerificationEmail/?ajaxRequest=1';
                return this.$http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $verifyAccountEmailAddress:(data):ng.IHttpPromise<Object> =>  {
                let urlBase = '/index.cfm/api/scope/verifyAccountEmailAddress/?ajaxRequest=1';
                return this.$http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $deletePhoneNumber:(data):ng.IHttpPromise<Object> =>  {
                let urlBase = '/index.cfm/api/scope/deletePhoneNumber/?ajaxRequest=1';
                return this.$http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $deleteAccountAddress:(data):ng.IHttpPromise<Object> =>  {
                let urlBase = '/index.cfm/api/scope/deleteAccountAddress/?ajaxRequest=1';
                return this.$http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $addAccountPaymentMethod:(data):ng.IHttpPromise<Object> =>  {
                let urlBase = '/index.cfm/api/scope/addAccountPaymentMethod/?ajaxRequest=1';
                return this.$http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $deleteAccountPaymentMethod:(data):ng.IHttpPromise<Object> =>  {
                let urlBase = '/index.cfm/api/scope/deleteAccountPaymentMethod/?ajaxRequest=1';
                return this.$http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $updateSubscription:(data):ng.IHttpPromise<Object> =>  {
                let urlBase = '/index.cfm/api/scope/updateSubscription/?ajaxRequest=1';
                return this.$http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $renewSubscription:(data):ng.IHttpPromise<Object> =>  {
                let urlBase = '/index.cfm/api/scope/renewSubscription/?ajaxRequest=1';
                return this.$http.post(urlBase,data.params, {headers: data.formType});
            },
            
            $redeemGiftCard:(data):ng.IHttpPromise<Object> =>  {
                let urlBase = '/index.cfm/api/scope/redeemToAccount/?ajaxRequest=1';
                return this.$http.post(urlBase,data.params, {headers: data.formType});
            },
            toFormParams: (data):string => {
                return data = $.param(data) || "";
            }
            
            
        };

        /**
         * Returns an instance of the dataFactory
         */
        GetInstance = (): {} =>{
            return this.dataFactory;
        }

    }
    angular.module('slatwalladmin').service('AccountFactory',['$http',($http) => new AccountFactory($http)]);
}

