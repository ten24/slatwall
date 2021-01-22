class OrdinalFilter {
	public static Factory() {
		return function( input ) {
			var suffixes = ['th', 'st', 'nd', 'rd'];
			var relevantDigits = ( input < 30 ) ? input % 20 : input % 30;
			var suffix = ( relevantDigits <= 3 ) ? suffixes[ relevantDigits ] : suffixes[0];
			return input + suffix;
		}
	}
}

export { OrdinalFilter };