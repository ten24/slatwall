/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

declare var hibachiConfig:any;

class SWFFileInput implements ng.IDirective {
    public restrict: string = 'A';

    // @ngInject
    constructor( public $parse) {
    }

    // @ngInject
    public link: ng.IDirectiveLinkFn = (scope, element, attrs : any) => {
        var model = this.$parse(attrs.fileModel);
        element.bind('change', ()=>{
            scope.$apply( ()=>{
                var firstElement : any = element[0];
                if(firstElement.files != undefined){
                    model.assign(scope,firstElement.files[0]);
                }
            });
        });
    };

    public static Factory(): ng.IDirectiveFactory {
        var directive: ng.IDirectiveFactory = ($parse) => new SWFFileInput($parse);
        directive.$inject = [
            '$parse'
        ];
        return directive;
    }
}
export { SWFFileInput };