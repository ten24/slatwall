class MonatBirthdayController {
	public showPicker = false;
	public date = new Date();
	public month = this.date.toLocaleString('default', { month: 'long' });
	public day = 1;
	public year = this.date.getFullYear();
	public months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
	public upMonth = this.months[this.months.indexOf(this.month) + 1];
	public downMonth = this.months[this.months.indexOf(this.month) - 1];
	
	//@ngInject
	constructor(public monatService, public observerService, public $rootScope, public publicService) {}

	public $onInit = () => {
		
	}
	
	public showBirthdayPicker():void{
		this.showPicker = !this.showPicker;
	}
	
	public increaseMonth():void{
		this.month = this.months[this.months.indexOf(this.month) + 1];
		this.upMonth = this.months[this.months.indexOf(this.month) + 1];
		this.downMonth = this.months[this.months.indexOf(this.month) - 1];
	}
	
	public decreaseMonth():void{
		this.month = this.months[this.months.indexOf(this.month) + 1];
		this.month = this.months[this.months.indexOf(this.month) - 1];
		this.downMonth = this.months[this.months.indexOf(this.month) - 1];
	}
	
	public changeDay(action:'+' | '-'):void{
		//TODO: logic for available days in a month, disallowing below 1
		this.day = (action === '+') ? this.day + 1 : this.day - 1;
	}
	
	public changeYear(action:'+' | '-'):void{
		//TODO: logic for available days in a month, disallowing below 1
		this.year = (action === '+') ? this.year + 1 : this.year - 1;
	}
	
	public resetModel(){
		this.publicService.
	}
}

class MonatBirthday {
	public restrict = 'E';
	public templateUrl: string;
	public scope = {};
	public controller = MonatBirthdayController;
	public controllerAs = 'monatBirthday';

	public static Factory() {
		var directive: any = (monatFrontendBasePath) => new this(monatFrontendBasePath);
		directive.$inject = ['monatFrontendBasePath'];
		return directive;
	}

	constructor(private monatFrontendBasePath) {
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/components/monat-birthday.html';
	}
}

export { MonatBirthday };
