/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWTextCardViewController {
	public class;

	//@ngInject
    constructor(private $log) {}

} 

class SWTextCardView implements ng.IComponentOptions {
    public controller:any=SWTextCardViewController;
    public controllerAs:string = 'SwTextCardViewController';
    public bindings:{[key: string]:string} = {
            name : '<',
            value: '<'
    };
    
    public template:string = `
            <div class="col-sm-6 col-md-6 col-lg-4 s-detail-module s-md-content-block">
                <div class="s-md-content-block-inner">
                    <div class="s-title">{{SwTextCardViewController.name}}</div>
                    <div class="s-body">
                        {{SwTextCardViewController.value}}
                    </div>
                </div>
            </div>`;

    constructor() {}
    /**
     * Handles injecting the partials path into this class
     */
    public static Factory(){
        return new SWTextCardView();
    }
}
export {SWTextCardViewController, SWTextCardView};