export class MonatService { 
	
	public cart;
	
	//@ngInject
	constructor(public publicService, public $q){
	
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
}