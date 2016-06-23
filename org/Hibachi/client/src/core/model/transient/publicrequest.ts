/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
import {Request} from "./request";

class PublicRequest extends Request{
    public failureActions:Array<any>=[];
    public successfulActions:Array<any>=[];
    public success:boolean=false;

    constructor(
        url:string,
        data?:any,
        method?:string,
        headers:{[headername:string]:string;}={'Content-Type':"application/x-www-form-urlencoded"}
    ){
        let request = super(
            url,
            data,
            method,
            headers
        );

        this.promise.success((result:any)=>{
            this.successfulAction = result.data.successfulActions;
            this.failureActions = result.data.failureActions;
            this.resolve(result);
        }).error((response)=>{
            this.loading = false;
            this.reject(response);
        });

    }

    public isSuccess = ()=>{
        return this.successfulActions.length;
    }

}
export{
    PublicRequest
}