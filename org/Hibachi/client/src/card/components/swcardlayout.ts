/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWCardLayoutController {
    
	//@ngInject
    constructor(private $log) {}

    public $onInit = function() {
    };

} 

class SWCardLayout implements ng.IComponentOptions {
    public controller:any=SWCardLayoutController;
    public controllerAs:string = 'SwCardLayoutController';
    public bindings = {
        cardClass: "@?"
    };
    
    public transclude:any = {
        cardView: '?swCardView',
    }
    
    /**
     * This is a wrapper class for the card components that allow you to define the columns.
     */
    public template:string = `
        <div class="{{SwCardLayoutController.cardClass}}">
            <!-- Cards are transcluded here -->
            <ng-transclude ng-transclude-slot="cardView"></ng-transclude>
        </div>`;
    
    constructor() {}
    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        return new SWCardLayout();
    }
}
export {SWCardLayoutController, SWCardLayout};