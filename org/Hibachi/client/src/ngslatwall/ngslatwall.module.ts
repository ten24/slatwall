/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/slatwallTypeScript.d.ts" />
import {hibachimodule} from "../hibachi/hibachi.module";
var ngSlatwall = angular.module('ngSlatwall',[hibachimodule.name])


    import {$Slatwall} from "./services/slatwallservice";
    var ngslatwallmodule = angular.module('ngSlatwall').provider('$slatwall',$Slatwall);
    export{
        ngslatwallmodule
    }
   

        
