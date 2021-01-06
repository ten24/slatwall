component extends="Slatwall.model.service.HibachiService" {
    
    public any function getSiteStructWithLanguages(){
        var siteStruct = {
            'North America'={},
            'Europe'={},
            //'Australia'={}
        };
        var continentMap = {
            'mura-pl'='Europe',
            'mura-ie'='Europe',
            //'mura-au'='Australia',
            'mura-uk'='Europe',
            'mura-ca'='North America',
            'mura-default'='North America'
        };
        var languageMap = {
            'en'='English',
            'fr'='French',
            'es'='Spanish',
            'pl'='Polish'
            //'ga'='Gaelic'
        };
        var siteCollectionList = getService('siteService').getSiteCollectionList();
        siteCollectionList.setDisplayProperties('siteCode,siteName,siteAvailableLocales,flagImageFilename');
        var sites = siteCollectionList.getRecords();
        for(var site in sites){
            var siteCode = site.siteCode;
            var regionName = right(site.siteName, len(site.siteName) - 6);
            var languages = listToArray( site.siteAvailableLocales );
            var languageArray = [];
            var href = '/'&right(siteCode,len(siteCode) - 5)&'/';
            if(href == '/default'){
                href = '';
            }
            for(var language in languages){
                if(!structKeyExists(languageMap, left(language,2))){
                    continue;
                }
                var languageInfo = {
                    'name'=languageMap[left(language,2)],
                    'value'=language
                };
                arrayAppend(languageArray, languageInfo);
            }
            var flagImagePath = '/assets/images/' & site.flagImageFilename;
            
            var siteInfo = {
                languages=languageArray,
                flagImagePath=flagImagePath,
                regionName=regionName,
                siteHref=href
            };
            
            if(structKeyExists(continentMap,siteCode)){
                siteStruct[continentMap[siteCode]][siteCode] = siteInfo;
            }else{
                if(!structKeyExists(siteStruct,'Other')){
                    siteStruct['Other'] = {};
                }
                siteStruct['Other'][siteCode] = siteInfo;
            }
        }
        return siteStruct;
    }
    
    public any function getAccountActivationCode(required any account){
        var accountID = arguments.account.getAccountID();
        var emailAddress = arguments.account.getEmailAddress();
        var code = hash(emailAddress,'md5') & accountID;
        return code;
    }
    
    public boolean function activateAccount(required any accountActivationCode){
        var accountUpdated = false;
        var accountID = right(arguments.accountActivationCode,32);
        var emailAddressHash = left(arguments.accountActivationCode,32);
        var account = getService('accountService').getAccount(accountID);
        if(!isNull(account) && account.getActiveFlag() == false){
            var emailAddress = account.getEmailAddress();
            if(emailAddressHash == hash(emailAddress,'md5')){
                account.setActiveFlag(true);
                accountUpdated = true;
            }
        }
        account.setAccountStatusType(getService('TypeService').getTypeBySystemCode('astGoodStanding'));
        account.getAccountNumber();

        return accountUpdated;
    }
    public any function resumeEnrollment(required string enrollmentCode){
        param name="enrollmentCode";
        
        if(len(enrollmentCode) != 32){

            getHibachiScope().addActionResult('monat:public.resumeEnrollment',true);
            return;
        }
        var orderID = enrollmentCode;
        
        var order = getService('OrderService').getOrder( orderID );
        if(isNull( order ) || order.hasAccount() ){
            getHibachiScope().addActionResult( 'monat:public.resumeEnrollment', true );
            return;
        }
        
        getHibachiScope().getSession().setOrder(order);
        
        var ownerAccount = order.getSharedByAccount();
        if(!isNull(ownerAccount)){
            getHibachiScope().setSessionValue('ownerAccountNumber',ownerAccount.getAccountNumber());
        }

        order.setPromotionCacheKey('');
        getService('OrderService').processOrder(order,'updateOrderAmounts');
        getService("HibachiSessionService").persistSession();
        getHibachiScope().flushORMSession();
        return order;
    }
    
}
