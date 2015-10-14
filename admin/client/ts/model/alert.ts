/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
module slatwalladmin{

    //model
    export class Alert {
        msg:string;
        type:string;
        constructor(
            msg: string,
            type: string
        ) { 
            this.msg = msg;
            this.type = type;   
        }
    }
    /*export class Alerts {
        alerts:Alert[];
        constructor(
            alerts:Alert[]
        ){
            this.alerts = alerts;  
        }
        
        addAlert(alert:Alert){
            this.alerts.push(alert);
        }
        removeAlert(alert:Alert){
            var index:number = this.alerts.indexOf(alert, 0);
            if (index != undefined) {
               this.alerts.splice(index, 1);
            }
        }
    }*/
}
