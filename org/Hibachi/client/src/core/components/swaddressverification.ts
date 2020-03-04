
class SWAddressVerificationController {
    public suggestedAddresses:Array<Object>; 
    public selectedAddressIndex:number;
    public loading;
    public translations = {};
	public close; // injected from angularModalService
	public sAction;

    //@ngInject
    constructor(public rbkeyService, public observerService, private $hibachi) {
    }

	private makeTranslations = () => {
    	this.translations['suggestedAddress'] = this.rbkeyService.rbKey('admin.define.suggestedAddress');
    	this.translations['cancel'] = this.rbkeyService.rbKey('admin.define.cancel');
    	this.translations['addressMessage']= this.rbkeyService.rbKey('admin.define.addressChangeMessage');
    }

    public submit = () =>{
    	if(this.selectedAddressIndex == 0){
    		this.close(null);
    		return;
    	}else{
    		this.loading = true;
    		this.$hibachi.saveEntity('Address', this.suggestedAddresses[this.selectedAddressIndex]['addressID'],this.suggestedAddresses[this.selectedAddressIndex])
    		.then(result=>{
    			this.loading = false;
    			this.suggestedAddresses[0] = this.suggestedAddresses[this.selectedAddressIndex];
    			this.close(null);
    			if(this.sAction){
    				this.sAction(result);
    			}
    		})
    	}
    	
    }
    
    public closeModal = () => {
     	this.close(null);
    }
    
}

class SWAddressVerification {

	public restrict:string;
	public templateUrl:string;
	
	public scope = {};
	public bindToController = {
	    suggestedAddresses:'<',
		close:'=', //injected by angularModalService
		sAction:'=?'
	};
	
	public controller = SWAddressVerificationController;
	public controllerAs = "swAddressVerification";

	public static Factory(){
        var directive = (corePartialsPath,hibachiPathBuilder) => new SWAddressVerification(corePartialsPath,hibachiPathBuilder);
        directive.$inject = ['corePartialsPath','hibachiPathBuilder'];
        return directive;
    }

    constructor(private corePartialsPath,hibachiPathBuilder){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath)+'addressverification.html';
    }

	public link = (scope, element, attrs) =>{

	}

}

export {
	SWAddressVerification
}

