import { 
    PublicService as PublicServiceCore,
    PublicRequest
} from "@Hibachi/core/core.module";

export class PublicService extends PublicServiceCore {
    
    /** this is the generic method used to call all server side actions.
     *  @param action {string} the name of the action (method) to call in the public service.
     *  @param data   {object} the params as key value pairs to pass in the post request.
     *  @return a deferred promise that resolves server response or error. also includes updated account and cart.
    */
    public doAction = (action:string, data?:any, method?:any) => {
        //purge angular $ prefixed propertie
        //Prevent sending the same request multiple times in parallel
        if( this.getRequestByAction(action) && this.loadingThisRequest(action, data, false) ){
            return this.$q.when();
        }

        if( !action ){
            throw "Action is required exception";
        }

        var urlBase = this.appConfig.baseURL;

        //check if the caller is defining a path to hit, otherwise use the public scope.
        if( action.indexOf(":") !== -1 ){
            urlBase = urlBase + action; //any path
        } 
        else {
            urlBase = this.baseActionPath + action;//public path
        }

        if( data ){
            method = "post";
            if(data.returnJsonObjects == undefined){
                data.returnJsonObjects = "cart,account";
            }
            if( this.cmsSiteID ){
                data.cmsSiteID = this.cmsSiteID;
            }
        }
        else {
            urlBase += (urlBase.indexOf('?') == -1) ? '?' : '&';
            if( this.cmsSiteID ){
                urlBase += "&cmsSiteID=" + this.cmsSiteID;
            }
        }

        if( method == "post" ){
            //post
            let request:PublicRequest = this.requestService.newPublicRequest(urlBase, data, method)

            request.promise
            .then( (result:any) => {
                this.processAction(result, request);
            })
            .catch(request.reject);
            
            this.requests[ request.getAction() ]=request;
            return request.promise;
        } 
        else {
            //get
            var url = urlBase;
            let request = this.requestService.newPublicRequest(url,data,method);

            request.promise
            .then( (result:any) => {
                this.processAction(result,request);
            })
            .catch(request.reject);

            this.requests[ request.getAction() ] = request;
            return request.promise;
        }

    }

}