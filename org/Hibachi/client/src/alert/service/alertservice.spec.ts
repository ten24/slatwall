/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import {AlertService} from "./alertservice";
import {Alert} from "../model/alert";

describe('alertService Test',()=>{
    var alertService:AlertService;
    beforeEach(angular.mock.module('hibachi.alert'));
    beforeEach(inject((_alertService_)=>{
        alertService = _alertService_;
    }));
    it('new Alert test', ()=>{
        expect(alertService.newAlert()).toBeDefined();
    });

    it('addAlerts test',()=>{
        var alert:Alert = alertService.newAlert();
        alert.msg = 'this';
        alertService.addAlert(alert);
        expect(alertService.getAlerts().length).toBe(1);
    });
});