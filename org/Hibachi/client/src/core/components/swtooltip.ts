/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWTooltipController {

    public rbKey; 
    public text; 
    public position; 
    public showTooltip:boolean = false; 

    // @ngInject
	constructor(public rbkeyService){
        if(angular.isDefined(this.rbKey)){
            this.text = rbkeyService.getRBKey(this.rbKey);
        }
        if(angular.isUndefined(this.position)){
            this.position = "top";
        }
	}
    
    public show = () =>{
        this.showTooltip = true; 
    }
    
    public hide = () =>{
        this.showTooltip = false; 
    }
}

class SWTooltip implements ng.IDirective{

	public templateUrl;
    public transclude=true;
	public restrict = "EA";
	public scope = {}

	public bindToController = {
        rbKey:"@?",
        text:"@?",
        position:"@?",
        showTooltip:"=?"
	}
	public controller=SWTooltipController;
	public controllerAs="swTooltip";

    // @ngInject
	constructor( public $document, private corePartialsPath, hibachiPathBuilder){
	   this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "tooltip.html";
    }

	public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any, controller:any, transclude:any) => {
      var tooltip = element.find(".tooltip");
      var elementPosition= element.position(); 
      var tooltipStyle = tooltip[0].style; 
      if(attrs && attrs.position){
          switch(attrs.position.toLowerCase()){
              case 'top':
                tooltipStyle.top = "0px"; 
                tooltipStyle.left = "0px"; 
                break; 
              case 'bottom':
                //where the element is rendered to begin with
                break;
              case 'left': 
                tooltipStyle.top = (elementPosition.top + element[0].offsetHeight - 5)  + "px"; 
                tooltipStyle.left = (-1 * (elementPosition.left + element[0].offsetLeft - 5)) + "px";
                element.find(".tooltip-inner")[0].style.maxWidth = "none";
                break;
              default: 
              //right is the default
                tooltipStyle.top = (elementPosition.top + element[0].offsetHeight - 5) + "px"; 
                tooltipStyle.left = (elementPosition.left + element[0].offsetWidth - 5) + "px";
          }   
      }   
    }
    
	public static Factory(){
		var directive:ng.IDirectiveFactory = ($document,corePartialsPath,hibachiPathBuilder) => new SWTooltip($document,corePartialsPath,hibachiPathBuilder);
		directive.$inject = ["$document","corePartialsPath","hibachiPathBuilder"];
		return directive;
	}
}
export{
	SWTooltip,
	SWTooltipController
}
