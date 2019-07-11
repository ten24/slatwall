component extends="Slatwall.model.service.HibachiService" {
    
    public any function getSiteStructWithLanguages(){
        var siteStruct = {
            'North America'={},
            'Europe'={},
            'Australia'={}
        };
        var continentMap = {
            'mura-pl'='Europe',
            'mura-ie'='Europe',
            'mura-au'='Australia',
            'mura-uk'='Europe',
            'mura-ca'='North America',
            'mura-default'='North America'
        }
        var languageMap = {
            'en'='English',
            'fr'='French',
            'es'='Spanish'
        }
        var sites = getService('siteService').getSiteSmartList().getRecords();
        for(var site in sites){
            var siteCode = site.getSiteCode();
            var regionName = right(site.getSiteName(), len(site.getSiteName()) - 6);
            var languages = site.setting('siteAvailableLocales');
            var languageArray = [];
            var href = '/'&right(siteCode,len(siteCode) - 5)&'/';
            if(href == '/default'){
                href = '';
            }
            for(var language in languages){
                var languageInfo = {
                    'name'=languageMap[left(language,2)],
                    'value'=language
                };
                arrayAppend(languageArray, languageInfo);
            }
            var flagImagePath = '/assets/images/' & site.getFlagImageFilename();
            
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
    
}