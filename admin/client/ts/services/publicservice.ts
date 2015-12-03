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
        /** accessors for account and cart with aliases */
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
            return deferred.promise
        }
        
        public doAction=(action:string, data:any) => {
            console.log("Do Action called:",data);
            this.hasErrors = false;
            this.success = false;
            this.errors = undefined;
            
            if (!action) {throw "Action is required exception";}
            data.returnJsonObjects = "cart,account";//need to return cart and account when no object passed in.
            let urlBase = this.baseUrl + action + this.ajaxRequestParam;
            let promise =  this.$http.post(urlBase, this.toFormParams(data), {headers: this.formType}).then((result:any)=>{
                console.log("Result of doAction:", result);
                if (result.data.account){this.account = result.data.account;}
                if (result.data.cart){this.cart = result.data.cart;}
                //if the action that was called was successful, then success is true.
                if (result.data.successfulActions == action || result.data.successfulActions.length){
                    this.success = true;
                    console.log("Successfully returned result");
                
                }
                if (result.data.failureActions.length){
                    this.hasErrors = true;
                    console.log("has failure actions", result.data.failureActions);
                    console.log("has errors", result.data.errors);
                }
                
            }).catch((response)=>{
                console.log("There was an error making this http call exception.", response.status, response.data);
            }).finally(()=>{
                return promise;
            });
            
        }
        public toFormParams= (data):string => {
            return data = $.param(data) || "";
        }
    }
    angular.module('slatwalladmin').service('publicService',PublicService);
}

