/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class EntityRBKey{
    //@ngInject
    public static Factory(rbkeyService){
        return (text:string)=>{
            if(angular.isDefined(text) && angular.isString(text)){
                text = text.replace('_', '').toLowerCase();
                text = rbkeyService.getRBKey('entity.'+text);
                
            }
            return text;
        }
    }
    
}
export {
    EntityRBKey
};