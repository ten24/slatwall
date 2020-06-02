component accessors="true" output="false" extends="Slatwall.model.service.HibachiRBService" {
	
		public array function getAvailableLocaleOptions(string localeFilterList='') {
			
			var locales = super.getAvailableLocaleOptions(argumentCollection=arguments);
			
			var customLocaleData = {
				countryCode = 'pl',
				languageCode = 'en',
				name = 'English (Poland)',
				languageName = 'English',
				countryName = 'Poland',
				value = 'en_pl'
			};
			
			// Include locale if no filter provided or if locale in the filter list
			if (!len(arguments.localeFilterList) || listFindNoCase(arguments.localeFilterList, customLocaleData.value)) {
				arrayAppend(locales, customLocaleData);
				
				// Apply alphabetical sort using display name
				arraySort(locales, function(elementA, elementB) {
					return compareNoCase(elementA.name, elementB.name);
				});
			}
			
			return locales;
		}
}