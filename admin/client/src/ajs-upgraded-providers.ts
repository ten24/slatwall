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

export function httpFactory(i:any) {
    return i.get("$http");    
}

export function appConfigFactory(i:any){
    return i.get("appConfig");    
}

export function resourceBundlesFactory(i:any) {
    return i.get("resourceBundles");    
}

export function attributeMetaDataFactory(i:any) {
    return i.get("attributeMetaData");    
}

export function injectorFactory(i:any) {
    return i.get('$injector');    
}

export function windowFactory(i:any) {
    return i.get('$window');    
}

export function rootScopeFactory(i:any) {
    return i.get('$rootScope');
}

export function locationFactory(i:any){
    return i.get('$location');
}

export function anchorScrollFactory(i:any) {
    return i.get('$anchorScroll');
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

export const httpProvider = {
    provide    : '$http',
    useFactory : httpFactory,
    deps       : ["$injector"]  
};

export const appConfigProvider = {
    provide    : 'appConfig',
    useFactory : appConfigFactory,
    deps       : ["$injector"]    
};

export const resourceBundlesProvider = {
    provide    : "resourceBundles",
    useFactory : resourceBundlesFactory,
    deps       : ["$injector"]    
};

export const attributeMetaDataProvider = {
    provide    : "attributeMetaData",
    useFactory : attributeMetaDataFactory,
    deps       : ["$injector"]    
};

export const injectorProvider ={
    provide    : "$injector",
    useFactory : injectorFactory,
    deps       : ["$injector"]  
};

export const windowProvider = {
    provide    : "$window",
    useFactory : windowFactory,
    deps       : ["$injector"]    
};

export const rootScopeProvider ={
    provide    : "$rootScope",
    useFactory : rootScopeFactory,
    deps       : ["$injector"]    
};

export const locationProvider = {
    provide    : "$location",
    useFactory : locationFactory,
    deps       : ["$injector"]    
};

export const anchorScrollProvider = {
    provide    : "$anchorScroll",
    useFactory : anchorScrollFactory,
    deps       : ["$injector"]    
};