/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWCardListItemController {
    public strong:string = 'false';
    public style:string = 'padding-top:5px;padding-bottom:5px';

	//@ngInject
    constructor(private $log) {}

    public $onInit = function() {};

} 

class SWCardListItem implements ng.IComponentOptions {
    public controller:any=SWCardListItemController;
    public controllerAs:string = 'SwCardListItemController';
    public bindings:{[key: string]:string} = {
       title: "@?",
       value: "@?",
       strong: "@?",
       style: "@?"
    };
    public transclude:boolean = true;
    public require:string = "^SWCardView";
    public template:string = `
        <li ng-transclude style="border-bottom:1px solid #eee;">
            <div class="row s-line-item {{(SwCardListItemController.strong == 'true')?'s-strong':''}}" style="{{(SwCardListItemController.style)}}">
                <div class="col-xs-6 s-title">{{SwCardListItemController.title}}:</div>
                <div class="col-xs-6 s-value">{{SwCardListItemController.value}}</div>
            </div>
        </li>
            `;
    constructor() {}
    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        return new SWCardListItem();
    }
}
export {SWCardListItemController, SWCardListItem};