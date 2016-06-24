/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
import {Request} from "./request";

class AdminRequest extends Request{
    constructor(
        url:string,
        data?:any,
        method:string="post",
        headers:{[headername:string]:string;}={'Content-Type':"application/json"},
        $injector?
    ){
        super(
            url,
            data,
            method,
            headers,
            $injector
        );
    }
}
export{
    AdminRequest
}