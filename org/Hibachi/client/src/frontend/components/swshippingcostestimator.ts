/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
declare var hibachiConfig:any;

class SWShippingCostEstimatorController {
    private hibachiScope;
    private address;
    private skuCode
    //@ngInject
    constructor(private $log, public $rootScope) {
        this.$rootScope = $rootScope;
        this.hibachiScope = this.$rootScope.hibachiScope;

        if (this.address != undefined){

        }
        if (this.skuCode != undefined){

        }
    }
}

class SWShippingCostEstimator implements ng.IDirective {
    
    public restrict: string = 'E';
    public scope: any;
    public bindToController = {
        address: "=",
        skucode: "=",
        templateUrl: "@"
    };
    public controller = SWShippingCostEstimatorController
    public controllerAs = "SwShippingCostEstimatorController";
    public templatePath: string = "";
    public url: string = "";
    public $compile;
    public path: string;
    
    // @ngInject
    constructor(hibachiPathBuilder, $compile) {
        if(!hibachiConfig){
            hibachiConfig = {};    
        }
        
        if (!hibachiConfig.customPartialsPath) {
            hibachiConfig.customPartialsPath = 'custom/client/src/frontend/';
        }

        this.templatePath = hibachiConfig.customPartialsPath;
        this.url = hibachiConfig.customPartialsPath + 'shippingcostestimator.html';
        this.$compile = $compile;
    }
    
    


    public static Factory(): ng.IDirectiveFactory {
        var directive: ng.IDirectiveFactory = (
            hibachiPathBuilder,
            $compile
        ) => new SWShippingCostEstimator(
            hibachiPathBuilder,
            $compile
        );
        directive.$inject = [
            'hibachiPathBuilder',
            '$compile'
        ];
        return directive;
    }
}
export {SWShippingCostEstimatorController, SWShippingCostEstimator};
    
    
