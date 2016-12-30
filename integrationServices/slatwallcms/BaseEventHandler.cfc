component extends="Slatwall.org.Hibachi.HibachiEventHandler" {
	
	public void function onEvent( required any eventName, struct data={}, any entity ) {
        //if the site is not null and the site matches our current site
        var siteCode = listGetAt(getMetaData(this).fullname,5,'.');
        if(!isNull(getHibachiScope().getSite()) && !isNull(getHibachiScope().getCurrentRequestSite()) && !isNull(getHibachiScope().getCurrentRequestSite().getSiteCode()) && getHibachiScope().getCurrentRequestSite().getSiteCode() == siteCode){
            //get siteRecaptchaProtectedEvents
            if(structKeyExists(arguments,'entity')){
            	var protectedEventsList = getHibachiScope().getSite().setting('siteRecaptchaProtectedEvents');
            	//if the event is protected then verifiy that we have captcha data and that it is valid
            	if(listFind(protectedEventsList,arguments.eventName)){
            		var invalidCaptcha = true;
            		if(structKeyExists(arguments.data,'g-recaptcha-response')){
						var hibachiRecaptcha = getTransient('hibachiRecaptcha');
						hibachiRecaptcha.setGRecaptchaResponse(arguments.data['g-recaptcha-response']);
						invalidCaptcha = !hibachiRecaptcha.verifyResponse();
					}
					
					if(invalidCaptcha){
						arguments.entity.addError('recaptchaFailed',rbkey('define.recaptchaFailed'));
					}
            		
            	}
            }
        }
    }
        
    public void function callEvent( required any eventName, required struct eventData={} ) {
        //if the site is not null and the site matches our current site
        var siteCode = listGetAt(getMetaData(this).fullname,5,'.');
        if(!isNull(getHibachiScope().getSite()) && !isNull(getHibachiScope().getCurrentRequestSite()) && !isNull(getHibachiScope().getCurrentRequestSite().getSiteCode()) && getHibachiScope().getCurrentRequestSite().getSiteCode() == siteCode){
            super.callEvent(eventName=arguments.eventName,eventData=arguments.eventData);
        }
    }
}
