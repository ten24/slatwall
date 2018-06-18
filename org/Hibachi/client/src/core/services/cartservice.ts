/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {Cart} from "../model/entity/cart";
import {BaseEntityService} from "./baseentityservice";
import { Inject, Injectable } from "@angular/core";
import { $Hibachi } from "./hibachiservice";
import { UtilityService } from "./utilityservice";

@Injectable()
export class CartService extends BaseEntityService{
    //@ngInject
    //@ngInject
    constructor(
        @Inject("$injector") public $injector:ng.auto.IInjectorService,
        public $hibachi : $Hibachi,
        public utilityService : UtilityService
    ){
        super($injector,$hibachi,utilityService,'Order','Cart');
    }
}
