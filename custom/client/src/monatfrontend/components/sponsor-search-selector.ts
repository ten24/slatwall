declare var hibachiConfig;

class SponsorSearchSelectorController {
	private title: string;
	private siteCountryCode: string;
	private accountSearchType: string;
	public selectedSponsor: any = null;
	public countryCodeOptions: any;
	public stateCodeOptions: any;
	public searchResults: any;
	public loadingResults: boolean = false;
	public currentPage: number = 1;
	public argumentsObject:any;
	public recordsCount:number;
	public hasBeenSearched:boolean = false;
	public originalAccountOwner:string;;

	
	// Form fields for the sponsor search.
	public form: any = {
		text: '',
		countryCode: null,
		state: '',
	}

	// @ngInject
	constructor(
		private publicService,
		public observerService,
		public $location,
		private monatService
	) {}
	
	public $onInit = () => {

		// Set the default country code based on the current site.
		this.form.countryCode = this.siteCountryCode;
		this.getCountryCodeOptions();
		this.getStateCodeOptions( this.form.countryCode );
	
		//raf search
		if (this.$location.search().accountNumber ) {
			this.form.text = this.$location.search().accountNumber;
			this.getSearchResults();
		//replicated site search
		}else if(hibachiConfig.siteOwner.length){
			this.getSearchResults(true).then(()=>{
				
			});
		//session search 
		}else if(this.monatService.hasOwnerAccountOnSession){
			this.getSearchResults(false);
		}
		
		
	}
	
	private getCountryCodeOptions = () => {
		
		// We dont't need to get country code options more than once.
		if ( angular.isDefined( this.countryCodeOptions ) ) {
			return this.countryCodeOptions;
		}

		this.publicService.getCountries().then(data => {
			this.countryCodeOptions = data.countryCodeOptions;
		});
	};
	
	public getStateCodeOptions = countryCode => {
		
		// Reset the state code.
		this.form.stateCode = '';

		this.publicService.getStates(countryCode).then(data => {
			this.stateCodeOptions = data.stateCodeOptions;
		});
	}
	
	public getSearchResults = (useHibachiConfig = false) => {
		this.loadingResults = true;
		
		let data = {
			search:this.form.text,
			currentPage:this.currentPage,
			accountSearchType:this.accountSearchType,
			countryCode:this.form.countryCode,
			stateCode:this.form.stateCode,
			returnJsonObjects:''
		}

		this.argumentsObject = {
			search:this.form.text,
			accountSearchType:this.accountSearchType,
			countryCode:this.form.countryCode,
			stateCode:this.form.stateCode,
			returnJsonObjects:''
		}
		if (this.$location.search().accountNumber && !this.hasBeenSearched) {
			data.countryCode = null;
		}
		if(useHibachiConfig && !this.hasBeenSearched){
			this.argumentsObject['search'] = hibachiConfig.siteOwner
			data['search'] = hibachiConfig.siteOwner;
			this.argumentsObject['countryCode'] = null;
			this.argumentsObject['stateCode'] = null;
			data['countryCode'] = null;
			data['stateCode'] = null;
			this.hasBeenSearched = true;
		}

		this.publicService.marketPartnerResults = this.publicService.doAction(
			'getmarketpartners',data
		).then(data => {
			this.observerService.notify('PromiseComplete');
	
			if( data.pageRecords.length == 1 ){
				this.selectedSponsor = data.pageRecords[0];
				this.notifySelect(this.selectedSponsor);
			}
			
			this.loadingResults = false;
			this.searchResults = data.pageRecords;
			this.recordsCount = data.recordsCount;
			
		});
		
		return this.publicService.marketPartnerResults;
	}
	
	public notifySelect = (account) =>{
		this.observerService.notify('ownerAccountSelected', account)
	}
	
	public setSelectedSponsor = ( sponsor: any, notify: boolean = false ) => {
		this.selectedSponsor = sponsor;
		this.publicService.selectedSponsor = sponsor;

		if ( notify ) {
			this.notifySelect( sponsor );
		}
	}
	
	public autoAssignSponsor = () => {
		this.observerService.notify('autoAssignSponsor');
	}
	
	

}

class SponsorSearchSelector {
	public restrict: string = 'E';
	public templateUrl: string;
	public scope: any = {};

	public bindToController: any = {
		accountSearchType: '@',
		siteCountryCode: '@',
		title: '@',
		originalAccountOwner: '<?'
	};

	public controller = SponsorSearchSelectorController;
	public controllerAs = 'sponsorSearchSelector';
	
	public template = require('./sponsor-search-selector.html');

	public static Factory() {
		return () => new this();
	}
}

export { SponsorSearchSelector };
