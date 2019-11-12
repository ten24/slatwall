declare var hibachiConfig;

class MonatHttpInterceptor {

    //@ngInject
    constructor(private $injector, private $q) {}

    public request = (config) => {
        config.headers = config.headers || {};
        
        if(hibachiConfig){
            config.headers['SWX-siteCode'] = hibachiConfig.siteCode;
            config.headers['SWX-cmsSiteID'] = hibachiConfig.cmsSiteID;
        }
        return config;
    }
}

export{
	MonatHttpInterceptor
};