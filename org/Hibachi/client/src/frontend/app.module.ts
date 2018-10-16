import {NgModule} from '@angular/core';

import { HttpClientModule } from "@angular/common/http";
import {BrowserModule} from '@angular/platform-browser';
import {UpgradeModule} from '@angular/upgrade/static';
import {FrontendModule,frontendmodule} from './frontend.module';
import {BaseBootstrap} from '../basebootstrap.module';

import {coremodule}  from  "../core/core.module";
import { parseProvider,logProvider,filterProvider,timeoutProvider,qProvider,httpProvider,injectorProvider,windowProvider,rootScopeProvider,locationProvider,anchorScrollProvider } from "../../../../../admin/client/src/ajs-upgraded-providers";  
import {AppProvider,AppConfig,ResourceBundles,AttributeMetaData} from "../../../../../admin/client/src/app.provider";


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
    FrontendModule
  ],
  declarations:[
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
    super(upgrade,appProvider,appConfig,resourceBundles,attributeMetaData,frontendmodule.name);

  }
  ngDoBootstrap() {  

  }
}