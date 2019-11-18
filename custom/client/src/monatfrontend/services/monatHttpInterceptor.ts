declare var hibachiConfig;

class MonatHttpInterceptor {

    //@ngInject
    constructor(private $injector, private $q) {}

    public request = (config) => {
        config.headers = config.headers || {};
        
        if(hibachiConfig){
            config.headers['SWX-siteCode'] = hibachiConfig.siteCode;
            config.headers['SWX-cmsSiteID'] = hibachiConfig.cmsSiteID;
            config.headers['SWX-cmsCategoryID'] = hibachiConfig.cmsCategoryID;
            config.headers['SWX-contentID'] = hibachiConfig.contentID;

        }
        return config;
    }
}

export{
	MonatHttpInterceptor
};