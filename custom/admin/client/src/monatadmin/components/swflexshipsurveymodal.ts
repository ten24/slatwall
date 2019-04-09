class SWFlexshipSurveyModalController{

	public title="Flexship Survey"

	constructor(){

	}

	public save = () =>{
		
	}
}

class SWFlexshipSurveyModal {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {

	};
	public controller=SWFlexshipSurveyModalController;
	public controllerAs="swFlexshipSurveyModal";

	public static Factory(){
        var directive:any = (
		    monatBasePath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWFlexshipSurveyModal(
			monatBasePath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        );
        directive.$inject = [
			'monatBasePath',
			'slatwallPathBuilder',
			'$hibachi',
			'rbkeyService'
        ];
        return directive;
    }

	constructor(private monatBasePath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = monatBasePath + "/monatadmin/components/flexshipsurveymodal.html";
		this.restrict = "EA";
	}

	public link = (scope, element, attrs) =>{

	}

}

export {
	SWFlexshipSurveyModal
};

