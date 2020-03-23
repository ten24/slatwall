declare var hibachiConfig;

/**
 * Interceptor to queue HTTP requests.
 * Logic is put together form answers here https://stackoverflow.com/questions/14464945/add-queueing-to-angulars-http-service
 */
class MonatHttpQueueInterceptor {
	private queueMap;

	private config = {
		methods: ['POST', 'PUT', 'PATCH'],
	};

	//@ngInject
	constructor(private $q) {
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

		setTimeout(() => {
			let queue = this.getRequestQueue(config);
			queue.shift();
			if (queue.length > 0) queue[0]();
		}, 1);
	}

	/**
	 * for each unique type of request we're creating a different queue,
	 * currently the logic relys on the API-endpoint
	 */
	public getRequestQueue(request) {
		let key = request.url || 'default';

		if (!this.queueMap.hasOwnProperty(key)) this.queueMap[key] = [];

		return this.queueMap[key];
	}

	/**
	 * Currently we're checking for only POST, PUT, and PATCH requests,
	 * or there can be an extra config on the request like --> $http.get(url, { processInQueue: true})
	 */

	public queueableRequest(config): boolean {
		return this.config.methods.indexOf(config.method) !== -1 || config.processInQueue;
	}

	/**
	 * Blocks quable request on thir specific-queue. If the first request, processes immediately.
	 */
	public request = (config) => {
		if (this.queueableRequest(config)) {
			let deferred = this.$q.defer();
			let queue = this.getRequestQueue(config);

			queue.push(() => deferred.resolve(config));
			if (queue.length === 1) queue[0]();

			return deferred.promise;
		}

		return config;
	};

	/**
	 * After each response completes, unblocks the next eligible request
	 */
	public response = (response) => {
		this.dequeue(response.config);
		return response;
	};

	/**
	 * After each response error, unblocks the next eligible request
	 */
	public responseError = (error) => {
		this.dequeue(error.config);
		return this.$q.reject(error);
	};
}

export { MonatHttpQueueInterceptor };
