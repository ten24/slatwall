/// <reference path='../../../../../org/Hibachi/client/typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../../org/Hibachi/client/typings/tsd.d.ts' />

declare var $;

class swfAccountController {
    public account;
    public accountData;
    public accountAge:number;
    public loading:boolean;
    public loadingOrders:boolean = false;
    public monthOptions:Array<number> = [1,2,3,4,5,6,7,8,9,10,11,12];
    public yearOptions:Array<number> = [];
    public currentYear;
    public countryCodeOptions;
    public stateCodeOptions = [];
    public selectedCountry;
    public userIsLoggedIn:boolean = false;
    public ordersOnAccount;
    public orderItems = [];
    public newAccountPaymentMethod
    public cachedCountryCode;
    public accountPaymentMethods;
    public editAddress;
    public isNewAddress:boolean;
    public newProductReview:any = {};
    public stars:Array<any> = ['','','','',''];
    public moMoneyBalance:number;
    public totalPages:Array<number>;
    public pageTracker:number = 1;
    public mostRecentFlexshipDeliveryDate:any;
    public editFlexshipUntilDate:any;
    public mostRecentFlexship:any;
    public holdingWishlist:any;
    public totalOrders:any;
    public ordersArgumentObject = {};
    public orderPayments:any;
    public uploadImageError:boolean;
    public accountProfileImage;
    public orderDelivery:any;
    public orderPromotions:any;
    public RAFGiftCard:any;
    public orderItemTotal:number = 0;
    public orderRefundTotal:any;
    public profileImageLoading:boolean = false;
    public prouctReviewForm:any;
    public isDefaultImage:boolean = false;
    public isNotProfileImagesChoosen:boolean = false;
    public purchasePlusTotal:number;
    public listPrice:number;
    public orderFees:number;
    
    // @ngInject
    constructor(
        public publicService,
        public $scope,
        public observerService,
        public ModalService, 
        public rbkeyService,
        public monatAlertService,
    	public $location,
    ){
        
        this.observerService.attach(this.loginSuccess,"loginSuccess"); 
        
        this.observerService.attach(this.closeModals,"addNewAccountAddressSuccess"); 
        this.observerService.attach(this.closeModals,"addAccountPaymentMethodSuccess"); 
        this.observerService.attach(this.closeModals,"addProductReviewSuccess"); 
        this.observerService.attach(this.closeModals,"impendingRenewalWarningSuccess"); 
        
        this.observerService.attach(option => this.holdingWishlist = option,"myAccountWishlistSelected"); 
        this.observerService.attach(()=>{
    		this.monatAlertService.error(this.rbkeyService.rbKey('frontend.deleteAccountPaymentMethodFailure'));
        },"deleteAccountPaymentMethodFailure");
        
        const currDate = new Date;
        this.currentYear = currDate.getFullYear();
        let manipulateableYear = this.currentYear;
        
        do {
            this.yearOptions.push(manipulateableYear++)
        }
        while(this.yearOptions.length <= 9);
    }
    
	public $onInit = () =>{
        this.getAccount();
        if(this.$location.search().orderid){
            this.getOrderItemsByOrderID();
        }
	}
	
	public addressVerificationCheck = ({addressVerification})=>{
		if(addressVerification && addressVerification.hasOwnProperty('success') && !addressVerification.success && addressVerification.hasOwnProperty('suggestedAddress')){
			this.launchAddressModal([addressVerification.address,addressVerification.suggestedAddress]);
		}
	}
        
	public loginSuccess = (data) =>{
    
	    if(data?.redirect){
	        if(data.redirect == 'default'){
	            data.redirect = '';
	        }else{
	            data.redirect = '/'+data.redirect;
	        }
	        window.location.href = data.redirect + '/my-account/';
	        return;
	    }
	    this.getAccount();
	    this.publicService.getCart(true);
	}
	
	private getRAFGiftCard = () => {
	    this.loading = true;
        this.publicService.doAction( 
            'getRAFGiftCard', 
            { accountID : this.accountData.accountID } 
        ).then(result=>{
            if ( 'undefined' !== typeof result.giftCard ) {
                for ( let i = 0; i < result.giftCard.transactions.length; i++ ) {
                    let transaction = result.giftCard.transactions[ i ];
                    
                    // Match everything up until 4 digit year.
                    let dateMatch = result.giftCard.transactions[ i ].createdDateTime.match(/.+?[0-9]{4}/g);
                    if ( dateMatch.length ) {
                        result.giftCard.transactions[ i ].createdDateTime = dateMatch[0];
                    }
                    
                    // Convert to string so we can use trim    
                    result.giftCard.transactions[ i ].debitAmount = ( '' + transaction.debitAmount ).trim();
                    result.giftCard.transactions[ i ].creditAmount = ( '' + transaction.creditAmount ).trim();
                }
                
                this.RAFGiftCard = result.giftCard;
            }
            
            this.loading = false;
        });
	}
	
