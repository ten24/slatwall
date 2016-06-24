/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
import {Request} from "./request";

class PublicRequest extends Request{
    public failureActions:Array<any>=[];
    public successfulActions:Array<any>=[];
    public messages:Array<any>=[];
    constructor(
        url:string,
        data?:any,
        method?:string,
        headers:{[headername:string]:string;}={'Content-Type':"application/x-www-form-urlencoded"},
        $injector?
    ){
        super(
            url,
            data,
            method,
            headers,
            $injector
        );

        this.promise.then((result:any)=>{

            this.successfulActions = result.successfulActions;
            this.failureActions = result.failureActions;
            this.messages = result.messages;
        }).catch((response)=>{

        });
        return this;
    }

    public isSuccess = ()=>{
        return this.successfulActions.length;
    }

}
export{
    PublicRequest
}