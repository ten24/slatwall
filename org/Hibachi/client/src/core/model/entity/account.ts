/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />

import {BaseEntity} from "./baseentity";

class Account extends BaseEntity{
    public accountID:string;
    public giftCards:Array<any>=[];
    public firstName:string;
    public lastName:string;
    public entity:any;

    constructor($injector){
        super($injector);
    }

    public userIsLoggedIn = ():boolean =>{
        if (this.accountID !== ''){
            return true;
        }
        return false;
    }

}
export {
    Account
}