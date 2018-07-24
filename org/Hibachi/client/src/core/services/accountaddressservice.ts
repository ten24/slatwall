/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {AccountAddress} from "../model/entity/accountaddress";
import {BaseEntityService} from "./baseentityservice";
import { Inject, Injectable } from "@angular/core";
import { $Hibachi } from "./hibachiservice";
import { UtilityService } from "./utilityservice";

export class AccountAddressService extends BaseEntityService{
    public entity:any;

    constructor(
        @Inject("$injector") public $injector:ng.auto.IInjectorService,
        public $hibachi : $Hibachi,
        public utilityService : UtilityService
    ){
        super($injector,$hibachi,utilityService,'AccountAddress');
    }

}
