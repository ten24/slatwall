/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {BaseEntityService} from "./baseentityservice";
import * as Entities from "../model/entity/entities";
import * as Processes from "../model/process/processes";
import { Injectable,Inject } from "@angular/core";
import { $Hibachi } from "./hibachiservice";
import { UtilityService } from "./utilityservice";

@Injectable()
export class EntityService extends BaseEntityService{

    //@ngInject
    constructor(
        @Inject("$injector") public $injector,
        public $hibachi : $Hibachi,
        public utilityService : UtilityService
    ){
        super(
            $injector,
            $hibachi,
            utilityService
        );

    }

}

