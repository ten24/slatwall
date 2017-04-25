/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWCardViewController {

	//@ngInject
    constructor(private $log) {

    }

    public $onInit = () => {
        console.log("card onInit", this);
    }

} 

class SWCardView implements ng.IComponentOptions {
    public controller:any=SWCardViewController;
    public controllerAs:string = 'SwCardViewController';
    public bindings:{[key: string]:string} = {};
    public transclude:any = {
        'swCardHeader': 'div',
        'swCardBody': 'div'
    };

    public template:string = `
            <div class="col-sm-6 col-md-6 col-lg-4 s-detail-module s-md-content-block">
                <div class="s-md-content-block-inner">
                    <div class="s-title">
                        <div ng-transclude="swCardHeader">
                            <!---TITLE --->
                        </div>
                    </div>
                    <div class="s-body">
                        <div ng-transclude="swCardBody">
                            <!---BODY --->
                        </div>
                    </div>
                </div>
            </div>`;

    constructor() {}
    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        return new SWCardView();
    }
}
export {SWCardViewController, SWCardView};