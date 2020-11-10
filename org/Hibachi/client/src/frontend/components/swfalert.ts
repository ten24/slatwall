/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
declare var hibachiConfig:any;

class SWFAlertController{
    //@ngInject
    public alertDisplaying:boolean = false;
    public alertTrigger:string;
    public alertType:string;
    public duration:number = 2;
    public message:string;
    
    constructor(private $rootScope, private $timeout, private $scope, private observerService){
        this.$rootScope = $rootScope;
        this.observerService.attach(this.displayAlert, this.alertTrigger);
    }
    
    public $oninit=()=>{
        
    }
    
    public displayAlert=()=>{
        this.alertDisplaying = true;
         this.$timeout(()=>{
            this.alertDisplaying = false;
        },this.duration * 1000);
    }
}

class SWFAlert{
    public restrict: string = 'EA';
    public scope = {};
    public bindToController = {
                alertTrigger:'@?',
                alertType: '@?',
                duration: '<?',
                message: '@?'
    };
    public controller = SWFAlertController
    public controllerAs = "swfAlert";
    public templateUrl: string = "";
    public url: string = "";
    public $compile;
    public path: string;
    
    
    
    //@ngInject
    constructor( public coreFrontEndPartialsPath, public hibachiPathBuilder) {
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.coreFrontEndPartialsPath) + "swfalert.html";
    }
    
    public static Factory(): ng.IDirectiveFactory {
        var directive: ng.IDirectiveFactory = (
            coreFrontEndPartialsPath,
            hibachiPathBuilder
        ) => new SWFAlert(
            coreFrontEndPartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = [
            'coreFrontEndPartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    }
}
export{
    SWFAlert,
    SWFAlertController
}
