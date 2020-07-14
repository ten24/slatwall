import { MonatAlertService } from "./monatAlertService";

/**
 * Interceptor to queue HTTP requests.
 * Logic is put together form answers here https://stackoverflow.com/questions/14464945/add-queueing-to-angulars-http-service
 */
class MonatHttpQueueInterceptor implements ng.IHttpInterceptor {
	private queueMap;

	private config = {
		methods: ['POST', 'PUT', 'PATCH'],
	};

	//@ngInject
	constructor(    
	    private $q  : ng.IQService, 
	    private $timeout : ng.ITimeoutService,
	    private monatAlertService: MonatAlertService,
	) {
		this.queueMap = {};
	}

	/**
	 * Shifts and executes the top function on the queue (if any).
	 * Note this function executes asynchronously (with a timeout of 1). This
	 * gives 'response' and 'responseError' chance to return their values
	 * and have them processed by their calling 'success' or 'error' methods.
	 * This is important if 'success' involves updating some timestamp on some
	 * object which the next message in the queue relies upon.
	 *
	 */
	private dequeue(config) {
		if (!this.queueableRequest(config)) {
			return;
		}

		this.$timeout( () => {
			let queue = this.getRequestQueue(config);
			queue.shift();
			if (queue.length > 0) queue[0]();
		}, 1);
	}

	/**
	 * for each unique type of request we're creating a different queue,
	 * currently the logic relies on the API-endpoint
	*/
	public getRequestQueue(request: ng.IRequestConfig) {
		let key = request.url || 'default';

		if (!this.queueMap.hasOwnProperty(key)) this.queueMap[key] = [];

		return this.queueMap[key];
	}

	/**
	 * Currently we're checking for only POST, PUT, and PATCH requests,
	 * or there can be an extra config on the request like --> $http.get(url, { processInQueue: true})
	*/
	public queueableRequest(config): boolean {
		return this.config?.methods?.indexOf(config.method) !== -1 || config.processInQueue || false;
	}

	/**
	 * Blocks quable request on thir specific-queue. If the first request, processes immediately.
	*/
	public request = (config : ng.IRequestConfig): ng.IRequestConfig | ng.IPromise<ng.IRequestConfig> => {
        
		if (this.queueableRequest(config) ){
			let deferred = this.$q.defer<ng.IRequestConfig>();
			let queue = this.getRequestQueue(config);

			queue.push(() => deferred.resolve(config));
			if (queue.length === 1) queue[0]();

			return deferred.promise;
		}

		return config;
	};

	/**
     * response?: <T>(response: IHttpPromiseCallbackArg<T>) => IPromise<T>|T;
	 * After each response completes, unblocks the next eligible request
	*/
	public response = (response: ng.IHttpPromiseCallbackArg<any>): any => {
		this.dequeue(response.config);
		return response;
	};
	

    /**
	 * requestError?: (rejection: any) => any;
	 * After each request-error, unblocks the next eligible request
	*/
	public requestError = (rejection) => {
		return this.handleError(rejection);
	};
	
	/**
	 * responseError?: (rejection: any) => any;
	 * After each response-error, unblocks the next eligible request
	*/
	public responseError = (rejection) => {
		return this.handleError(rejection);
	};
	
	private handleError = (rejection) => {
	    this.dequeue(rejection.config);
	    
        /**
            data?:  ==> {
                data?:
                messages: [ 
                            {   
                                key: [] 
                            }, 
                            { 
                                key2: [] 
                            } 
                        ],
                errors: { 
                            'key'   :  [ssdsds, sdsdsd, dsdsdsd ],
                            'key2'  :  [dfwfw,sfdwrv,frgebtt,qfrbe]
                        },
                        
                successfulActions: [gufyg, gufg],
                
                failureActions: [vgjhkj, ytguhijkl],
                
                [string]xxx-key : [any] value
            }
            
        */
         
        //handle statuses, logout, format-messages
        if (rejection?.status === 401) {
            // loggedout, notify
        } 
        else if (rejection?.status === 500) {
            
            rejection.data = { 
                originalResponse    : rejection.data || {},
                successfulActions   : [],
                failureActions      : [],
                messages            : [],
                errors              : { 'server': [ 'An internal error occurred, please try again'] }
            }
        }
        
	    return this.$q.reject(rejection);
	}
}

export { MonatHttpQueueInterceptor };
