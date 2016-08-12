/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import {AdminRequest} from "../model/transient/adminrequest";
import {PublicRequest} from "../model/transient/publicrequest";

class RequestService{
    //@ngInject
    constructor(
        public $injector:ng.auto.IInjectorService,
        public observerService
    ){
        this.$injector = $injector;
        this.observerService = observerService;
    }

    public newAdminRequest = (
        url:string,
        data?:any,
        method:string="post",
        headers:{[headername:string]:string;}={'Content-Type':"application/json"},
        $injector=this.$injector,
        observerService=this.observerService
    ):AdminRequest=>{
        return new AdminRequest(url,data,method,headers,$injector,observerService);
    }

    public newPublicRequest = (
        url:string,
        data?:any,
        method:string="post",
        headers:{[headername:string]:string;}={'Content-Type':"application/x-www-form-urlencoded"},
        $injector=this.$injector,
        observerService=this.observerService
    ):PublicRequest=>{
        return new PublicRequest(url,data,method,headers,$injector,observerService);
    }
}
export {
    RequestService
}