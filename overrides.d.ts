
/**
 * 
 * error TS2686: 'angular' refers to a UMD global, but the current file is a module. Consider adding an import instead.
 * 
 * Solution
 * 
 * https://stackoverflow.com/a/42035067
 * 
 */
import angular = require("angular");

declare global {
    // const angular: ng.IAngularStatic;
    // const Chart: typeof Chart;


    // interface Function {
    //     $inject?: ReadonlyArray<string>;
    // }


    // namespace angular {
    //     interface Function {
    //     }

    //     interface IAngularStatic {
    //         mock: IMockStatic;
    //     }
    // }


    /** 
     *
        interface IScope extends IRootScopeService {
            [x: string]: any;
        }
     * 
    */
}


export { };