/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
import {BaseTransient} from "./basetransient";
import {UtilityService} from "../../services/utilityService";

class Request extends BaseTransient {

    public messages:Array<any>;
    public headers:{[headername:string]:string;};
    public $q:ng.IQService;
    public $http:ng.IHttpService;
    public $window:ng.IWindowService;
    public loading:boolean=true;
    public promise:ng.IHttpPromise<any>;
    public resolve:ng.IQResolveReject<any>;
    public reject:ng.IQResolveReject<any>;
    public errors:{[name:string]:string[]}={};
    public url:string;
    public data:any;
    public method:string;
    public utilityService:UtilityService;

    constructor(
        url:string,
        data?:any,
        method?:string,
        headers?:{[headername:string]:string;},
        $injector?
    ){
        super($injector);
        this.headers = headers;
        this.$q = this.getService<ng.IQService>('$q');
        this.$http = this.getService<ng.IHttpService>('$http');
        this.$window = this.getService<ng.IWindowService>('$window');
        this.url = url;
        this.data=data;
        this.method=method;
        this.utilityService = <UtilityService>this.getService('utilityService');

        if(!method){
            if (data == undefined){
                method = "get";
            }else{
                method = "post";
            }
        }

        var deferred:any = this.$q.defer();

        if (method == "post"){
            if(this.headers['Content-Type']!=="application/json"){
                data = this.toFormParams(data);
            }
            //post
            let promise =  this.$http({
                url:url, data:data, headers:this.headers,method:'post'
            })
            .success((result:any)=>{
                this.processSuccess(result);
                deferred.resolve(result);
            }).error((response)=>{
                this.processError(response);
                deferred.reject(response);
            });
            this.promise = deferred.promise;
        }else{
            //get
            this.$http({url:url,method:'get'})
            .success((result:any)=>{
                this.processSuccess(result);
                deferred.resolve(result);
            }).error((reason)=>{
                this.processError(reason);
                deferred.reject(reason);
            });
            this.promise = deferred.promise;
        }
        return this;
    }

    public processResponse=(response)=>{
        this.loading = false;

        if(response.errors){
            this.errors = response.errors;
        }
        if(response.messages){
            this.messages = response.messages
        }

    }

    //returns hibachiAction value from url and data;
    public getAction=():string=>{
        var config:any = this.getAppConfig();
        //typically hibachiAction
        var actionName:string = config.action;
        var params = this.utilityService.getQueryParamsFromUrl(this.url);

        if(params[actionName]){
            return params[actionName];
        }
        if(this.data && this.data[actionName]){
            return this.data[actionName];
        }

        if(this.url.indexOf('api/scope/') > 0){
            return this.extractPublicAction(this.url);
        }

    }

    private extractPublicAction=(url:string)=>{
        //get in between api/scope and / or ? or end of word
        var regex = /\api\/scope\/(.*?)(?=\/|\?|$)/;
        var arr = regex.exec(url);
        return arr[1];
    }

    public processSuccess=(response)=>{
        this.processResponse(response);
    }

    public processError=(response)=>{
        this.processResponse(response);
    }

    /** used to turn data into a correct format for the post */
    public toFormParams= (data):string => {
        if(data){
            return $.param(data);
        }else{
            return "";
        }

        //return data = this.serializeData(data) || "";
    }

    public serializeData=( data )=> {
        // If this is not an object, defer to native stringification.
        if ( ! angular.isObject( data ) ) {
            return( ( data == null ) ? "" : data.toString() );
        }

        var buffer = [];

        // Serialize each key in the object.
        for ( var name in data ) {
            if ( ! data.hasOwnProperty( name ) ) {
                continue;
            }

            var value = data[ name ];

            buffer.push(
                encodeURIComponent( name ) + "=" + encodeURIComponent( ( value == null ) ? "" : value )
            );
        }

        // Serialize the buffer and clean it up for transportation.
        var source = buffer.join( "&" ).replace( /%20/g, "+" );
        return( source );
    }

}
export {Request}