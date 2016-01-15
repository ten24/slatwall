component extends="Slatwall.org.Hibachi.HibachiEventHandler" {

	public void function callEvent( required any eventName, required struct eventData={} ) {
		//if the site is not null and the site matches our current site
		if(!isNull(getHibachiScope().getSite()) && getHibachiScope().getService('siteService').getCurrentRequestSite().getSiteID() == getHibachiScope().getSite().getSiteID()){
			super.callMethod(eventName=arguments.eventName,eventData=arguments.eventData);
		}
	}
}
