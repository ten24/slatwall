import { Component } from '@angular/core';

@Component({
  selector: 'hero-detail',
  template: `
    <h2>Windstorm details!</h2>
    <div sw-rbkey [swRbkey]="'entity.Product.option.select'"><label>id: </label>1</div>
  `
})
export class HeroDetailComponent { }