/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWLoading{
    public static Factory(){
        var directive = (
            $log,
            corePartialsPath,
            hibachiPathBuilder
        )=> new SWLoading(
            $log,
            corePartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = [
            '$log',
            'corePartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    }
    constructor(
        $log,
        corePartialsPath,
        hibachiPathBuilder
    ){
        return {
            restrict: 'A',
            transclude:true,
            templateUrl:hibachiPathBuilder.buildPartialsPath(corePartialsPath)+'loading.html',
            scope:{
                swLoading:'='
            },
            link: (scope,attrs,element) =>{
            }
        };
    }
}
export{
    SWLoading
}


import { Component, Input, OnInit } from "@angular/core";

@Component({
    selector:  '[sw-loading]',
    template:  `<ng-content *ngIf="swloading" ></ng-content>
                <div class="s-loading-icon-fullwidth">
                    <i [hidden]="swloading" class="fa fa-refresh fa-spin"></i>
                </div>`  
})
export class SwLoading implements OnInit{
    @Input() swloading: any;
    
    constructor() {}
    
    ngOnInit() {
          
    }
}