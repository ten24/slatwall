class SWLoading{
    public static Factory(){
        var directive = (
            $log,
            partialsPath
        )=> new SWLoading(
            $log,
            partialsPath
        );
        directive.$inject = [
            '$log',
            'partialsPath'
        ];
        return directive;
    }
    constructor(
        $log,
        partialsPath
    ){
        return {
            restrict: 'A',
            transclude:true,
            templateUrl:partialsPath+'loading.html',
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