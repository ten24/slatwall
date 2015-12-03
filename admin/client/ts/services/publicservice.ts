/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
module slatwalladmin {
    export class PublicService {
        public formType:Object = {'Content-Type':"application/x-www-form-urlencoded"};
        public ajaxRequestParam:string = "?ajaxRequest=1";
        public account:any; 
        public cart:any;
        public success:boolean;
        public hasErrors:boolean;
        public errors:string;
        public http:ng.IHttpService;
        private baseUrl = "";
        
        //@ngInject
        constructor(public $http:ng.IHttpService, public $q:ng.IQService) { 
            this.baseUrl = "/index.cfm/api/scope/";
            this.$http = $http;
            this.$q = $q
        }
        
        /** accessors for account */
        public getAccount=(refresh:boolean):any =>  {
            let urlBase = this.baseUrl + 'getAccount/' + this.ajaxRequestParam + "&returnJsonObject=cart,account";
            var deferred = this.$q.defer();
            this.$http.get(urlBase).success((result:any)=>{
                this.account = result;
                console.log("Result Account:", this.account);
                deferred.resolve(result);
            }).error((reason)=>{
                deferred.reject(reason);  
            });
            return deferred.promise
        }
        /** accessors for cart */
        public getCart=(refresh:boolean):any =>  {
            let urlBase = this.baseUrl + 'getCart/' + this.ajaxRequestParam;
            var deferred = this.$q.defer();
            this.$http.get(urlBase).success((result:any)=>{
                this.cart = result;
                console.log("Result Cart:", this.cart);
                deferred.resolve(result);
            }).error((reason)=>{
                deferred.reject(reason);  
            });
            return deferred.promise;
        }
        /** this is the generic method used to call all server side actions.
         *  @param action {string} the name of the action (method) to call in the public service.
         *  @param data   {object} the params as key value pairs to pass in the post request.
         *  @return a deferred promise that resolves server response or error. also includes updated account and cart.
         */
        public doAction=(action:string, data:any) => {
            console.log("Do Action called:",data);
            this.hasErrors = false;
            this.success = false;
            this.errors = undefined;
            var deferred = this.$q.defer();
            if (!action) {throw "Action is required exception";}
            data.returnJsonObjects = "cart,account";
            let urlBase = this.baseUrl + action + this.ajaxRequestParam;
            let promise =  this.$http.post(urlBase, this.toFormParams(data), {headers: this.formType}).then((result:any)=>{
                
                /** update the account and the cart */
                if (result.data.account){this.account = result.data.account;}
                if (result.data.cart){this.cart = result.data.cart;}
                //if the action that was called was successful, then success is true.
                if (result.data.successfulActions.length){
                    this.success = true;
                }
                if (result.data.failureActions.length){
                    this.hasErrors = true;
                    console.log("Errors:", result.data.errors);
                }
                deferred.resolve(result);
            }).catch((response)=>{
                console.log("There was an error making this http call", response.status, response.data);
                deferred.reject(response);
            });
            return deferred.promise;
        }
        /** used to turn data into a correct format for the post */
        public toFormParams= (data):string => {
            return data = $.param(data) || "";
        }
    }
    angular.module('slatwalladmin').service('publicService',PublicService);
}

