/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class DateFilter{
    //@ngInject
    public static Factory($filter){
        return (date,dateString)=>{
            return $filter('date')(new Date(date),dateString);
        }
    }
    
}
export {
    DateFilter
};