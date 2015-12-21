/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/slatwallTypescript.d.ts' />

class CartService {
    public formType:any;

    constructor(public $http:ng.IHttpService) {
        this.formType= {'Content-Type': 'application/x-www-form-urlencoded'}
    }
    /**
        * DataFactory contains all endpoints available to the Account Object.
        */



    $getCart=():ng.IHttpPromise<Object> =>   {
            var urlBase = '/index.cfm/api/scope/getCart/?ajaxRequest=1';
            return this.$http.get(urlBase);
    }

    $getOrder=():ng.IHttpPromise<Object> =>   {
        var urlBase = '/index.cfm/api/scope/getCart/?ajaxRequest=1';
        return this.$http.get(urlBase);
    }

    $updateOrder=(data):ng.IHttpPromise<Object> =>   {
        var urlBase = '/index.cfm/api/scope/updateOrder/?ajaxRequest=1';
        return this.$http.post(urlBase, data.params, {headers: this.formType});
    }

    $clearOrder=(data):ng.IHttpPromise<Object> =>   {
        var urlBase = '/index.cfm/api/scope/clearOrder/?ajaxRequest=1';
        return this.$http.post(urlBase, data.params, {headers: this.formType});
    }

    $changeOrder=(data) :ng.IHttpPromise<Object> =>  {
        var urlBase = '/index.cfm/api/scope/changeOrder/?ajaxRequest=1';
        return this.$http.post(urlBase, data.params, {headers: this.formType});
    }

    $deleteOrder=(data):ng.IHttpPromise<Object> =>   {
        var urlBase = '/index.cfm/api/scope/deleteOrder/?ajaxRequest=1';
        return this.$http.post(urlBase, data.params, {headers: this.formType});
    }

    $placeOrder=(data):ng.IHttpPromise<Object> =>   {
        var urlBase = '/index.cfm/api/scope/placeOrder/?ajaxRequest=1';
        return this.$http.post(urlBase, data.params, {headers: this.formType});
    }

    $duplicateOrder=(data):ng.IHttpPromise<Object> =>   {
        var urlBase = '/index.cfm/api/scope/duplicateOrder/?ajaxRequest=1';
        return this.$http.post(urlBase, data.params, {headers: this.formType});
    }

    $addOrderItem=(data):ng.IHttpPromise<Object> =>   {
        var urlBase = '/index.cfm/api/scope/addOrderItem/?ajaxRequest=1';
        return this.$http.post(urlBase, data.params, {headers: this.formType});
    }

    $removeOrderItem=(data):ng.IHttpPromise<Object> =>   {
        var urlBase = '/index.cfm/api/scope/removeOrderItem/?ajaxRequest=1';
        return this.$http.post(urlBase, data.params, {headers: this.formType});
    }

    $updateOrderFulfillment=(data):ng.IHttpPromise<Object> =>   {
        var urlBase = '/index.cfm/api/scope/updateOrderFulfillment/?ajaxRequest=1';
        return this.$http.post(urlBase, data.params, {headers: this.formType});
    }

    $addPromotionCode=(data):ng.IHttpPromise<Object> =>   {
        var urlBase = '/index.cfm/api/scope/addPromotionCode/?ajaxRequest=1';
        return this.$http.post(urlBase, data.params, {headers: this.formType});
    }

    $removePromotionCode=(data):ng.IHttpPromise<Object> =>   {
        var urlBase = '/index.cfm/api/scope/removePromotionCode/?ajaxRequest=1';
        return this.$http.post(urlBase, data.params, {headers: this.formType});
    }

    $addOrderPayment=(data):ng.IHttpPromise<Object> =>   {
        var urlBase = '/index.cfm/api/scope/addOrderPayment/?ajaxRequest=1';
        return this.$http.post(urlBase, data.params, {headers: this.formType});
    }

    $removeOrderPayment=(data):ng.IHttpPromise<Object> =>   {
        var urlBase = '/index.cfm/api/scope/removeOrderPayment/?ajaxRequest=1';
        return this.$http.post(urlBase, data.params, {headers: this.formType});
    }

    $addProductReview=(data):ng.IHttpPromise<Object> =>   {
        var urlBase = '/index.cfm/api/scope/addProductReview/?ajaxRequest=1';
        return this.$http.post(urlBase, data.params, {headers: this.formType});
    }
    toFormParams=(data):string =>  {
        return data = $.param(data) || "";
    }


}
export{
    CartService
}






