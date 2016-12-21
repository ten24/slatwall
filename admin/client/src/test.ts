/// <reference path='../typings/slatwallTypescript.d.ts' />
/// <reference path='../typings/tsd.d.ts' />
/*jshint browser:true */

import {BaseBootStrapper} from "../../../org/Hibachi/client/src/basebootstrap";
import {slatwalladminmodule} from "./slatwall/slatwalladmin.module";
declare var require;

//custom bootstrapper
class bootstrapper extends BaseBootStrapper{
    public myApplication;
    constructor(){
        var angular:any = super(slatwalladminmodule.name);
        var requireAll = function(requireContext) {
            return requireContext.keys().map(requireContext);
        }
        require('../../../node_modules/jasmine-core/lib/jasmine-core/boot');
        requireAll(require.context("../../../", true, /^\.\/.*\.spec.ts$/));
    }


}

export = new bootstrapper();



