import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { UpgradeModule } from '@angular/upgrade/static';
import { bootstrapper } from './bootstrap';
import { HeroDetailComponent } from './slatwall/components/herodetail.component';
@NgModule({
  imports: [
    BrowserModule,
    UpgradeModule
  ],
  declarations:[
      HeroDetailComponent
  ],
  entryComponents: [
    HeroDetailComponent
  ]
  
})
export class AppModule {
    //@ngInject
  constructor(private upgrade: UpgradeModule) { }
  ngDoBootstrap() {
      console.log('test');
     var appData:any = new bootstrapper();
     console.log('test2');
     appData.resolve(()=>{
          console.log('test3');
          //try{
         this.upgrade.bootstrap(document.body,['slatwalladmin'],{strictdi:true});
          /*}catch(e){
              console.log('test4');
          }*/
         
     });
  }
}