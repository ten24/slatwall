/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class DateFilter{
    //@ngInject
    public static Factory($log,$filter){
        return (date,dateString)=>{
            return $filter('date')(Date.parse(date),dateString);
        }
    }
    
}
export {
    DateFilter
};