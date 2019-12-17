/// <reference path='../../../../../org/Hibachi/client/typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../../org/Hibachi/client/typings/tsd.d.ts' />


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
    public orderItemsLength:number;
    public urlParams = new URLSearchParams(window.location.search);
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

    public accountProfileImage;
    
    // @ngInject
    constructor(
        public publicService,
        public $scope,
        public observerService,
        public ModalService
    ){
        this.observerService.attach(this.getAccount,"loginSuccess"); 
        this.observerService.attach(this.closeModals,"addNewAccountAddressSuccess"); 
        this.observerService.attach(this.closeModals,"addAccountPaymentMethodSuccess"); 
        this.observerService.attach(this.closeModals,"addProductReviewSuccess"); 
        this.observerService.attach(option => this.holdingWishlist = option,"myAccountWishlistSelected"); 
        
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
	}

    public getAccount = () => {
        this.loading = true;
        this.accountData = {};
        this.accountPaymentMethods = [];
         
        //Do this when then account data returns
        
        this.publicService.getAccount(true).then((response)=>{
            
            this.accountData = response;
            this.checkAndApplyAccountAge();
            this.userIsLoggedIn = true;
            this.accountPaymentMethods = this.accountData.accountPaymentMethods;
            
            if(this.urlParams.get('orderid')){
                this.getOrderItemsByOrderID();
            }
            
            switch(window.location.pathname){
                case '/my-account/':
                    this.getOrdersOnAccount(1);
                    this.getMostRecentFlexship(); 
                    break;
                case '/my-account/order-history/':
                    this.getOrdersOnAccount();
                    break;
                case '/my-account/my-details/profile/':
                    this.getUserProfileImage();
                    break;
                case '/my-account/my-details/':
                    this.getMoMoneyBalance();
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
    
    public getOrderItemsByOrderID = (orderID = this.urlParams.get('orderid'), pageRecordsShow = 5, currentPage = 1) => {
        this.loading = true;
        
        const accountID = this.accountData.accountID
        return this.publicService.doAction("getOrderItemsByOrderID", {orderID,accountID,currentPage,pageRecordsShow,}).then(result=>{
            result.OrderItemsByOrderID.forEach(orderItem =>{
                this.orderItems.push(orderItem);
            });
            this.orderItemsLength = result.OrderItemsByOrderID.length;
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
        if(!newAddress){
            this.getStateCodeOptions(address.address.countryCode)
        }
        this.isNewAddress = newAddress;
        this.editAddress.address.countryCode = 
    }
    
    public setPrimaryAddress = (addressID) => {
        this.loading = true;
        return this.publicService.doAction("updatePrimaryAccountShippingAddress", {'accountAddressID' : addressID}).then(result=>{
            this.loading = false;
        });
    }
    
    public setRating = (rating) => {
        this.newProductReview.rating = rating;
        this.stars = ['','','','',''];
        for(let i = 0; i <= rating - 1; i++) {
            this.stars[i] = "fas";
        };
    }
    
    public deleteAccountAddress = (addressID, index) => {
        this.loading = true;
        return this.publicService.doAction("deleteAccountAddress", { 'accountAddressID': addressID }).then(result=>{
            this.loading = false;
        });
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
        let tempdata = new FormData();
        tempdata.append("uploadFile", (<HTMLInputElement>document.getElementById('profileImage')).files[0]);
        tempdata.append("imageFile", (<HTMLInputElement>document.getElementById('profileImage')).files[0].name);
		let xhr = new XMLHttpRequest();
		let url = window.location.href
		let urlArray = url.split("/");
		let baseURL = urlArray[0] + "//" + urlArray[2];
		
		xhr.open('POST', `${baseURL}/Slatwall/index.cfm/api/scope/uploadProfileImage`, true);
		xhr.onload = function () {
			var response = JSON.parse(xhr.response);
		 	 if (xhr.status === 200 && response.successfulActions && response.successfulActions.length) {
		 	 	console.log("File Uploaded");
		  	 } 
		};
        xhr.send(tempdata);
    }     
    
    public getUserProfileImage = () =>{
        this.publicService.doAction('getAccountProfileImage', {height:125, width:175}).then(result=>{
            this.accountProfileImage = result.accountProfileImage;
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