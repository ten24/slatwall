
/**
 * 
 * error TS2686: 'angular' refers to a UMD global, but the current file is a module. Consider adding an import instead.
 * 
 * Solution
 * 
 * https://stackoverflow.com/a/42035067
 * 
 */

import 'angular';

declare global {
    const Chart: typeof Chart;

    declare module angular {
        export interface IAngularStatic {
            lazy(app: any, modules?: any): any;
        }
    }

}
