import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { UpgradeModule } from '@angular/upgrade/static';
import { bootstrapper } from './bootstrap';
import { HeroDetailComponent } from './slatwall/components/herodetail.component';
import { slatwalladminmodule } from './slatwall/slatwalladmin.module';
import {AlertModule} from "../../../org/Hibachi/client/src/alert/alert.module";
import {DialogModule} from "../../../org/Hibachi/client/src/dialog/dialog.module";
@NgModule({
  imports: [
    BrowserModule,
    UpgradeModule,
    AlertModule,
    DialogModule
  ],
  declarations:[
      HeroDetailComponent
  ],
  entryComponents: [
    HeroDetailComponent
  ]
})
export class AppModule {
  constructor(private upgrade: UpgradeModule) { }
  ngDoBootstrap() {
     var bootstrapperInstance:any = new bootstrapper();
     bootstrapperInstance.fetchData().then(()=>{
         //console.log('test');
        this.upgrade.bootstrap(document.body,[slatwalladminmodule.name]);
        console.log(this.upgrade);
     });
  }
}