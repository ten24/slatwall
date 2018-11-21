/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import { Component } from '@angular/core';
import { Alert } from '../model/alert';
import { AlertService } from '../service/alertservice';

@Component({
    selector    : 'sw-alert',
    templateUrl : '/org/Hibachi/client/src/alert/component/alert.html'
})
export class SwAlert {
    private alerts: Alert[];
    
    constructor(private alertService: AlertService) {
        this.alerts = this.alertService.getAlerts();
    }
}