type plusOrMinus = '+' | '-';

class MonatBirthdayController {
	public showPicker = false;
	public date = new Date();
	public month = this.date.toLocaleString('default', { month: 'long' });
	public day = 1;
	public year = this.date.getFullYear();
	public currentYear = this.year; //snapshot the curren year for reference
	public months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']; // turn into rbKeys
	public upMonth = this.months[this.months.indexOf(this.month) + 1];
	public downMonth = this.months[this.months.indexOf(this.month) - 1];
	
	//@ngInject
	constructor(public monatService, public observerService, public $rootScope, public publicService, public $scope) {}

	public $onInit = () => {

	}
	
	public showBirthdayPicker():void{
		this.showPicker = !this.showPicker;
	}
	
	public increaseMonth():void{
		this.month = this.getAdjustedMonth('+'); 
		this.upMonth = this.getAdjustedMonth('+');
		this.downMonth = this.getAdjustedMonth('-'); 
		this.resetModel();
	}
	
	public decreaseMonth():void{
		this.month = this.getAdjustedMonth('-');
		this.upMonth =this.getAdjustedMonth('+');
		this.downMonth = this.getAdjustedMonth('-');
		this.resetModel();
	}
	
	public changeDay(action: plusOrMinus):void{
		//disallow days below 1, and days above the last day in the month
		let daysInCurrentMonth = new Date(this.date.getFullYear(), this.months.indexOf(this.month)+1, 0).getDate();
		
		if((+this.day === 1 && action ==='-') || (+this.day === daysInCurrentMonth && action === '+')) return;
		this.day = (action === '+') ? this.day + 1 : this.day - 1;
		this.resetModel()
	}
	
	public changeYear(action: plusOrMinus):void{

		if(action === '+' && this.year < this.currentYear){
			this.year += 1;
			this.resetModel();
		}else if(action === '-'){
			this.year -= 1;
			this.resetModel();
		}
	}
	
	public resetModel(){
		if(!this.$scope.swfForm || !this.$scope.swfForm.form) return;
		
		this.$scope.swfForm.form.month = {$modelValue: this.months.indexOf(this.month)};
		this.$scope.swfForm.form.year = {$modelValue: this.year};
		this.$scope.swfForm.form.day = {$modelValue: this.day};
	}
	
	public getAdjustedMonth(action:plusOrMinus):string{
		return (action === '+') ? this.months[this.months.indexOf(this.month) + 1] : this.months[this.months.indexOf(this.month) - 1];
	}
}

class MonatBirthday {
	public restrict = 'E';
	public templateUrl: string;
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
