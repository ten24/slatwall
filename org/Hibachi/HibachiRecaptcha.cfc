

component accessors="true" persistent="false" output="false" extends="HibachiObject" {
  
  property name="siteVerifyUrl" default="https://www.google.com/recaptcha/api/siteverify";
  property name="gRecaptchaResponse" type="any";
  property name="secretKey";
  property name="remoteip";
	
  public boolean function verifyResponse() {
  		if(isNull(getSecretKey) && !isNull(getHibachiScope().getSite())){
  			setSecretKey(getHibachiScope().getSite().setting('siteRecaptchaSecretKey'));
  		}else{
  			setSecretKey(getHibachiScope().setting('siteRecaptchaSecretKey'));
  		}
  	
		if(!isNull(getGRecaptchaResponse()) && !isNull(getSecretKey())){
			try{
	  			var httpRequest = new http();
	  			httpRequest.setMethod("post"); 
			    httpRequest.setCharset("utf-8"); 
			    httpRequest.setUrl(getSiteVerifyUrl()); 
				httpRequest.addParam(type="formfield",name="secret",value=getSecretKey()); 
			    httpRequest.addParam(type="formfield",name="response",value=getgRecaptchaResponse());
			    if(!isNull(getRemoteIp())){
			    	httpRequest.addParam(type="formfield",name="remoteip",value=getRemoteIp());	
			    } 
			    
			    var result = deserializeJson(httpRequest.send().getPrefix().filecontent);
			    return result['success'];
			    
		    }catch(any e){
		    	return false;
		    }
		     
		}
		
		return false;
  }
}