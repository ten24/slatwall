
class SaveEnrollmentModalController {
	public close; // injected from angularModalService
	public loading;
	public emailAddress;
	
    //@ngInject
    constructor(public rbkeyService, public observerService, public publicService, public monatAlertService) {
        this.observerService.attach(this.closeModal,'saveEnrollmentSuccess')
    }
    
    public $onInit = () => {
    // 	this.makeTranslations();
    };
    
    // private makeTranslations = () => {
    // 	//TODO make translations for success/failure alert messages
    // 	this.translations['wishlistName'] = this.rbkeyService.rbKey('frontend.wishlist.name');
    // 	this.translations['save'] = this.rbkeyService.rbKey('frontend.marketPartner.save');
    // 	this.translations['cancel'] = this.rbkeyService.rbKey('frontend.wishlist.cancel');
    // }
    
    public saveEnrollment = () => {
        this.loading = true;
        let data = {
          emailAddress:this.emailAddress
        };
        return this.publicService.doAction('?slatAction=monat:public.saveEnrollment',data)
        .then(result=>{
            if(result.errors){
                this.monatAlertService.error(result.errors);
            }
            this.loading = false;
        });
    }
    
    public closeModal = () => {
     	this.close(null);
    }
    
}

class SaveEnrollmentModal {

	public restrict = 'E';
	
	public scope = {};
	public bindToController = {
		close:'=' //injected by angularModalService
	};
	
	public controller = SaveEnrollmentModalController;
	public controllerAs = "saveEnrollmentModal";

	public template = require('./save-enrollment-modal.html');

	public static Factory() {
		return () => new this();
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	SaveEnrollmentModal
};
