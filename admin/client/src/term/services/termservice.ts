/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
export class TermService { 


    //@ngInject
    constructor(public $hibachi){

    }
    
    public getTermScheduledDates = (term:any, startDate:Date, iterations=6) =>{
     
        var currentDate = startDate;
        var scheduleDates = [];
        scheduleDates.push(currentDate);
     
        iterations--;
     
        for(var i=0; i<iterations; i++){
            currentDate = this.getEndDate(term, currentDate);
            scheduleDates.push(currentDate);
        }
        
        return scheduleDates;
        
    }
    
    
    public getEndDate = (term:any, startDate:Date) => {
        
        var endDate = new Date(startDate.getTime());
        
        if(term.termHours != null){
            endDate.setHours(startDate.getHours() + term.termHours);
        }
    
        if(term.termDays != null){
            endDate.setDate(startDate.getDate() + term.termDays);
        }
        
        if(term.termWeeks != null){
            endDate.setDate(startDate.getDate() + (term.termWeeks * 7));
        }
        
        if(term.termMonths != null){
            endDate.setMonth(startDate.getMonth() + term.termMonths);
        }
        
        if(term.termYears != null){
            endDate.setFullYear(startDate.getFullYear() + term.termYears);
        }
        
        return endDate;
    }
}