/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


import {Alert} from "../model/alert";
import { Injectable } from '@angular/core';


@Injectable()
export class AlertService {
    public alerts:Alert[];
    constructor(
    ) {
        this.alerts = [];
    }

    newAlert():Alert{
        return new Alert();
    };

    get():Alert[]{
        return this.alerts || [];
    };

    addAlert(alert:any):void{
        this.alerts.push(alert);
        setTimeout(()=> {
            if(!alert.dismissable){
                this.removeAlert(alert);
            }
        }, 3500);
    };

    addAlerts(alerts:Alert[]):void{
        angular.forEach(alerts,(alert) => {
            this.addAlert(alert);
        });
    };

    removeAlert(alert:Alert):void{
        var index:number = this.alerts.indexOf(alert, 0);
        if (index != undefined) {
            this.alerts.splice(index, 1);
        }
    };

    getAlerts():Alert[]{
        return this.alerts;
    };

    formatMessagesToAlerts(messages):Alert[]{
        var alerts = [];
        if(messages && messages.length){
            for(var message in messages){
                var alert = new Alert(messages[message].message, messages[message].messageType);
                alerts.push(alert);
                if(alert.type === 'success' || alert.type === 'error'){
                    setTimeout(()=> {
                        alert.fade = true;
                    }, 3500);
                    alert.dismissable = false;
                }else{
                    alert.fade = false;
                    alert.dismissable = true;
                }
            }
        }
        return alerts;
    };

    removeOldestAlert():void{
        this.alerts.splice(0,1);
    }
}






