interface IOptions{
	name:string;
	value:any;
}

declare var angular:any;

export class MonatService { 
	
	public cart;
	public cachedOptions = {
		frequencyTermOptions : <IOptions[]> null,
	};
	
	//@ngInject
	constructor(public publicService, public $q, public requestService){
	}
	
	public getCart(refresh = false){
		var deferred = this.$q.defer();
		if(refresh || angular.isUndefined(this.cart)){
			this.publicService.getCart(refresh).then(data =>{
				this.cart = data;
				deferred.resolve(this.cart);
			});
		}else{
			deferred.resolve(this.cart);
		}
		return deferred.promise;
	}
	
	/**
	 * options = {optionName:refresh, ---> option2:true, o3:false}
	*/ 
	public getOptions( options:{}, refresh = false){
		var deferred = this.$q.defer();
		var optionsToFetch = this.makeListOfOptionsToFetch(options, refresh);
		
		if(refresh || (optionsToFetch && optionsToFetch.length) ) {
			this.requestService
                .newPublicRequest('?slatAction=api:public.getOptions', {'optionsList' : optionsToFetch })
                .promise.then((data) =>{
                	var {messages, failureActions, successfulActions, ...realOptions} = data; //destructuring we dont want unwanted data in cached options
					this.cachedOptions = {...this.cachedOptions, ...realOptions}; // override and merge with old options
					this.sendOptionsBack(options, deferred);
					//TODO handle errors
				});
		} else {
			this.sendOptionsBack(options,deferred);
		}
		return deferred.promise;
	}
	
	private makeListOfOptionsToFetch(options:{}, refresh:boolean=false) {
		return Object.keys(options)
					.filter( key => refresh || !!options[key] || !(this.cachedOptions[key]) )
					.reduce( (previous, current) => {
						if(current) { previous = previous.length ? previous +","+ current : current; }
						return previous;
					}, "");
	}

	private sendOptionsBack(options:{}, deferred) {
		let res = Object.keys(options).reduce( (result, key) => (<any>Object).assign(result, { [key]: this.cachedOptions[key] }), {});
		deferred.resolve(res);
	}
	
	public getFrequencyTermOptions(refresh = false) {
		var deferred = this.$q.defer();
		if(refresh || !this.cachedOptions.frequencyTermOptions) {
			this.requestService
                .newPublicRequest('?slatAction=api:public.getFrequencyTermOptions')
                .promise.then(data =>{
					this.cachedOptions.frequencyTermOptions = data.frequencyTermOptions;
					deferred.resolve(this.cachedOptions.frequencyTermOptions);
				});
		} else {
			deferred.resolve(this.cachedOptions.frequencyTermOptions);
		}
		return deferred.promise;
	}
	
}