import {NgModule,APP_INITIALIZER} from '@angular/core';
import {UpgradeModule} from '@angular/upgrade/static';
import {AppProvider,AppConfig,ResourceBundles,AttributeMetaData} from "../../../../admin/client/src/app.provider";
import {frontendmodule} from './frontend/frontend.module';
import {coremodule} from "./core/core.module";

export function startupServiceFactory(appProvider: AppProvider, appConfig: AppConfig, resourceBundles: ResourceBundles, attributeMetaData: AttributeMetaData): Function {
    return () => {
    
        appProvider.fetchData().then(() => {
            for (var key in appProvider.appConfig) {

                appConfig[key] = appProvider.appConfig[key];
            }
            if (appProvider.attributeMetaData) {
                for (var key in appProvider.attributeMetaData) {
                    attributeMetaData[key] = appProvider.attributeMetaData[key];
                }
            }
            for (var key in appProvider._resourceBundle) {
                resourceBundles[key] = appProvider._resourceBundle[key];
            } 
            appProvider.hasData = true;

        });

    };
}

@NgModule({
  providers: [
      AppProvider,
      AppConfig,
      ResourceBundles,
      AttributeMetaData,
      { 
        provide: APP_INITIALIZER, 
        useFactory: startupServiceFactory, 
        deps: [AppProvider, AppConfig, ResourceBundles, AttributeMetaData], multi: true 
      }
  ],
  imports: [
  ],
  declarations:[],
  entryComponents: []
})

export class BaseBootstrap {
        
    constructor(
        upgrade,
        appProvider,
        appConfig ,
        resourceBundles,
        attributeMetaData,
        module_name 
    ) {
        this.getData(upgrade,appProvider,appConfig,resourceBundles,attributeMetaData,module_name);
    }
    
    getData(upgrade,appProvider,appConfig,resourceBundles,attributeMetaData,module_name) {
        appProvider.hasData$.subscribe((hasData:boolean)=>{ 
          if(hasData){ 
            coremodule.constant('appConfig',appConfig);
            coremodule.constant('resourceBundles',resourceBundles);
            coremodule.constant('attributeMetaData',attributeMetaData);
            upgrade.bootstrap(document.body,[module_name]);
          }
        })
    }
    
    
}