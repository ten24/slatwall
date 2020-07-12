
enum ActionType {
	PLUS,
	MINUS,
	INPUT
}

class MonatBirthdayController {
	public showPicker = false;
	public date = new Date();
	public month:string;
	public day = 1;
	public year = this.date.getFullYear();
	public currentYear = this.year; //snapshot the current year for reference
	public months:Array<string>;
	public upMonth:string;
	public downMonth:string;
	public upDay = 2;
	public downDay:number;
	public Actions = ActionType;
	public isSet = false;
	public dob:any;
	public show:boolean;
	public required:boolean;
	public isValid:boolean;
	
	//@ngInject
	constructor(public observerService, public $rootScope, public monatService, public $scope, public rbkeyService) {
		this.months = [
			this.rbkeyService.rbKey('frontend.global.january'),
			this.rbkeyService.rbKey('frontend.global.february'),
			this.rbkeyService.rbKey('frontend.global.march'),
			this.rbkeyService.rbKey('frontend.global.april'),
			this.rbkeyService.rbKey('frontend.global.may'),
			this.rbkeyService.rbKey('frontend.global.june'),
			this.rbkeyService.rbKey('frontend.global.july'),
			this.rbkeyService.rbKey('frontend.global.august'),
			this.rbkeyService.rbKey('frontend.global.september'),
			this.rbkeyService.rbKey('frontend.global.october'),
			this.rbkeyService.rbKey('frontend.global.november'),
			this.rbkeyService.rbKey('frontend.global.december'),
			
		]
			this.month = this.months[0];
			this.upMonth = this.getAdjustedMonth(ActionType.PLUS);
			this.downMonth = this.getAdjustedMonth(ActionType.MINUS);
			this.downDay = new Date(this.date.getFullYear(), this.months.indexOf(this.month)+1, 0).getDate();
	}

	public $onInit = () => {
		this.observerService.attach(this.validateAge.bind(this),'updateFailure');
		this.observerService.attach(this.validateAge.bind(this),'createFailure');
	}
	
	public validateAge(){
		if (!this.required) return this.isValid = true;
		this.isValid = this.monatService.calculateAge(this.dob) > 18;
	}
	
	public showBirthdayPicker():void{
		this.showPicker = !this.showPicker;
	}
	
	public changeDOB(action: ActionType):void{
		var date = this.dob?.split('/');
        if(date?.length == 3){
            var monthIndex = parseInt(date[0]) - 1;
            this.month = this.months[monthIndex];
            this.day = parseInt(date[1]);
            this.year = parseInt(date[2]);
            
            this.upMonth = this.getAdjustedMonth(ActionType.PLUS);
            this.downMonth = this.getAdjustedMonth(ActionType.MINUS);
            this.upDay = this.getAdjustedDay(ActionType.PLUS);
            this.downDay = this.getAdjustedDay(ActionType.MINUS);
        }
        this.resetModel();
	}
	
	public changeMonth(action: ActionType):void{
		this.month = this.getAdjustedMonth(action); 
		this.upMonth = this.getAdjustedMonth(ActionType.PLUS);
		this.downMonth = this.getAdjustedMonth(ActionType.MINUS);
		this.resetModel();
	}
	
	public changeDay(action: ActionType):void{
		this.day = this.getAdjustedDay(action);
		this.upDay = this.getAdjustedDay(ActionType.PLUS);
		this.downDay = this.getAdjustedDay(ActionType.MINUS);
		this.resetModel()
	}
	
	public changeYear(action: ActionType):void{
		//make sure its a number 
		this.year = +this.year;
		
		//disallow years above the current year
		if(action === ActionType.PLUS && this.year < this.currentYear){
			this.year += 1;
		}else if(action === ActionType.MINUS){
			this.year -= 1;
		}else if(this.year > this.currentYear || this.year < 1900){
			this.year = this.currentYear;
			return;
		}
		this.resetModel();
	}
	
	public getAdjustedMonth(action:ActionType):string{
		
		if(this.months.indexOf(this.month) == this.months.length -1 && action === ActionType.PLUS){
			return this.months[0];
		}else if(this.months.indexOf(this.month) === 0 && action === ActionType.MINUS){
			return this.months[this.months.length -1]
		}else if(action === ActionType.INPUT){
			return this.month.replace(/\w\S*/g, text => {
				let month = text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();
				if(this.months.indexOf(month) > -1){
					return month;
				}else{
					return this.months[0];
				}
				
			});
		}else{
			return (action === ActionType.PLUS) ? this.months[this.months.indexOf(this.month) + 1] : this.months[this.months.indexOf(this.month) - 1];
		}
	}
	
	public getAdjustedDay(action:ActionType):number{
		//make sure its a number
		this.day = +this.day;
		let daysInCurrentMonth = new Date(this.date.getFullYear(), this.months.indexOf(this.month)+1, 0).getDate();
		
		if(action === ActionType.INPUT){
			if(this.day > daysInCurrentMonth){
				return daysInCurrentMonth;
			}else if(this.day === 0 ){
				return 1;
			}else{
				return this.day;
			}
		}
		
		if(this.day === 1 && action ===ActionType.MINUS){
			return daysInCurrentMonth;
		} else if(this.day === daysInCurrentMonth && action === ActionType.PLUS){
			return 1;
		}
		
		return (action === ActionType.PLUS) ? this.day + 1 : this.day - 1;
	}
	
	//updates form values
	public resetModel(){
		if(!this.$scope.swfForm || !this.$scope.swfForm.form) return;
		
		var month = this.months.indexOf(this.month) + 1;
		
		this.dob = month.toString().length == 2? month : ("0" + month);
		this.dob += "/";
		this.dob += this.day.toString().length == 2? this.day : ("0" + this.day);
		this.dob += "/";
		this.dob += this.year;
		
		this.isSet = true
	}
	
	public closeThis(){
		this.showPicker = false;
	}
	
}

class MonatBirthday {
	public restrict = 'E';
	public templateUrl: string;
	public controller = MonatBirthdayController;
	public controllerAs = 'monatBirthday';
	public bindToController = {
		required: '<?'
	}
	public template = require('./monat-birthday.html');

	public static Factory() {
		return () => new this();
	}
}

export { MonatBirthday };
