/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class AggregateFilter{
    //@ngInject
    public static Factory($filter){
        return (property)=>{
            
            return property.filter((item:any)=>{
                if(item.fieldtype && item.fieldtype !== 'id'){
                    return false;
                }
                if(item.ormtype && ['big_decimal','double','float','integer'].indexOf(item.ormtype) < 0){
                    return false;
                }
                return true;
            });
        }
    }

}
export {
    AggregateFilter
};