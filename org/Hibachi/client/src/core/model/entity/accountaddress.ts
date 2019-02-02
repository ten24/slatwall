/// <reference path='../../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />

import {BaseEntity} from "./baseentity";

class AccountAddress extends BaseEntity{
    public accountAddressName:string;
    public address:any;
    
    constructor($injector){
        super($injector);
    }

    public getSimpleRepresentation = ():string =>{
        return (this.accountAddressName || '')+' - '
    	+(this.address.streetAddress || '')
    	+(this.address.street2Address.trim().length ? ' '+ this.address.street2Address:'')
    	+' '+(this.address.city || '')+','
    	+' '+(this.address.stateCode || '')
    	+' '+(this.address.postalCode || '')
    	+' '+(this.address.countryCode || '');
    }

}
export {
    AccountAddress
}