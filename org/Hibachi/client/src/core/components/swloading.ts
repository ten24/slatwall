/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWLoading{
    public static Factory(){
        var directive = (
            $log,
            corePartialsPath,
            pathBuilderConfig
        )=> new SWLoading(
            $log,
            corePartialsPath,
            pathBuilderConfig
        );
        directive.$inject = [
            '$log',
            'corePartialsPath',
            'pathBuilderConfig'
        ];
        return directive;
    }
    constructor(
        $log,
        corePartialsPath,
        pathBuilderConfig
    ){
        return {
            restrict: 'A',
            transclude:true,
            templateUrl:pathBuilderConfig.buildPartialsPath(corePartialsPath)+'loading.html',
            scope:{
                swLoading:'='
            },
            link: (scope,attrs,element) =>{
            }
        };
    }
}
export{
    SWLoading
}