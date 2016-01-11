/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />



class EntityRBKey{
    public $hibachi;
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