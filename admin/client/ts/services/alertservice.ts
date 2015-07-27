/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />

/*services return promises which can be handled uniquely based on success or failure by the controller*/
module slatwalladmin{
    //service
    
    export interface IAlertService {
        get (): Alert[];
    }
    
    export class AlertService implements IAlertService{
        public static $inject = [
            '$timeout'
        ];
        
        constructor(
            private $timeout: ng.ITimeoutService,
            public alerts:Alert[]
        ) {
            this.alerts = [];
        }
        
        get = (): Alert[] =>{
            return this.alerts || [];
        }
        
        addAlert = (alert:Alert):void =>{
            this.alerts.push(alert);
            this.$timeout((alert)=> {
              this.removeAlert(alert);
            }, 3500);
        }
        
        addAlerts = (alerts:Alert[]):void =>{
        	alerts.forEach(alert => {
        		this.addAlert(alert);
        	});
        }
        
        removeAlert = (alert:Alert):void =>{
            var index:number = this.alerts.indexOf(alert, 0);
            if (index != undefined) {
               this.alerts.splice(index, 1);
            }
        }
        
        getAlerts = (): Alert[] =>{
			return this.alerts;
		}		
        
        formatMessagesToAlerts = (messages): Alert[] =>{
            var alerts = [];
            for(var message in messages){
                var alert = new Alert();
               	alert.msg=messages[message].message;
                alert.type=messages[message].messageType;
                
                alerts.push(alert);
                if(alert.type === 'success' || alert.type === 'error'){
                     $timeout(function() {
                      alert.fade = true;
                    }, 3500);
                    
                    alert.dismissable = false;
                    
                }else{
                    alert.fade = false;
                    alert.dismissable = true;
                }
            }
            return alerts;
        }
        
        removeOldestAlert = ():void =>{
            this.alerts.splice(0,1);
        }
    }  
    
}
module slatwalladmin{
     angular.module('slatwalladmin')
    .service('alertService',AlertService); 
}
    
