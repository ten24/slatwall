/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWLoading{
    public static Factory(){
        var directive = (
            $log,
            corePartialsPath,
            hibachiPathBuilder
        )=> new SWLoading(
            $log,
            corePartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = [
            '$log',
            'corePartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    }
    constructor(
        $log,
        corePartialsPath,
        hibachiPathBuilder
    ){
        return {
            restrict: 'A',
            transclude:true,
            templateUrl:hibachiPathBuilder.buildPartialsPath(corePartialsPath)+'loading.html',
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