	public launchAddressModal(address: Array<object>):void{
		this.ModalService.showModal({
			component: 'addressVerification',
			bodyClass: 'angular-modal-service-active',
			bindings: {
                suggestedAddresses: address //address binding goes here
			},
			preClose: (modal) => {
				modal.element.modal('hide');
				this.ModalService.closeModals();
			},
		})
		.then((modal) => {
			//it's a bootstrap element, use 'modal' to show it
			modal.element.modal();
			modal.close.then((result) => {});
		})
		.catch((error) => {
			console.error('unable to open model :', error);
		});
	}

    public getAccount = () => {
        this.loading = true;
        this.accountData = {};
        this.accountPaymentMethods = [];
         
        //Do this when then account data returns
        
        this.publicService.getAccount(true).then((response)=>{
            
            this.accountData = response.account;
            this.checkAndApplyAccountAge();
            this.userIsLoggedIn = true;
            this.accountPaymentMethods = this.accountData.accountPaymentMethods;
            const url = window.location.pathname;
            
            switch(true){
                case (url.indexOf('/my-account/order-history/') > -1):
                    this.getOrdersOnAccount();
                    break;
                case (url.indexOf('/my-account/my-details/profile/') > -1):
                    this.getUserProfileImage();
                    break;
                case (url.indexOf('/my-account/my-details/') > -1):
                    this.getMoMoneyBalance();
                    break;
                case (url.indexOf('/my-account/rewards/') > -1):
                    this.getRAFGiftCard();
                    break;
                case (url.indexOf('/my-account/') > -1):
                    this.getOrdersOnAccount(1);
                    this.getMostRecentFlexship(); 
                    break;
            }
            
            this.loading = false;
        });
    }
    
    // Determine how many years old the account owner is
    public checkAndApplyAccountAge = () => {
        if(this.accountData && this.accountData.ownerAccount){
            const accountCreatedYear = Date.parse(this.accountData.ownerAccount.createdDateTime).getFullYear();
            this.accountAge = this.currentYear - accountCreatedYear;
        }
    }
    
    public getMostRecentFlexship = () => {
        this.loading = true;
        const accountID = this.accountData.accountID;
        return this.publicService.doAction("getMostRecentOrderTemplate", {'accountID': accountID}).then(result=>{
            if(result.mostRecentOrderTemplate.length){
                this.mostRecentFlexship = result.mostRecentOrderTemplate[0];
                this.mostRecentFlexshipDeliveryDate = Date.parse(this.mostRecentFlexship.scheduleOrderNextPlaceDateTime);
                this.editFlexshipUntilDate = new Date(this.mostRecentFlexshipDeliveryDate);
                this.editFlexshipUntilDate.setDate(this.editFlexshipUntilDate.getDate() -result.daysToEditFlexship);          
            }
  
            this.loading = false;
        });
    }
    
    public getOrdersOnAccount = ( pageRecordsShow = 12, pageNumber = 1, direction:any = false) => {
        this.loading = true;
        const accountID = this.accountData.accountID;
        this.ordersArgumentObject['accountID'] = accountID;
        return this.publicService.doAction("getAllOrdersOnAccount", {'accountID' : accountID, 'pageRecordsShow': pageRecordsShow, 'currentPage': pageNumber}).then(result=>{
            this.observerService.notify("PromiseComplete")
            this.ordersOnAccount = result.ordersOnAccount.ordersOnAccount;
            this.totalOrders = result.ordersOnAccount.records;
            this.loading = false;
            this.loadingOrders = false;
        });
    }
    
    public getOrderItemsByOrderID = (orderID = this.$location.search().orderid, pageRecordsShow = 5, currentPage = 1) => {
        this.loading = true;
        return this.publicService.doAction("getOrderItemsByOrderID", {orderID: orderID,currentPage:currentPage,pageRecordsShow: pageRecordsShow}).then(result=>{
            if(result.OrderItemsByOrderID){

                this.orderItems = result.OrderItemsByOrderID.orderItems;
                this.orderPayments = result.OrderItemsByOrderID.orderPayments;
                this.orderPromotions = result.OrderItemsByOrderID.orderPromtions;
                this.orderRefundTotal = result.OrderItemsByOrderID.orderRefundTotal >= 0 ? result.OrderItemsByOrderID.orderRefundTotal : false ;
                this.orderDelivery = result.OrderItemsByOrderID.orderDelivery;
                this.purchasePlusTotal = result.OrderItemsByOrderID.purchasePlusTotal;
                
                if(this.orderPayments.length){
                    Object.keys(this.orderPayments[0]).forEach(key => {
                        if(typeof(this.orderPayments[0][key]) == "number") {
                            this.orderPayments[0][key] = Math.abs(this.orderPayments[0][key]);
                        }
                    });
                }
                this.listPrice = 0;
                for(let item of this.orderItems as Array<any>){
                    this.orderItemTotal += item.quantity;
                    this.listPrice += (item.calculatedListPrice * item.quantity);
                    if(item.sku_product_productType_systemCode == 'VIPCustomerRegistr'){
                        this.orderFees = item.calculatedExtendedPriceAfterDiscount;
                    }
                }
            }
            
            this.loading = false;
        });
    }
    
