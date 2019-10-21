class SponsorSearchSelectorController {
	private title: string;
	private siteCountryCode: string;
	private accountSearchType: string;
	
	public countryCodeOptions: any;
	public stateCodeOptions: any;
	public searchResults: any;
	
	public loadingResults: boolean = false;
	public currentPage: number = 1;

	// Form fields for the sponsor search.
	public form: any = {
		text: '',
		countryCode: null,
		state: '',
	}

	// @ngInject
	constructor(
		private publicService
	) {}
	
	public $onInit = () => {
		// Set the default country code based on the current site.
		this.form.countryCode = this.siteCountryCode;
		this.getCountryCodeOptions();
		this.getStateCodeOptions( this.form.countryCode );
		this.getSearchResults();
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
	
	public getSearchResults = () => {
		
		this.loadingResults = true;
		
		this.publicService.doAction(
			'/?slatAction=monat:public.getmarketpartners'
				+ `&search=${ this.form.text }`
				+ `&currentPage=${ this.currentPage }`
				+ `&accountSearchType=${ this.accountSearchType }`
				+ `&countryCode=${ this.form.countryCode }`
				+ `&stateCode=${ this.form.stateCode }`
		).then(data => {
			
			this.loadingResults = false;
			this.searchResults = data.pageRecords;
			
		});
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
	};

	public controller = SponsorSearchSelectorController;
	public controllerAs = 'sponsorSearchSelector';

	public static Factory() {
		var directive = monatFrontendBasePath => new this( monatFrontendBasePath );
		directive.$inject = ['monatFrontendBasePath'];
		return directive;
	}
	
	constructor(
		private monatFrontendBasePath
	) {
		this.templateUrl = monatFrontendBasePath + '/monatfrontend/components/sponsor-search-selector.html';
	}
}

export { SponsorSearchSelector };
