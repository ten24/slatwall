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


import { Component, Input, OnInit, ElementRef, AfterViewInit, Renderer } from '@angular/core';
import { RbKeyService } from '../../core/services/rbkeyservice';

@Component({
    selector   : '[sw-tooltip]',
    templateUrl: '/org/Hibachi/client/src/core/components/tooltip.html'   
})
export class SwTooltip implements OnInit, AfterViewInit {    
    @Input() rbkey;
    @Input() text;
    @Input() position;
    @Input() showtooltip:boolean = false;
    //elementRef:HTMLElement;
    
    constructor(
        private elementRef : ElementRef, 
        private rbkeyService: RbKeyService,
        private renderer: Renderer ) 
    {
        //this.elementRef = elementRef.nativeElement;   
        
    }
    
    ngOnInit() {

        if(this.rbkey){
            this.text = this.rbkeyService.getRBKey(this.rbkey);
        }
        if(!this.position){
            this.position = "top";
        }
     }
    
     ngAfterViewInit() {
        let tooltip = this.elementRef.nativeElement.getElementsByClassName("tooltip");
        let leftPosition = tooltip[0].offsetLeft;
        let topPosition = tooltip[0].offsetTop;
        let tooltipHeight = tooltip[0].offsetHeight;

        let tooltip_icon = this.elementRef.nativeElement.getElementsByClassName("tooltip_icon");
        let iconLeftPosition = tooltip_icon[0].offsetLeft;
        let iconTopPosition = tooltip_icon[0].offsetTop;

        let tooltipStyle = getComputedStyle(tooltip[0]);//.style; 
        if(this.position){
          switch(this.position.toLowerCase()){
              case 'top':
                this.renderer.setElementStyle(tooltip[0], 'top', topPosition + (topPosition - iconTopPosition) + 'px');
                this.renderer.setElementStyle(tooltip[0], 'left',  ( iconLeftPosition + 5 ) + 'px');
                break; 
              case 'bottom':
                //where the element is rendered to begin with
                break;
              case 'left': 
                this.renderer.setElementStyle(tooltip[0], 'top', (topPosition + (topPosition - iconTopPosition) + (tooltipHeight/2)+5) + 'px' );
                this.renderer.setElementStyle(tooltip[0], 'left', (-1 * ( iconLeftPosition ) )+ 'px');
                let tooltip_inner = this.elementRef.nativeElement.getElementsByClassName("tooltip-inner");
                this.renderer.setElementStyle(tooltip_inner[0], 'maxWidth',  'none');
                break;
              default: 
              //right is the default
                this.renderer.setElementStyle(tooltip[0], 'top', (topPosition + (topPosition - iconTopPosition) + (tooltipHeight/2)+5) + 'px');
                this.renderer.setElementStyle(tooltip[0], 'left',  ( iconLeftPosition + 10 ) + 'px');
          }   
      }        
    }

    show = () =>{
        this.showtooltip = true; 
    }
    
    hide = () =>{
        this.showtooltip = false; 
    }
}