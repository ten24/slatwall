
class SaveEnrollmentModalController {
	public close; // injected from angularModalService
	public loading;
	public emailAddress;
	
    //@ngInject
    constructor(public rbkeyService, public observerService, public publicService, public monatAlertService) {
        this.observerService.attach(this.closeModal,'saveEnrollmentSuccess')
    }
    
    public saveEnrollment = () => {
        this.loading = true;
        let data = {
          emailAddress:this.emailAddress
        };
        return this.publicService.doAction('?slatAction=monat:public.saveEnrollment',data)
        .then(result=>{
            if(result.errors){
                this.monatAlertService.error(result.errors);
            }else if(result.messages){
                for(let message of result.messages){
                    this.monatAlertService.success(message);
                }
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
