import {AccountAddress} from "../model/entity/accountaddress";
import {BaseEntityService} from "./baseentityservice";
class AccountAddressService extends BaseEntityService{
    public entity:any;

    //@ngInject
    constructor(
        public $injector:ng.auto.IInjectorService,
        public $hibachi,
        public utilityService
    ){
        super($injector,$hibachi,utilityService,'AccountAddress');
        
    }

}
export {
    AccountAddressService
}