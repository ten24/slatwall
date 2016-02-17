/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

//import Alert = require('../model/alert');
import {Alert} from "../model/alert";

interface IAlertService {
    get ():Alert[];
    addAlert (alert:Alert):void;
    addAlerts (alerts:Alert[]):void;
    removeAlert (alert:Alert):void;
    getAlerts ():Alert[];
    formatMessagesToAlerts (messages):Alert[];
    removeOldestAlert ():void;
    newAlert ():Alert;
}

class AlertService implements IAlertService{
    public static $inject = [
        '$timeout'
    ];

    constructor(
        private $timeout: ng.ITimeoutService,
        public alerts:Alert[]
    ) {
        this.alerts = [];
    }

    newAlert = ():Alert =>{
        return new Alert();
    };

    get = ():Alert[] =>{
        return this.alerts || [];
    };

    addAlert = (alert:any):void =>{
        this.alerts.push(alert);
        this.$timeout(()=> {
            this.removeAlert(alert);
        }, 3500);
    };

    addAlerts = (alerts:Alert[]):void =>{
        angular.forEach(alerts,(alert) => {
            this.addAlert(alert);
        });
    };

    removeAlert = (alert:Alert):void =>{
        var index:number = this.alerts.indexOf(alert, 0);
        if (index != undefined) {
            this.alerts.splice(index, 1);
        }
    };

    getAlerts = ():Alert[] =>{
        return this.alerts;
    };

    formatMessagesToAlerts = (messages):Alert[] =>{
        var alerts = [];
        if(messages && messages.length){
            for(var message in messages){
                var alert = new Alert(messages[message].message, messages[message].messageType);
                alerts.push(alert);
                if(alert.type === 'success' || alert.type === 'error'){
                    this.$timeout(()=> {
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

    removeOldestAlert = ():void =>{
        this.alerts.splice(0,1);
    }
}
export{
  AlertService,
  IAlertService
};





