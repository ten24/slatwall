/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
import {BaseTransient} from "./basetransient";

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

        if(!method){
            if (data == undefined){
                method = "get";
            }else{
                method = "post";
            }
        }

        // if(this.headers['Content-Type']==="application/json"){
        //     if(!angular.isString(data)){
        //         data = angular.toJson(data);
        //     }
        // }

        var deferred:any = this.$q.defer();

        if (method == "post"){
            if(this.headers['Content-Type']!=="application/json"){
                data = this.toFormParams(data);
            }
            //post
            let promise =  this.$http.post(url, data, this.headers)
            .success((result:any)=>{
                this.loading = false;
                deferred.resolve(result);
            }).error((response)=>{
                this.loading = false;
                deferred.reject(response);
            });
            this.promise = deferred.promise;
        }else{
            //get
            this.$http.get(url)
            .success((result:any)=>{
                this.loading = false;
                deferred.resolve(result);
            }).error((reason)=>{
                this.loading = false;
                deferred.reject(reason);
            });
            this.promise = deferred.promise;
        }
        return this;
    }

    /** used to turn data into a correct format for the post */
    public toFormParams= (data):string => {
        return data = $.param(data) || "";
    }

}
export {Request}