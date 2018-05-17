// important to use "any" to allow methods of upgraded service to be call
/*export abstract class Parse {
    [key:string]: any;    
}*/

/*export abstract class Log {
    [key:string]: any;    
}*/

/*export abstract class Filter {
    [key:string]: any;    
}*/

// define factory function to return Angularjs Service
export function parseFactory(i:any) {
    return i.get("$parse");    
}

export function logFactory(i:any)  {
    return i.get("$log");    
}

export function filterFactory(i:any) {
    return i.get("$filter");    
}

export function timeoutFactory(i:any) {
    return i.get('$timeout');    
}

export function qFactory(i:any) {
    return i.get("$q");    
}

// define angular factory provider
export const parseProvider = {
    provide    : '$parse',
    useFactory : parseFactory,
    deps       : ['$injector']//The deps property is an array of provider tokens. The injector resolves these tokens and injects the corresponding services into the matching factory function parameters.
};

export const logProvider = {
    provide    : '$log',
    useFactory : logFactory,
    deps       : ["$injector"]    
};

export const filterProvider = {
    provide    : '$filter',
    useFactory : filterFactory,
    deps       : ["$injector"]  
};

export const timeoutProvider = {
    provide    : '$timeout',
    useFactory : timeoutFactory,
    deps       : ["$injector"]    
};

export const qProvider = {
    provide    : '$q',
    useFactory : qFactory,
    deps       : ['$injector']    
};