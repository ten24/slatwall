/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
declare var hibachiConfig:any;

class SWShippingCostEstimatorController {
    private hibachiScope;
    private address;
    private skuCode;
    public estimatedShippingRates:any;

    //@ngInject
    constructor(private $log, public $rootScope) {
        this.$rootScope = $rootScope;
        this.hibachiScope = this.$rootScope.hibachiScope;

        if ( this.skuCode && this.address ){
            this.getEstimatedShippingCosts(this.skuCode, this.address);
        }
        if ( this.skuCode && this.address ){
            this.getEstimatedShippingCosts(this.skuCode);
        }
    }

    /** Get the estimated shipping rates. */
    public getEstimatedShippingCosts = ( skuCode?:any, address?:any ) => {
        this.$rootScope.slatwall.doAction("getEstimatedShippingRates", {skuCode: skuCode, address: address||{}}).then((result)=>{
            if (result.estimatedShippingRates != undefined){
                this.estimatedShippingRates = result;
            }    
            else {
                this.estimatedShippingRates = [];
            }
        
        });
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
    
    
