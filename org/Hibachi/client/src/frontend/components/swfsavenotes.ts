/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWFSaveNotesController{
    public swfForm;
    public swfNavigation;
    //@ngInject
    constructor($rootScope){
    }
    
    public save = ()=>{
        this.swfForm.submitForm().then(result=>{
            if(result.successfulActions && result.successfulActions.length){
                this.swfNavigation.showTab('review');
            }
        })
    }
    
}
 
class SWFSaveNotes{
    public static Factory(){
        var directive = (
            $rootScope
        )=> new SWFSaveNotes(
            $rootScope
        );
        directive.$inject = ['$rootScope'];
        return directive;
    }
    
    //@ngInject
    constructor(
        $rootScope
    ){
        return {
            controller:SWFSaveNotesController,
            controllerAs:"swfSaveNotes",
            bindToController: {
            },
            restrict: "A",
            require:{
                swfNavigation:'^swfNavigation',
                swfForm:'^swfForm'
            },
            link: function() {
            }
        };
    }
}
export{
    SWFSaveNotesController,
    SWFSaveNotes
}
