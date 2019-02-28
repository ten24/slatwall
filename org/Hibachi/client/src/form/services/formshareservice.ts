import { Injectable } from '@angular/core';
import { Subject, BehaviorSubject } from 'rxjs';

@Injectable()
export class FormShareService {

    private formSource = new BehaviorSubject<any>('');
    
    public form$ = this.formSource.asObservable();
    
    constructor() {
        
    }
    
    setForm(form:any) {
        this.formSource.next(form);
    }
    
}