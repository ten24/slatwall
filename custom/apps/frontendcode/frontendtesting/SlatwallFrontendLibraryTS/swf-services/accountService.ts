/// <reference path='../../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../../client/typings/tsd.d.ts' />
module slatwallFrontend {

    export interface IPostFactory {
        dataFactory: {},
        formType: {},
        toFormParams: (data?:any) => any;
        Get: () => {};
    }

    export class AccountFactory implements IPostFactory {
        dataFactory = {
                $getAccount():any{
                var urlBase = '/index.cfm/api/scope/getAccount/?ajaxRequest=1';
                return this.http.get(urlBase);
                },
    
                $updateAccount(data:any):any{
                var urlBase = '/index.cfm/api/scope/updateAccount/?ajaxRequest=1';
                return this.http.post(urlBase, this.toFormParams(data),{headers: this.this.formType});
                },
        
                $saveAccount(data):any{
                var urlBase = '/index.cfm/api/scope/updateAccount/?ajaxRequest=1';
                return this.http.post(urlBase, this.toFormParams(data), {headers: this.this.formType});
                },
            
                $login(data) {
                    var urlBase = '/index.cfm/api/scope/login/?ajaxRequest=1';
                    return this.http.post(urlBase, this.toFormParams(data), {headers: this.this.formType});
                },
            
                $loginGuestAccount(data) {
                    var urlBase = '/index.cfm/api/scope/loginGuestAccount/?ajaxRequest=1';
                    return this.http.post(urlBase,this.toFormParams(data), {headers: this.formType});
                },
                
                $logout() {
                    var urlBase = '/index.cfm/api/scope/logout/?ajaxRequest=1';
                    return this.http.get(urlBase, {headers: this.formType});
                },
                
                $guestAccountCreatePassword(data) {
                    var urlBase = '/index.cfm/api/scope/guestAccountCreatePassword/?ajaxRequest=1';
                    return this.http.post(urlBase,this.toFormParams(data), {headers: this.formType});
                },
                
                $forgotPassword(data) {
                    var urlBase = '/index.cfm/api/scope/forgotPassword/?ajaxRequest=1';
                    return this.http.post(urlBase,this.toFormParams(data), {headers: this.formType});
                },
                
                $createAccount(data) {
                    var urlBase = '/index.cfm/api/scope/createAccount/?ajaxRequest=1';
                    return this.http.post(urlBase,this.toFormParams(data), {headers: this.formType});
                },
                
                $resetPassword(data) {
                    var urlBase = '/index.cfm/api/scope/resetPassword/?ajaxRequest=1';
                    return this.http.post(urlBase,this.toFormParams(data), {headers: this.formType});
                },
                
                $changePassword(data) {
                    var urlBase = '/index.cfm/api/scope/changePassword/?ajaxRequest=1';
                    return this.http.post(urlBase,this.toFormParams(data), {headers: this.formType});
                },
                
                $deleteAccountEmailAddress(data) {
                    var urlBase = '/index.cfm/api/scope/deleteAccountEmailAddress/?ajaxRequest=1';
                    return this.http.post(urlBase,this.toFormParams(data), {headers: this.formType});
                },
                
                $sendAccountEmailAddressVerificationEmail(data) {
                    var urlBase = '/index.cfm/api/scope/sendAccountEmailAddressVerificationEmail/?ajaxRequest=1';
                    return this.http.post(urlBase,this.toFormParams(data), {headers: this.formType});
                },
                
                $verifyAccountEmailAddress(data) {
                    var urlBase = '/index.cfm/api/scope/verifyAccountEmailAddress/?ajaxRequest=1';
                    return this.http.post(urlBase,this.toFormParams(data), {headers: this.formType});
                },
                
                $deletePhoneNumber(data) {
                    var urlBase = '/index.cfm/api/scope/deletePhoneNumber/?ajaxRequest=1';
                    return this.http.post(urlBase,this.toFormParams(data), {headers: this.formType});
                },
                
                $deleteAccountAddress(data) {
                    var urlBase = '/index.cfm/api/scope/deleteAccountAddress/?ajaxRequest=1';
                    return this.http.post(urlBase,this.toFormParams(data), {headers: this.formType});
                },
                
                $addAccountPaymentMethod(data) {
                    var urlBase = '/index.cfm/api/scope/addAccountPaymentMethod/?ajaxRequest=1';
                    return this.http.post(urlBase,this.toFormParams(data), {headers: this.formType});
                },
                
                $deleteAccountPaymentMethod(data) {
                    var urlBase = '/index.cfm/api/scope/deleteAccountPaymentMethod/?ajaxRequest=1';
                    return this.http.post(urlBase,this.toFormParams(data), {headers: this.formType});
                },
                
                $updateSubscription(data) {
                    var urlBase = '/index.cfm/api/scope/updateSubscription/?ajaxRequest=1';
                    return this.http.post(urlBase,this.toFormParams(data), {headers: this.formType});
                },
                
                $renewSubscription(data) {
                    var urlBase = '/index.cfm/api/scope/renewSubscription/?ajaxRequest=1';
                    return this.http.post(urlBase,this.toFormParams(data), {headers: this.formType});
                },
                
                $redeemGiftCard(data) {
                    var urlBase = '/index.cfm/api/scope/redeemToAccount/?ajaxRequest=1';
                    return this.http.post(urlBase,this.toFormParams(data), {headers: this.formType});
                }
        };
        
        formType    = {'Content-Type': 'application/x-www-form-urlencoded'};
        toFormParams = (data) =>{
            return data = $.param(data) || "";
        }
        private http: ng.IHttpService;
        static $inject = ['$http'];
        constructor($http: ng.IHttpService) {
            this.http = $http;
        }

        Get(): {} {
            return this.dataFactory;
        }
    }
    angular.module('slatwallFrontend').service('AccountFactory',['$http',($http) => new AccountFactory($http)]);
}

