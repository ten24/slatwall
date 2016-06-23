/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />

import {BaseEntity} from "./baseentity";

class Account extends BaseEntity{
    public accountID:string;
    public giftCards:Array<any>=[];
    constructor(){
        super();
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