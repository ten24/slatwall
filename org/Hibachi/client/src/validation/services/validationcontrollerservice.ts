import { Injectable,Inject } from "@angular/core";
import { FormControl, Validators } from '@angular/forms';
import { $Hibachi } from '../../core/services/hibachiservice';
import { ValidatorFn, AbstractControl } from '@angular/forms';

@Injectable()
export class ValidationControllerService {
    
    constructor(
        private $hibachi: $Hibachi
        ) {
        
    }
    
    addValidation = (formControl :FormControl, validationType :string, propertyIdentifier :string) => {
        let validator:any;
        switch(validationType) {
            case 'required' :
                //formControl.addValidators([Validators.required]);
                //console.log(formControl);
                //debugger;
                validator = Validators.required;
                break;
            
            case 'regex' :
                //formControl.addValidators([Validators.pattern(`^[a-zA-Z0-9-_.|:~^]+$`)]);
                //debugger;
                validator = Validators.pattern(`^[a-zA-Z0-9-_.|:~^]+$`);
                break;
            
            case 'unique' :
                validator = this.checkUnique(formControl,propertyIdentifier);
                break;
        
        }
        
        return validator; 
        
    }
    
    checkUnique = (formControl, property): ValidatorFn  => {
        return (control: AbstractControl): {[key: string]: any} | null => {
            this.$hibachi.checkUniqueValue(formControl, property, formControl.value).then((unique) =>  {
                if(unique) {
                    return { 'unique': true };    
                }            
                else {
                    return null;    
                }
            });
        };   
    
    }
    
}