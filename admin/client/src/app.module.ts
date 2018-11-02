import {NgModule, Injectable} from '@angular/core';

import { HttpClientModule } from "@angular/common/http";
import {BrowserModule} from '@angular/platform-browser';
import {UpgradeModule,downgradeInjectable} from '@angular/upgrade/static';
import {slatwalladminmodule} from './slatwall/slatwalladmin.module';
import {BaseBootstrap} from "../../../org/Hibachi/client/src/basebootstrap.module";

import {CoreModule,coremodule}  from  "../../../org/Hibachi/client/src/core/core.module";
import {LoggerModule} from "../../../org/Hibachi/client/src/logger/logger.module";
import { parseProvider,logProvider,filterProvider,timeoutProvider,qProvider,httpProvider,injectorProvider,windowProvider,rootScopeProvider,locationProvider,anchorScrollProvider } from "./ajs-upgraded-providers";  
import {SlatwallAdminModule} from "./slatwall/slatwalladmin.module";
import {AppProvider,AppConfig,ResourceBundles,AttributeMetaData} from "./app.provider";

import { SwRbKey } from "../../../org/Hibachi/client/src/core/components/swrbkey";


@NgModule({
  providers: [
    AppProvider,
    AppConfig,
    ResourceBundles,
    AttributeMetaData,
    parseProvider,
    logProvider,
    filterProvider,
    timeoutProvider,
    qProvider,
    httpProvider,
    windowProvider,
    rootScopeProvider,
    locationProvider,
    anchorScrollProvider
  ],
  imports: [
    HttpClientModule,
    BrowserModule,
    UpgradeModule,
    CoreModule,
    LoggerModule,
    SlatwallAdminModule
  ],
  declarations:[
//      SwRbKey
  ],
  entryComponents: [

  ]
})
export class AppModule extends BaseBootstrap { 
  constructor(
    private upgrade: UpgradeModule, 
    private appProvider:AppProvider,
    private appConfig:AppConfig,
    private resourceBundles:ResourceBundles,
    private attributeMetaData:AttributeMetaData
  ) {
        super(upgrade,appProvider,appConfig,resourceBundles,attributeMetaData,slatwalladminmodule.name);
  }
  ngDoBootstrap() {  

  }
}
