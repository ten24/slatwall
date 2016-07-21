component extends="Slatwall.org.Hibachi.HibachiEventHandler" {
        
    public void function callEvent( required any eventName, required struct eventData={} ) {
        //if the site is not null and the site matches our current site
        var siteCode = listGetAt(getMetaData(this).fullname,5,'.');
        if(!isNull(getHibachiScope().getSite()) && !isNull(getHibachiScope().getCurrentRequestSite()) && !isNull(getHibachiScope().getCurrentRequestSite().getSiteCode()) && getHibachiScope().getCurrentRequestSite().getSiteCode() == siteCode){
            super.callEvent(eventName=arguments.eventName,eventData=arguments.eventData);
        }
    }
}
