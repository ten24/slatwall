/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />



class EntityRBKey{
    public $slatwall;
    //@ngInject
    
    public static Factory($slatwall){
        return (text:string)=>{
            if(angular.isDefined(text) && angular.isString(text)){
                text = text.replace('_', '').toLowerCase();
                text = $slatwall.getRBKey('entity.'+text);
                
            }
            return text;
        }
    }
    
}
export {
    EntityRBKey
};