/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import {BaseEntityService} from "./baseentityservice";
import {Injectable,Inject} from '@angular/core';
import {$Hibachi} from './hibachiservice';
import {UtilityService} from './utilityservice';

@Injectable()
export class OrderPaymentService extends BaseEntityService{
    public entity:any;

    constructor(
        @Inject("injector") public $injector:ng.auto.IInjectorService,
        public $hibachi : $Hibachi,
        public utilityService : UtilityService
    ){
        super($injector,$hibachi,utilityService,'OrderPayment');
    }


}
