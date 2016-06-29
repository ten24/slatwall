/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import {AdminRequest} from "../model/transient/adminrequest";
import {PublicRequest} from "../model/transient/publicrequest";

class RequestService{
    //@ngInject
    constructor(public $injector:ng.auto.IInjectorService){
        this.$injector = $injector;
    }

    public newAdminRequest = (
        url:string,
        data?:any,
        method:string="post",
        headers:{[headername:string]:string;}={'Content-Type':"application/json"},
        $injector=this.$injector
    ):AdminRequest=>{
        return new AdminRequest(url,data,method,headers,$injector);
    }

    public newPublicRequest = (
        url:string,
        data?:any,
        method:string="post",
        headers:{[headername:string]:string;}={'Content-Type':"application/x-www-form-urlencoded"},
        $injector=this.$injector
    ):PublicRequest=>{
        return new PublicRequest(url,data,method,headers,$injector);
    }
}
export {
    RequestService
}