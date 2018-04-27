/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
import {Request} from "./request";
import {ObserverService} from "../../services/observerservice";

class PublicRequest extends Request{
    public failureActions:Array<any>=[];
    public successfulActions:Array<any>=[];
    public messages:Array<any>=[];
    constructor(
        url:string,
        data?:any,
        method?:string,
        headers:{[headername:string]:string;}={'Content-Type':"application/x-www-form-urlencoded"},
        $injector?,
        public observerService?:ObserverService
    ){
        super(
            url,
            data,
            method,
            headers,
            $injector
        );
        this.observerService = observerService;

        this.promise.then((result:any)=>{

            this.successfulActions = result.successfulActions;


            for(var i in this.successfulActions){
                let successfulAction:string = this.successfulActions[i];


                this.observerService.notify(successfulAction.split('.')[1]+'Success',result.data);
            }
            this.failureActions = result.failureActions;
            for(var i in this.failureActions){
                let failureAction:string = this.failureActions[i];
                this.observerService.notify(failureAction.split('.')[1]+'Failure',result.data);
            }
            this.messages = result.messages;
        }).catch((response)=>{

        });
        return this;
    }

    public hasSuccessfulAction = ():boolean=>{
        return this.successfulActions.length > 0;
    }

    public hasFailureAction = ():boolean=>{
        return this.failureActions.length > 0;
    }
}
export{
    PublicRequest
}