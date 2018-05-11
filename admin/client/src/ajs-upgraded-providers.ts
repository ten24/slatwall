// important to use "any" to allow methods of upgraded service to be call
export abstract class Parse {
    [key:string]: any;    
}

export abstract class Log {
    [key:string]: any;    
}

// define factory function to return Angularjs Service
export function parseFactory(i:any) {
    return i.get("$parse");    
}

export function logFactory(i:any)  {
    return i.get("$log");    
}

// define angular factory provider
export const parseProvider = {
    provide    : Parse,
    useFactory : parseFactory,
    deps       : ['$injector']//The deps property is an array of provider tokens. The injector resolves these tokens and injects the corresponding services into the matching factory function parameters.
};

export const logProvider = {
    provide    : Log,
    useFactory : logFactory,
    deps       : ["$injector"]    
};