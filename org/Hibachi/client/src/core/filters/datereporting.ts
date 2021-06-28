/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class DateReporting{
    //@ngInject
    public static Factory($filter){
        return (date,periodInterval,militaryTime=true)=>{
            if( !date?.trim?.()?.length ){
                return '';
            }
            
            switch(periodInterval){
                case 'hour':
                    var dateArray = date.split('-');
                    var  amOrPm = "am";

                    if(militaryTime){
                        return  dateArray[1]+'/'+dateArray[2] + " " + dateArray[3] + ":00";
                    }
                    
                    // covert from military to regular time
                    if(parseInt(dateArray[3], 10) > 12){
                        dateArray[3] = (parseInt(dateArray[3], 10) - 12).toString();
                        amOrPm = "pm";
                    }
                    
                    // remove leading zero
                    if(dateArray[3].charAt(0) === "0"){
                        dateArray[3] = dateArray[3].charAt(1);
                    }

                    return  dateArray[1]+'/'+dateArray[2] + " " + dateArray[3] + ":00 " + amOrPm;
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