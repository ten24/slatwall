/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />
import {Request} from "./request";
import {ObserverService} from "../../services/observerservice";


class AdminRequest extends Request{
    constructor(
        url:string,
        data?:any,
        method:string="post",
        headers:{[headername:string]:string;}={'Content-Type':"application/json"},
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

            //identify that it is an object save
            if(url.indexOf('api:main.post') != -1 && data.entityName){
                var eventNameBase = data.entityName+data.context.charAt(0).toUpperCase()+data.context.slice(0);
                if(result.errors){
                    this.observerService.notify(eventNameBase+'Failure',result.data);

                }else{
                    this.observerService.notify(eventNameBase+'Success',result.data);

                }
            }

            this.messages = result.messages;
        }).catch((response)=>{

        });
    }
}
export{
    AdminRequest
}