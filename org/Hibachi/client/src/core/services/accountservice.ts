/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/slatwallTypescript.d.ts' />

class AccountService {

    public formType:Object = {'Content-Type':"application/x-www-form-urlencoded"};
    private baseUrl = "";

    constructor(public $http:ng.IHttpService) {
        this.baseUrl = "/index.cfm/api/scope/";
    }



    $getAccount=():ng.IHttpPromise<Object> =>  {
    let urlBase = this.baseUrl + 'getAccount/?ajaxRequest=1';
    return this.$http.get(urlBase);
    }

    $updateAccount=(data):ng.IHttpPromise<Object> => {
    let urlBase = this.baseUrl + 'updateAccount/?ajaxRequest=1';
    return this.$http.post(urlBase, data.params,{headers: data.formType});
    }

    $saveAccount=(data):ng.IHttpPromise<Object> => {
    let urlBase = this.baseUrl + 'updateAccount/?ajaxRequest=1';
    return this.$http.post(urlBase, data.params, {headers: data.formType});
    }

    $login=(data):ng.IHttpPromise<Object> => {
        let urlBase = this.baseUrl + 'login/?ajaxRequest=1';
        return this.$http.post(urlBase, data.params, {headers: data.formType});
    }

    $loginGuestAccount=(data):ng.IHttpPromise<Object> => {
        let urlBase = this.baseUrl + 'loginGuestAccount/?ajaxRequest=1';
        return this.$http.post(urlBase, data.params, {headers: data.formType});
    }

    $logout=():ng.IHttpPromise<Object> =>  {
        let urlBase = this.baseUrl + 'logout/?ajaxRequest=1';
        var options:any = {headers: this.formType}
        return  this.$http.get(urlBase, options);
    }

    $guestAccountCreatePassword=(data):ng.IHttpPromise<Object> => {
        let urlBase = this.baseUrl + 'guestAccountCreatePassword/?ajaxRequest=1';
        return this.$http.post(urlBase,data.params, {headers: data.formType});
    }

    $forgotPassword=(data):ng.IHttpPromise<Object> =>  {
        let urlBase = this.baseUrl + 'forgotPassword/?ajaxRequest=1';
        return this.$http.post(urlBase,data.params, {headers: data.formType});
    }

    $createAccount=(data):ng.IHttpPromise<Object> =>  {
        let urlBase = this.baseUrl + 'createAccount/?ajaxRequest=1';
        return this.$http.post(urlBase,data.params, {headers: data.formType});
    }

    $resetPassword=(data):ng.IHttpPromise<Object> =>  {
        let urlBase = this.baseUrl + 'resetPassword/?ajaxRequest=1';
        return this.$http.post(urlBase,data.params, {headers: data.formType});
    }

    $changePassword=(data):ng.IHttpPromise<Object> =>  {
        let urlBase = this.baseUrl + 'changePassword/?ajaxRequest=1';
        return this.$http.post(urlBase,data.params, {headers: data.formType});
    }

    $deleteAccountEmailAddress=(data):ng.IHttpPromise<Object> =>  {
        let urlBase = this.baseUrl + 'deleteAccountEmailAddress/?ajaxRequest=1';
        return this.$http.post(urlBase,data.params, {headers: data.formType});
    }

    $sendAccountEmailAddressVerificationEmail=(data):ng.IHttpPromise<Object> =>  {
        let urlBase = this.baseUrl + 'sendAccountEmailAddressVerificationEmail/?ajaxRequest=1';
        return this.$http.post(urlBase,data.params, {headers: data.formType});
    }

    $verifyAccountEmailAddress=(data):ng.IHttpPromise<Object> =>  {
        let urlBase = this.baseUrl + 'verifyAccountEmailAddress/?ajaxRequest=1';
        return this.$http.post(urlBase,data.params, {headers: data.formType});
    }

    $deletePhoneNumber=(data):ng.IHttpPromise<Object> =>  {
        let urlBase = this.baseUrl + 'deletePhoneNumber/?ajaxRequest=1';
        return this.$http.post(urlBase,data.params, {headers: data.formType});
    }

    $deleteAccountAddress=(data):ng.IHttpPromise<Object> =>  {
        let urlBase = this.baseUrl + 'deleteAccountAddress/?ajaxRequest=1';
        return this.$http.post(urlBase,data.params, {headers: data.formType});
    }

    $addAccountPaymentMethod=(data):ng.IHttpPromise<Object> =>  {
        let urlBase = this.baseUrl + 'addAccountPaymentMethod/?ajaxRequest=1';
        return this.$http.post(urlBase,data.params, {headers: data.formType});
    }

    $deleteAccountPaymentMethod=(data):ng.IHttpPromise<Object> =>  {
        let urlBase = this.baseUrl + 'deleteAccountPaymentMethod/?ajaxRequest=1';
        return this.$http.post(urlBase,data.params, {headers: data.formType});
    }

    $updateSubscription=(data):ng.IHttpPromise<Object> =>  {
        let urlBase = this.baseUrl + 'updateSubscription/?ajaxRequest=1';
        return this.$http.post(urlBase,data.params, {headers: data.formType});
    }

    $renewSubscription=(data):ng.IHttpPromise<Object> =>  {
        let urlBase = this.baseUrl + 'renewSubscription/?ajaxRequest=1';
        return this.$http.post(urlBase,data.params, {headers: data.formType});
    }

    $redeemGiftCard=(data):ng.IHttpPromise<Object> =>  {
        let urlBase = this.baseUrl + 'redeemToAccount/?ajaxRequest=1';
        return this.$http.post(urlBase,data.params, {headers: data.formType});
    }
    toFormParams=(data):string => {
        return data = $.param(data) || "";
    }

}
export{
    AccountService
}

