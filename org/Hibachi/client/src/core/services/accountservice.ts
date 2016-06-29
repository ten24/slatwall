/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {Account} from "../model/entity/account.ts";
class AccountService{
    //@ngInject
    constructor(public $injector:ng.auto.IInjectorService){
        this.$injector = $injector;
    }

    public newAccount = ($injector=this.$injector):Account=>{
        return new Account($injector);
    }
}
export {
    AccountService
}