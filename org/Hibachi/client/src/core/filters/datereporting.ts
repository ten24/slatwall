/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class DateReporting{
    //@ngInject
    public static Factory($filter){
        return (date,periodInterval)=>{
            if(date.trim && date.trim().length===0){
                return '';
            }
            switch(periodInterval){
                case 'hour':
                    var dateArray = date.split('-');
                    return 'Hour #'+dateArray[3]+ ' of '+dateArray[1]+'/'+dateArray[2]+'/'+dateArray[0];
                case 'day':
                    var dateArray = date.split('-');
                    return dateArray[1]+'/'+dateArray[2]+'/'+dateArray[0];
                case 'week':
                    var dateArray = date.split('-');
                    return 'Week #'+dateArray[1]+ ' of '+dateArray[0];
                case 'month':
                    var dateArray = date.split('-');
                    
                    return dateArray[1]+'/'+dateArray[0];
                case 'year':
                    return date;
            }
            
        }
    }

}
export {
    DateReporting
};