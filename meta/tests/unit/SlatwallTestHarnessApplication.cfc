component extends="Slatwall.Application" {
    
    // Test Harness Setup
    variables.testharness = structNew();
    variables.testharness.beanFactoryReloadKey = "reloadbf"; // url key to trigger only bean factory reload (beans to reload can be configured as subset)
    variables.testharness.entityReloadKey = "reloadentity"; // url key to trigger only orm reload
    variables.testharness.modelReloadKey = "reloadmodel"; // url key to trigger both bean factory reload and orm reload
    variables.testharness.beanFactoryReloadInclude = ""; // comma-delimited list by bean name, service, dao etc. only to include reload
    variables.testharness.beanFactoryReloadExclude = ""; // comma-delimited list by bean name, service, doa etc. to exclude from reload
    variables.testharness.reloadKeysOnEveryRequest = ""; // using 'reloadmodel' is equivalent to 'reloadbf,reloadentity', matching is based on keys above
    
    // Allow For Instance Config
	try{include "../../../custom/config/configTestHarness.cfm";}catch(any e){logTest("*** MUST *** Create 'Slatwall/custom/config/configTestHarness.cfm' file to declare settings")}

    public any function bootstrap() {
        logTest("Running in the Test Harness Application context.");
        return super.bootstrap();
    }

    public any function verifyApplicationSetup() {
        // Purpose is to increase performance & minimize wait time during reloads in development environment (frequent manual reloads)
        // No reason to run unless application has been initialized atleast once prior (and hibachi application values must exist in hibachiScope)
        if (getHibachiScope().hasApplicationValue("initialized")) {
            logTest("Application had been initialized prior request.");
            // (url[variables.testharness.beanFactoryReloadKey] || (len(url[variables.testharness.beanFactoryReloadKey]) == 0))
            if (structKeyExists(url, variables.testharness.beanFactoryReloadKey) || 
                listFindNoCase(variables.testharness.reloadKeysOnEveryRequest, variables.testharness.beanFactoryReloadKey) || 
                structKeyExists(url, variables.testharness.modelReloadKey) || 
                listFindNoCase(variables.testharness.reloadKeysOnEveryRequest, variables.testharness.modelReloadKey)) {
                logTest("Requested manually reloading bean factory.");
                reloadBeans();
            }

            // (url[variables.testharness.entityReloadKey] || (len(url[variables.testharness.entityReloadKey]) == 0))
            if (structKeyExists(url, variables.testharness.entityReloadKey) || 
                listFindNoCase(variables.testharness.reloadKeysOnEveryRequest, variables.testharness.entityReloadKey) || 
                structKeyExists(url, variables.testharness.modelReloadKey) || 
                listFindNoCase(variables.testharness.reloadKeysOnEveryRequest, variables.testharness.modelReloadKey)) {
                logTest("Requested reloading entities.");
                var reloadStartTime = getTickCount();
                super.reloadOrm();
                logTest("ORM entities reloaded in #round((getTickCount() - reloadStartTime) / 100) / 10# seconds");
            }
        }
        
        super.verifyApplicationSetup();
    }

    /**
     * Clears beans from cache structures stored in the beanFactory, the next beanFactory.getBean() call will reinstantiate bean
     * Depending on use, beanFactory state could become invalid with unintended results (minimally reloading bean in asynchronousl fashion)
     * State easily corrected with a reload=true as one would expect
     * Reason being is that the beanFactory is unaware of the invalid state of other cached beans that have a dependancy on the reloaded bean 
     * Therefore any other beans with a dependancy on the reloaded bean (which are not being reloaded) will still have the wrong instance set
     * This is only intended to aid in development. This is not any sort of replacement or for production runtime.
     */
    private function reloadBeans() {
        var beanNamesForReload = [];

        // filter via inclusion only
        if (listLen(variables.testharness.beanFactoryReloadInclude)) {
            // Check to notify of EncryptionService issue
            if (listFindNoCase(variables.testharness.beanFactoryReloadInclude, "EncryptionService") || listFindNoCase(variables.testharness.beanFactoryReloadInclude, "EncryptionServiceservice")) {
                throw(message="EncryptionService cannot be reloaded to an issue with its init() method. Refractoring necessary.", type="known.issue");
            }

            beanNamesForReload = listToArray(variables.testharness.beanFactoryReloadInclude);
        // all beans with exlusion filter applied
        } else {
            // FIXME EncryptionService has bug using init method before dependencies resolved
            var beanInfo = getBeanFactory().getBeanInfo().beanInfo;
            for (var beanName in beanInfo) {

                // Manually declare all beans from current bean factory except for the automatically generated beanFactory self reference
                // Only concerned with adding singleton beans
                if (beanName != "beanFactory" && structKeyExists(beanInfo[beanName], "cfc") && beanInfo[beanName].isSingleton) {
                    // Make sure bean not in exclusion list or not EncryptionService
                    if (!listFindNoCase(variables.testharness.beanFactoryReloadExclude, beanName) && beanName != "EncryptionService" && beanName != "EncryptionServiceservice") {
                        arrayAppend(beanNamesForReload, beanName);
                    } else {
                        logTest("Bean reload exluded: #beanName#");
                    }
                } else if (structKeyExists(beanInfo[beanName], "value")) {
                    // Do nothing, should not need to do anything in this case
                }
            }
        }

        // Performs reload on subset or do proper full reload
        arraySort(beanNamesForReload, "text", "asc");
        if (arrayLen(beanNamesForReload)) {
            logTest("Reloading beans manually by one by one.");
            for (var beanName in beanNamesForReload) {
                reloadBean(beanName);
                logTest("Bean reloaded: '#beanName#'");
            }

            var reloadStartTime = getTickCount();
            // Instantiate reloaded beans (only singletons)
            var beanInfo = getBeanFactory().getBeanInfo().beanInfo;
            for (var beanName in beanInfo) {
                if (beanInfo[beanName].isSingleton) {
                    getBeanFactory().getBean(beanName);
                }
            }

            logTest("#arrayLen(beanNamesForReload)# beans manually reloaded in #round((getTickCount() - reloadStartTime) / 100) / 10# seconds");
        // Should never run with current logic
        } else {
            logTest("Reloading beans properly using 'beanFactory.load()' method");
            var reloadStartTime = getTickCount();
            // getBeanFactory().load(); // 'EncryptionService' causes error
            logTest("Beans reloaded in #round((getTickCount() - reloadStartTime) / 100) / 10# seconds");
        }
    }

    /**
     * Clears a bean from cache structures stored in the beanFactory, the next beanFactory.getBean() call will reinstantiate bean
     * This is only intended to aid in development. This is not any sort of replacement or for production runtime.
     */
    private function reloadBean(beanName) {
        verifyBeanFactoryMixin();

        // clear services and daos from application. Values get set when HibachiObject.getService() called
        getHibachiScope().clearApplicationValue("service_#arguments.beanName#");
        getHibachiScope().clearApplicationValue("service_#arguments.beanName#service");
        getHibachiScope().clearApplicationValue("service_#arguments.beanName#Hibachi");
        getHibachiScope().clearApplicationValue("dao_#arguments.beanName#");
        getHibachiScope().clearApplicationValue("dao_#arguments.beanName#dao");

        // Use a mixin method 'getVariablesScope()' to bypass beanFactory encapsulation and expose the relevant properties to clear out
        var beanFactoryCacheStructNames = ["beanCache", "resolutionCache", "getBeanCache", "accumulatorCache", "initMethodCache"];
        for (var cacheStructName in beanFactoryCacheStructNames) {
            var beanFactoryCacheStruct = getBeanFactory().getVariablesScope()[cacheStructName];

            if (structKeyExists(beanFactoryCacheStruct, arguments.beanName)) {
                structDelete(beanFactoryCacheStruct, arguments.beanName);
            }
            // Bean alias with suffix 'server' exists when aop.config.omitDirectoryAliases=false
            if (structKeyExists(beanFactoryCacheStruct, "#arguments.beanName#service")) {
                structDelete(beanFactoryCacheStruct, "#arguments.beanName#service");
            }
            // Bean alias with suffix 'dao' exists when aop.config.omitDirectoryAliases=false
            if (structKeyExists(beanFactoryCacheStruct, "#arguments.beanName#dao")) {
                structDelete(beanFactoryCacheStruct, "#arguments.beanName#dao");
            }
            // Bean alias with suffix 'Hibachi' exists
            if (structKeyExists(beanFactoryCacheStruct, "#arguments.beanName#Hibachi")) {
                structDelete(beanFactoryCacheStruct, "#arguments.beanName#Hibachi");
            }
        }
    }

    /**
     * Sets helper mixin functions on beanFactory
     */
    private function verifyBeanFactoryMixin() {
        if (!structKeyExists(variables, "beanFactoryMixinFlag") || !variables.beanFactoryMixinFlag) {
            // Inject UDF method to expose private variables scope
            getBeanFactory().getVariablesScope = _$getVariablesScope;
            variables.beanFactoryMixinFlag = true;
        }
    }

    /**
     * Helper method used only for mixin injection
     */
    private any function _$getVariablesScope() {
        return variables;
    }

    public void function logTest(message) {
        writeLog(file="#variables.framework.applicationKey#", text="Test Harness Log - #arguments.message#");
    }
}