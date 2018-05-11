import {BaseService} from "./baseservice";
import {Injectable} from "@angular/core";

@Injectable()
export class HistoryService { 

    private histories = {}; 

    //ngInject
    constructor(){

    }

    public recordHistory(key, data, overwrite=false){
        if(angular.isUndefined(this.histories[key]) || overwrite){
            this.histories[key] = []; 
        }
        this.histories[key].push(data); 
    }   
    
    public hasHistory(key){
        return angular.isDefined(this.histories[key]);
    }

    public getHistory(key) {
        if(angular.isDefined(this.histories[key])){
            return this.histories[key];
        }
    }

    public deleteHistory(key) {
        this.histories[key] = []; 
    }
    

}
