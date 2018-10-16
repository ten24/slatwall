import { Component } from '@angular/core';

@Component({
  selector: 'hero-detail',
  template: `
    <h2>Windstorm details!</h2>
    <div><label>id: </label>1</div>
    <p sw-rbkey [swrbkey]=""></p>
  `
})
export class HeroDetailComponent { }