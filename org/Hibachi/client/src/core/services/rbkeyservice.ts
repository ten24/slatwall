/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class RbKeyService{

    public _resourceBundle = {};
	public _resourceBundleLastModified = '';
	public _loadingResourceBundle = false;
	public _loadedResourceBundle = false;
    //@ngInject
    constructor(
        public $http:ng.IHttpService,
        public $q:ng.IQService,
        public appConfig:any
    ){
        this.$q = $q;
        this.$http = $http;
        this.appConfig = appConfig;
    }
    getRBLoaded= () => {
		return this._loadedResourceBundle;
	}
	getResourceBundles= () => {
		////$log.debug('hasResourceBundle');
		////$log.debug(this._loadedResourceBundle);
		//$log.debug(this.getConfigValue('rbLocale').split('_'));
        var rbLocale = this.appConfig.rbLocale.split('_');
		var localeListArray = rbLocale;
		var rbPromise;
		var rbPromises = [];
		rbPromise = this.getResourceBundle(this.appConfig.rbLocale);
		rbPromises.push(rbPromise);
		if(localeListArray.length === 2) {
			//$log.debug('has two');
			rbPromise = this.getResourceBundle(localeListArray[0]);
			rbPromises.push(rbPromise);
		}
		if(localeListArray[0] !== 'en') {
			//$log.debug('get english');
			this.getResourceBundle('en_us');
			this.getResourceBundle('en');
		}
		var resourceBundlePromises = this.$q.all(rbPromises).then((data) => {

		},(error) =>{
		});
		return resourceBundlePromises;

	}

    rbKey= (key,replaceStringData) => {
		////$log.debug('rbkey');
		////$log.debug(key);
		////$log.debug(this.getConfig().rbLocale);

		var keyValue = this.getRBKey(key,appConfig.rbLocale);
		////$log.debug(keyValue);

		return keyValue;
	}
	getRBKey= (key:string,locale?:string,checkedKeys?:string,originalKey?:string) => {
		////$log.debug('getRBKey');
		////$log.debug('loading:'+this._loadingResourceBundle);
		////$log.debug('loaded'+this._loadedResourceBundle);

		if(!this._loadingResourceBundle && this._loadedResourceBundle) {

			key = key.toLowerCase();
			checkedKeys = checkedKeys || "";
			locale = locale || 'en_us';
			////$log.debug('locale');
			////$log.debug(locale);

			var keyListArray = key.split(',');
			////$log.debug('keylistAray');
			////$log.debug(keyListArray);
			if(keyListArray.length > 1) {
				var keyValue:string = "";

				for(var i=0; i<keyListArray.length; i++) {

					keyValue = this.getRBKey(keyListArray[i], locale, keyValue);
					//$log.debug('keyvalue:'+keyValue);

					if(keyValue.slice(-8) != "_missing") {
						break;
					}
				}

				return keyValue;
			}


			var bundle = this.getResourceBundle(locale);
			//$log.debug('bundle');
			//$log.debug(bundle);
			if(!bundle.then) {
				if(angular.isDefined(bundle[key])) {
					//$log.debug('rbkeyfound:'+bundle[key]);
					return bundle[key];
				}


				var checkedKeysListArray = checkedKeys.split(',');
				checkedKeysListArray.push(key+'_'+locale+'_missing');

				checkedKeys = checkedKeysListArray.join(",");
				if(angular.isUndefined(originalKey))  {
					originalKey = key;
				}
				//$log.debug('originalKey:'+key);
				//$log.debug(checkedKeysListArray);

				var localeListArray = locale.split('_');
				//$log.debug(localeListArray);
				if(localeListArray.length === 2)  {

					bundle = this.getResourceBundle(localeListArray[0]);
					if(angular.isDefined(bundle[key])) {
						//$log.debug('rbkey found:'+bundle[key]);
						return bundle[key];
					}

					checkedKeysListArray.push(key+'_'+localeListArray[0]+'_missing');
					checkedKeys = checkedKeysListArray.join(",");
				}

				var keyDotListArray = key.split('.');
				if( keyDotListArray.length >= 3
					&& keyDotListArray[keyDotListArray.length - 2] === 'define'
				) {
					var newKey = key.replace(keyDotListArray[keyDotListArray.length - 3]+'.define','define');
					//$log.debug('newkey1:'+newKey);
					return this.getRBKey(newKey,locale,checkedKeys,originalKey);
				}else if( keyDotListArray.length >= 2 && keyDotListArray[keyDotListArray.length - 2] !== 'define')  {
					var newKey = key.replace(keyDotListArray[keyDotListArray.length -2]+'.','define.');
					//$log.debug('newkey:'+newKey);
					return this.getRBKey(newKey,locale,checkedKeys,originalKey);
				}
				//$log.debug(localeListArray);

				if(localeListArray[0] !== "en")  {
					return this.getRBKey(originalKey,'en',checkedKeys);
				}
				return checkedKeys;
			}
		}
		return '';
	}
    getResourceBundle= (locale) => {
		var deferred = this.$q.defer();
		var locale = locale || this.appConfig.rbLocale;

		if(this._resourceBundle[locale]) {
			return this._resourceBundle[locale];
		}

		var urlString = this.appConfig.baseURL+'/index.cfm/?slatAction=api:main.getResourceBundle&instantiationKey='+this.appConfig.instantiationKey+'&locale='+locale;

		this.$http(
			{
				url:urlString,
				method:"GET"
			}
		).success((response:any,status,headersGetter) => {
			this._resourceBundle[locale] = response.data;
            console.log(this._resourceBundle);
			deferred.resolve(response);
		}).error((response:any) => {
			this._resourceBundle[locale] = {};
			deferred.reject(response);
		});
		return deferred.promise
	}

}
export {
    RbKeyService
};