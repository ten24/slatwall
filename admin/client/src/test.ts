/// <reference path='../typings/slatwallTypescript.d.ts' />
/// <reference path='../typings/tsd.d.ts' />
/*jshint browser:true */
import {BaseBootStrapper} from "../../../org/Hibachi/client/src/basebootstrap";
import {slatwalladminmodule} from "./slatwall/slatwalladmin.module";
declare var window:any;
declare var require:any;
//custom bootstrapper
class bootstrapper extends BaseBootStrapper{
    public myApplication;

    constructor(){

        var angular:any = super(slatwalladminmodule.name);
        angular.done(function() {
            //angular.element('#loading').hide();
            require('../../../node_modules/jasmine-core/lib/jasmine-core/boot');
            require('angular-mocks');
            var requireAll = function(requireContext) {
                return requireContext.keys().map(requireContext);
            }
            requireAll(require.context("../../../", true, /^\.\/.*\.spec.ts$/));
            require('../../../org/Hibachi/client/src/listing/services/listingservice.spec');
            window.onload();
        });
        angular.bootstrap();


    }
}

export = new bootstrapper();