    public getCountryCodeOptions = ():Promise<any>=>{
        this.loading = true;
        if(this.countryCodeOptions){
            return this.countryCodeOptions;
        }

        return this.publicService.doAction("getCountries").then(result=>{
            this.countryCodeOptions = result.countryCodeOptions;
            this.loading = false;
        });
    }
    
    public getStateCodeOptions = (countryCode) =>{
        this.loading = true;
        
        if(this.cachedCountryCode == countryCode ){
            return this.stateCodeOptions;
        }
        
        this.cachedCountryCode = countryCode;
        return this.publicService.doAction("getStateCodeOptionsByCountryCode",{countryCode}).then(result=>{
            //Resets the state code options on each click so they dont add up incorrectly
            if(this.stateCodeOptions.length){
                this.stateCodeOptions = [];
            }
            result.stateCodeOptions.forEach(stateCode =>{
                this.stateCodeOptions.push(stateCode);
            });

            this.loading = false;
        });
    }
    
    public setPrimaryPaymentMethod = (methodID) => {
        this.loading = true;
        return this.publicService.doAction("updatePrimaryPaymentMethod",{paymentMethodID: methodID} ).then(result=>{
            this.loading = false;
        });
    }
    
    public toggleClass =()=>{
        const icon = document.getElementById('toggle-icon');
        const list = document.getElementById('toggle-list');
        
        if(list.classList.contains('active')){
            list.classList.remove('active');
            icon.classList.remove('fa-chevron-up');
            icon.classList.add('fa-chevron-down' );
        } else{
            list.classList.add('active');
            icon.classList.add('fa-chevron-up');
            icon.classList.remove('fa-chevron-down');
        }
    }
    
    public deletePaymentMethod = (paymentMethodID, index) => {
        this.loading = true;
        return this.publicService.doAction("deleteAccountPaymentMethod", { 'accountPaymentMethodID': paymentMethodID }).then(result=>{
            this.accountPaymentMethods.splice(index, 1);
            this.loading = false;
            return this.accountPaymentMethods
        });
    }
    
    public setEditAddress = (newAddress = true, address) => {
        this.editAddress = {};
        this.editAddress = address ? address : {};
        if(address.address.countryCode){
            this.getStateCodeOptions(address.address.countryCode)
        }
        this.isNewAddress = newAddress;
    }
    
    public setPrimaryAddress = (addressID) => {
        this.loading = true;
        return this.publicService.doAction("updatePrimaryAccountShippingAddress", {'accountAddressID' : addressID}).then(result=>{
            this.loading = false;
        });
    }
    
    public deleteAccountAddress = (addressID, index) => {
        this.loading = true;
        return this.publicService.doAction("deleteAccountAddress", { 'accountAddressID': addressID }).then(result=>{
            this.loading = false;
        });
    }
    
    public setRating = (rating) => {
        this.newProductReview.rating = rating;
        this.newProductReview.reviewerName = this.accountData.firstName + " " + this.accountData.lastName;
        this.stars = ['','','','',''];
        for(let i = 0; i <= rating - 1; i++) {
            this.stars[i] = "fas";
        };
    }
    
    public closeModals = () =>{
        $('.modal').modal('hide')
        $('.modal-backdrop').remove() 
    }
    
    public getMoMoneyBalance = () => {
        this.publicService.doAction('getMoMoneyBalance').then(res => {
            this.moMoneyBalance = res.moMoneyBalance;
        });
    }

