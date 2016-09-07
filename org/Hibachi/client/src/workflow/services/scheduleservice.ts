/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {BaseEntityService} from "../../core/services/baseentityservice";
class ScheduleService extends BaseEntityService{
    private schedulePreview = {};

    //@ngInject
    constructor(
        public $injector:ng.auto.IInjectorService,
        public $hibachi,
        public utilityService
    ){
        super($injector,$hibachi,utilityService,'Schedule');

    }

    public clearSchedulePreview =()=>{
        this.schedulePreview = {};
    };

    private addSchedulePreviewItem = (cdate:any, longMonthName:boolean = true):void=>{
        var weekday =  [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
        var month = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
        var monthShort = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];
        var currentDate = (cdate.getMonth() + 1)+'-'+cdate.getDate()+'-'+cdate.getFullYear();
        if(this.schedulePreview[currentDate]  === undefined ){
            this.schedulePreview[currentDate] = {
                day: cdate.getDate(),
                month: (longMonthName) ? month[cdate.getMonth() + 1] : monthShort[cdate.getMonth() + 1],
                year: cdate.getFullYear(),
                weekday: weekday[cdate.getDay()],
                times: []
            }
        }
        this.schedulePreview[currentDate].times.push(cdate.toLocaleTimeString());
    };

    public buildSchedulePreview =(scheduleObject:any, totalOfPreviews:number=10):any=>{
        this.clearSchedulePreview();
        var startTime = new Date(<any>Date.parse(scheduleObject.frequencyStartTime));
        var endTime = (scheduleObject.frequencyEndTime.trim()) ? new Date(<any>Date.parse(scheduleObject.frequencyEndTime)) : false;
        var now = new Date();
        var startPoint = new Date();
        startPoint.setHours(startTime.getHours());
        startPoint.setMinutes(startTime.getMinutes());
        startPoint.setSeconds(startTime.getSeconds());
        var daysToRun = [];

        if(scheduleObject.recuringType == 'weekly'){
            daysToRun = scheduleObject.daysOfWeekToRun.toString().split(',');
            if(!daysToRun.length || scheduleObject.daysOfWeekToRun.toString().trim() == '') {
                return this.schedulePreview;
            }
        }

        if(scheduleObject.recuringType == 'monthly'){
            daysToRun = scheduleObject.daysOfMonthToRun.toString().split(',');
            if(!daysToRun.length || !scheduleObject.daysOfWeekToRun || scheduleObject.daysOfWeekToRun.toString().trim() == '') {
                return this.schedulePreview;
            }
        }

        var datesAdded = 0;
        for (var i =0;;i++){
            if(datesAdded >= totalOfPreviews || i >= 500) break;

            var timeToadd = (scheduleObject.frequencyInterval && scheduleObject.frequencyInterval.toString().trim()) ? (scheduleObject.frequencyInterval * i) * 60000 : i * 24 * 60 * 60 * 1000;
            var currentDatetime = new Date(startPoint.getTime() + timeToadd);
            if(currentDatetime < now) continue;

            if(scheduleObject.recuringType == 'weekly'){
                if(daysToRun.indexOf((currentDatetime.getDay()+1).toString())==-1) continue;
            }else if(scheduleObject.recuringType == 'monthly'){
                if(daysToRun.indexOf(currentDatetime.getDate().toString())==-1) continue;
            }
            if(!endTime) {
                this.addSchedulePreviewItem(currentDatetime);
                datesAdded++;
            }else {
                if (this.utilityService.minutesOfDay(startTime) <= this.utilityService.minutesOfDay(currentDatetime)
                    && this.utilityService.minutesOfDay(endTime) >= this.utilityService.minutesOfDay(currentDatetime)) {
                    this.addSchedulePreviewItem(currentDatetime);
                    datesAdded++;
                }
            }

        }
        return this.schedulePreview;
    }
}
export {ScheduleService};