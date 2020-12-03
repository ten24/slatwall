import { 
    PublicService as PublicServiceCore,
    PublicRequest
} from "@Hibachi/core/core.module";

export class PublicService extends PublicServiceCore {
    
    //@ngInject
    constructor(
        public $http:ng.IHttpService,
        public $q:ng.IQService,
        public $window:any,
        public $location:ng.ILocationService,
        public $hibachi:any,
        public $injector:ng.auto.IInjectorService,
        public $httpParamSerializer,
        public requestService,
        public accountService,
        public accountAddressService,
        public cartService,
        public orderService,
        public observerService,
        public appConfig,
        public $timeout,
        public hibachiAuthenticationService,
    	public sessionStorageCache,
    	public inMemoryCache
    ) {
        super(
            $http,
            $q,
            $window,
            $location,
            $hibachi,
            $injector,
            $httpParamSerializer,
            requestService,
            accountService,
            accountAddressService,
            cartService,
            orderService,
            observerService,
            appConfig,
            $timeout,
            hibachiAuthenticationService,
        	sessionStorageCache,
        	inMemoryCache
        );
    }
    
    
    /** this is the generic method used to call all server side actions.
     *  @param action {string} the name of the action (method) to call in the public service.
     *  @param data   {object} the params as key value pairs to pass in the post request.
     *  @return a deferred promise that resolves server response or error. also includes updated account and cart.
    */
    /** this is the generic method used to call all server side actions.
    *  @param action {string} the name of the action (method) to call in the public service.
    *  @param data   {object} the params as key value pairs to pass in the post request.
    *  @return a deferred promise that resolves server response or error. also includes updated account and cart.
    */
    public doAction=(action:string, data:any={}, method:any='POST') => {
        
        ///Prevent sending the same request multiple times in parallel
        if(this.getRequestByAction(action) && this.loadingThisRequest(action, data, false)){
            return this.$q.when();
        }
        
        if (!action) {
            throw "Exception: Action is required";
        }
        
        if (!data) {
            data = {};
        }

        var urlBase = this.appConfig.baseURL;

        //check if the caller is defining a path to hit, otherwise use the public scope.
        if (action.indexOf(":") !== -1){
            urlBase = urlBase + action; //any path
        }else{
            urlBase = this.baseActionPath + action;//public path
        }

        if(angular.isDefined(this.cmsSiteID)){
            data.cmsSiteID = this.cmsSiteID;
        }

        //DISABLED ON MONAT
        // if(method == 'POST' && data.returnJsonObjects == undefined){
        //     data.returnJsonObjects = "cart,account";
        // }
            
            
        if (method == 'GET'){
            urlBase += (urlBase.indexOf('?') == -1) ? '?' : '&';
            urlBase += this.$httpParamSerializer(data);
            data = null;
        }

        
        let request = this.requestService.newPublicRequest(urlBase,data,method);

        request.promise.then((result:any)=>{
            this.processAction(result,request);
        }).catch((reason)=>{

        });

        this.requests[request.getAction()]=request;
        return request.promise;

    }
    
    /** accessors for account */
    public getAccount=(refresh=false): ng.IPromise<any> =>  {
        let urlBase = this.baseActionPath+'getAccount/';
        
        var deferred = this.$q.defer();
		var cachedAccount = this.getFromSessionCache("cachedAccount");
		
		if (refresh || !cachedAccount) {
		    
		    if(!this.accountDataPromise){
                this.accountDataPromise = this.getData(urlBase, "account", "");
            }
		    
			this.accountDataPromise
				.then((data) => {
					if (data?.account) {
						console.log("getAccount, putting it in session-cache");
						this.putIntoSessionCache("cachedAccount", { 'account' : data.account});
						deferred.resolve(data);
					} else {
						throw data;
					}
				})
				.catch((e) => {
					console.log("getAccount, exception, removing it from session-cache", e);
					this.removeFromSessionCache("cachedAccount");
					deferred.reject(e);
				});
		} else {
		    console.log('Getting from Cache', cachedAccount['account']);
		    this['account'].populate(cachedAccount['account']);
			deferred.resolve(cachedAccount);
		}
		return deferred.promise;

    }
    
    public processAction = (response,request:PublicRequest)=>{

        //Run any specific adjustments needed
        this.runCheckoutAdjustments(response);

        //if the action that was called was successful, then success is true.
        if (request && request.hasSuccessfulAction()){
            this.successfulActions = [];
            for (var action in request.successfulActions){
                this.successfulActions.push(request.successfulActions[action].split('.')[1]);
                if (request.successfulActions[action].indexOf('public:cart.placeOrder') !== -1){
                    this.$window.location.href = this.confirmationUrl;
                    return;
                }else if (request.successfulActions[action].indexOf('public:cart.finalizeCart') !== -1){
                    this.$window.location.href = this.checkoutUrl;
                    return;
                }else if(request.successfulActions[action].indexOf('public:account.logout') !== -1){
                    this.account = this.$hibachi.newAccount();
                }
            }
        }

        if(request && request.hasFailureAction()){
            this.failureActions = [];
            for (var action in request.failureActions){
                this.failureActions.push(request.failureActions[action].split('.')[1]);
            }
        }

        /** update the account and the cart */
        if(response.account){
            this.account.populate(response.account);
            this.account.request = request;
            this.putIntoSessionCache("cachedAccount", { 'account' : response.account});
        }
        if(response.cart){
            this.cart.populate(response.cart);
            this.cart.request = request;
            this.putIntoSessionCache("cachedCart", response.cart);
        }
        this.errors = response.errors;
        if(response.messages){
            this.messages = response.messages;
        }
    }
    
    
    /** accessors for states */
    public getData=(url, setter, param, method='post'):any =>  {
        

        let urlBase = url + param;
        let request = this.requestService.newPublicRequest(urlBase, null, method);

        request.promise.then((result:any)=>{
            // handle custom account redirect
            if (result['redirectTo']){
                if(result['redirectTo'] == 'default'){
                    result['redirectTo'] = '';
                }
                window.location.replace('/'+result['redirectTo']);
            }
            
                
            //don't need account and cart for anything other than account and cart calls.
            if ( setter.indexOf('account') == -1) {
                 
                if (result['account']){
                    this.putIntoSessionCache("cachedAccount", { 'account' : result['account'] });
                    delete result['account'];
                }
            }
            if ( setter.indexOf('cart') == -1) {
                if (result['cart']){delete result['cart'];}
            }
            
            if((setter == 'cart'||setter=='account') && this[setter] && this[setter].populate){
                //cart and account return cart and account info flat
                this[setter].populate(result[setter]);

            }else{
                //other functions reutrn cart,account and then data
                if(setter == 'states'){
                    this[setter]={};
                    this.$timeout(()=>{
                        this[setter]=(result);
                    });
                }else{
                    this[setter]=(result);
                }
            }

        }).catch((reason)=>{


        });

        this.requests[request.getAction()]=request;
        return request.promise;
    }
    
    
    

}