    public uploadImage = () =>{
        if(!(<HTMLInputElement>document.getElementById('profileImage')).files[0]) {
            this.isNotProfileImagesChoosen = true;
        } else {
        this.isNotProfileImagesChoosen = false;
        let tempdata = new FormData();
        tempdata.append("uploadFile", (<HTMLInputElement>document.getElementById('profileImage')).files[0]);
        tempdata.append("imageFile", (<HTMLInputElement>document.getElementById('profileImage')).files[0].name);
		let xhr = new XMLHttpRequest();
		let url = window.location.href
		let urlArray = url.split("/");
		let baseURL = urlArray[0] + "//" + urlArray[2];
		let that = this; 
		let form = <any>document.getElementById('imageForm');
		
		xhr.open('POST', `${baseURL}/Slatwall/index.cfm/api/scope/uploadProfileImage`, true);
		xhr.onload = function () {
			var response = JSON.parse(xhr.response);
		 	 if (xhr.status === 200 && response.successfulActions && response.successfulActions.length) {
 	     	    that.uploadImageError = false;
		 	 	console.log("File Uploaded");
		  	 }else{
    		    that.uploadImageError = true;
    		    that.$scope.$digest();
		  	 }
		  	 
 	        form.reset();
  	 	 	that.getUserProfileImage();
		};
        xhr.send(tempdata);
        } 
         
    }     
    
    public deleteProfileImage(){
        this.profileImageLoading = true;
        this.publicService.doAction('deleteProfileImage').then(result=>{
            this.profileImageLoading = false;
            let form = <any>document.getElementById('imageForm');
            form.reset();
            this.getUserProfileImage();
        });
    }
    
    public getUserProfileImage = () =>{
        this.profileImageLoading = true;
        this.publicService.doAction('getAccountProfileImage', {height:125, width:175}).then(result=>{
            this.accountProfileImage = result.accountProfileImage;
            this.profileImageLoading = false;
            this.isDefaultImage = this.accountProfileImage.includes('profile_default') ? true : false;
        });
    }

	public showDeleteWishlistModal = () => {
		this.ModalService.showModal({
			component: 'wishlistDeleteModal',
			bodyClass: 'angular-modal-service-active',
			bindings: {
                wishlist: this.holdingWishlist
			},
			preClose: (modal) => {
				modal.element.modal('hide');
				this.ModalService.closeModals();
			},
		})
		.then((modal) => {
			//it's a bootstrap element, use 'modal' to show it
			modal.element.modal();
			modal.close.then((result) => {});
		})
		.catch((error) => {
			console.error('unable to open model :', error);
		});
	}
	
	public showEditWishlistModal = () => {
		this.ModalService.showModal({
			component: 'wishlistEditModal',
			bodyClass: 'angular-modal-service-active',
			bindings: {
                wishlist: this.holdingWishlist
			},
			preClose: (modal) => {
				modal.element.modal('hide');
				this.ModalService.closeModals();
			},
		})
		.then((modal) => {
			//it's a bootstrap element, use 'modal' to show it
			modal.element.modal();
			modal.close.then((result) => {});
		})
		.catch((error) => {
			console.error('unable to open model :', error);
		});
	}
	
	public showShareWishlistModal = () => {
		this.ModalService.showModal({
			component: 'wishlistShareModal',
			bodyClass: 'angular-modal-service-active',
			bindings: {
                wishlist: this.holdingWishlist
			},
			preClose: (modal) => {
				modal.element.modal('hide');
				this.ModalService.closeModals();
			},
		})
		.then((modal) => {
			//it's a bootstrap element, use 'modal' to show it
			modal.element.modal();
			modal.close.then((result) => {});
		})
		.catch((error) => {
			console.error('unable to open model :', error);
		});
	}
	
	public showDeleteAccountAddressModal = (address) => {
		this.ModalService.showModal({
			component: 'addressDeleteModal',
			bodyClass: 'angular-modal-service-active',
			bindings: {
                address: address
			},
			preClose: (modal) => {
				modal.element.modal('hide');
				this.ModalService.closeModals();
			},
		})
		.then((modal) => {
			//it's a bootstrap element, use 'modal' to show it
			modal.element.modal();
			modal.close.then((result) => {});
		})
		.catch((error) => {
			console.error('unable to open model :', error);
		});
	}
	
	public showProductReviewModal = (item) => {
		this.ModalService.showModal({
			component: 'monatProductReview',
			bodyClass: 'angular-modal-service-active',
			bindings: {
                productReview: item,
                reviewerName: this.accountData.firstName + " " + this.accountData.lastName
			},
			preClose: (modal) => {
				modal.element.modal('hide');
				this.ModalService.closeModals();
			},
		})
		.then((modal) => {
			//it's a bootstrap element, use 'modal' to show it
			modal.element.modal();
			modal.close.then((result) => {});
		})
		.catch((error) => {
			console.error('unable to open model :', error);
		});
	}
}

class SWFAccount  {
    
    public bindToController = {
        currentAccountPayment:"@?"
    };
    
    public controller       = swfAccountController;
    public controllerAs     = "swfAccount";
    public restrict         = "A";
    public scope            = true;
    public static Factory(){
        var directive = () => new SWFAccount();
        directive.$inject = [];
        return directive;
    }
    
}
export{
    SWFAccount,
    swfAccountController
}