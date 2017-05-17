public with sharing class IIT_ControllerHandlingForPaymentPlan {
        
        public SBQQ__Quote__c quoteObj{get;set;}
        public list<InstallmentWrapper> listOFInstallmentWrapper{get;set;}
        public decimal totalAmount{get;set;}
        public decimal totalPaymentAmount{get;set;}
        public decimal balanceAmount {get;set;}
        public decimal exceededAmount {get;set;}
        public boolean stopSave {get;set;}
        public decimal firstDownPayment {get;set;}
        public invoiceit_s__Payment_Plan__c paymentPlan {set;get;}
        list<invoiceit_s__Payment_Plan_Installment__c> listOfPaymentInstall = new list<invoiceit_s__Payment_Plan_Installment__c>();
        public boolean inConstuructor = false;
        public boolean isrender{set;get;}
        public boolean isAddRender{get;set;}
        public boolean isTaxRender{get;set;}
        String[] paymentmethod ;
        List<SelectOption> options = new List<SelectOption>();
        public integer InstllCount;
        public IIT_ControllerHandlingForPaymentPlan(ApexPages.StandardController controller) {
                isrender = true;
                isTaxRender = true;
                quoteObj = (SBQQ__Quote__c)controller.getRecord();
                list<SBQQ__Quote__c> isorder = [SELECT Id,Name,QTC__Order__c,SBQQ__Opportunity2__c FROM SBQQ__Quote__c WHERE QTC__Order__c != null AND Id = :quoteObj.id];
                if(isorder.size() > 0 ){
                    isrender = false;
                    Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'Already Order is created ');
                    Apexpages.addMessage(infoMessage);
                }
                paymentPlan = new invoiceit_s__Payment_Plan__c();
                quoteObj = [select COA__c,QTC__Payment_Plan__r.Name,name, Tax__c, SBQQ__Account__c,SBQQ__Account__r.Sales_Team__c  ,Down_Payment_Criteria__c ,QTC__Payment_Plan__c,SBQQ__ListAmount__c,SBQQ__NetAmount__c from SBQQ__Quote__c where id=: quoteObj.id];
                if(quoteObj.Tax__c == null){
                    isTaxRender = false;
                    Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'Ensure tax has been calculated');
                    Apexpages.addMessage(infoMessage);
                }
                listOFInstallmentWrapper = new list<InstallmentWrapper>();
                InstllCount = 0;
                totalAmount = 0;
                exceededAmount = 0;
                totalPaymentAmount = quoteObj.SBQQ__NetAmount__c;
                balanceAmount = 0;
                stopSave = true;
                inConstuructor = true;
                if(isTaxRender) 
                processpaymentPlan();
                inConstuructor = false;
                if(quoteObj.QTC__Payment_Plan__c != null){
                  isAddRender = true;
                paymentPlan = [SELECT invoiceit_s__Down_Payment__c,invoiceit_s__Down_Payment_Amount__c, Active__c, Name, invoiceit_s__Is_Plan_Editable__c,
                                invoiceit_s__Installment_Start_Date__c,invoiceit_s__No_of_Installments__c,invoiceit_s__Minimum_Installments__c,
                                invoiceit_s__Type_of_Installments__c, Payments_Date_Range__c,End_Date__c,
                                Down_Payment_Criteria__c, invoiceit_s__Maximum_Installments__c,Max_Number_of_Payment_Methods__c,Payment_Methods__c,Payment_Plan_Start_Date__c, Payment_Plan_End_Date__c
                                FROM invoiceit_s__Payment_Plan__c
                                WHERE ID =: quoteObj.QTC__Payment_Plan__c];  
                listOfPaymentInstall = [SELECT Id, Payment_Method1__c ,invoiceit_s__Account__c,invoiceit_s__Payment_Amount__c,invoiceit_s__Payment_Date__c,invoiceit_s__Payment_Method__c,invoiceit_s__Payment_Type__c,Name,QTC__Quote__c,Min_Down_Payment__c  FROM invoiceit_s__Payment_Plan_Installment__c WHERE QTC__Quote__c = : quoteObj.id];
                System.debug('Payment Installment --->'+listOfPaymentInstall); 
                System.debug('paymentPlan.Payment_Methods__c --->'+paymentPlan.Payment_Methods__c); 
                List<String> paymentmethod = paymentPlan.Payment_Methods__c.split(';');
                
                System.debug('Payment Installment --->'+paymentmethod); 
                if(listOfPaymentInstall.size() > 0){
                    InstallmentWrapper payinstallmentWrapperLocal;
                         options = new List<SelectOption>();
                          for(integer i=0; i<paymentmethod.size(); i++){              
                            options.add(new SelectOption(paymentmethod[i],paymentmethod[i]));

                         }
                    //paymentmethodcon =paymentPlan.invoiceit_s__Payment_Type__c.split(';');
                    for(invoiceit_s__Payment_Plan_Installment__c paymentinstaPlan : listOfPaymentInstall){
                         
                        payinstallmentWrapperLocal = new InstallmentWrapper();
                        payinstallmentWrapperLocal.paymetnInstallment = paymentinstaPlan;
                        payinstallmentWrapperLocal.icount = InstllCount;
                        
                        if(payinstallmentWrapperLocal.paymetnInstallment.invoiceit_s__Payment_Type__c == '--None--'){
                           payinstallmentWrapperLocal.selectpick.add(new selectoption('--None--','--None--'));
                           payinstallmentWrapperLocal.selectpick.addall(options);
                        }else{
                          payinstallmentWrapperLocal.selectpick= options;
                          //payinstallmentWrapperLocal.selectpick.add(new selectoption('--None--','--None--'));
                        }
                        
                        payinstallmentWrapperLocal.valuesOfSelect = paymentinstaPlan.invoiceit_s__Payment_Type__c;
                        listOFInstallmentWrapper.add(payinstallmentWrapperLocal);
                        ++InstllCount;
                        System.debug('Install count'+InstllCount);

                    }

                }
                }else{
                  isAddRender = false;
                }


        }
        
        public PageReference processpaymentPlanButton() {
         
             listOfPaymentInstall = [SELECT Id,QTC__Quote__r.SBQQ__Account__c,invoiceit_s__Payment_Amount__c,invoiceit_s__Account__c,invoiceit_s__Payment_Date__c,invoiceit_s__Payment_Method__c,invoiceit_s__Payment_Type__c,Name,QTC__Quote__c, Payment_Method1__c FROM invoiceit_s__Payment_Plan_Installment__c WHERE QTC__Quote__c = : quoteObj.id];
             If(listOfPaymentInstall.size() > 0){
                delete listOfPaymentInstall;
             }
             processpaymentPlan();
             return null;
        }
        
        public pageReference processpaymentPlan(){
            String[] downCritiria ;
            
            
             firstDownPayment = 0;
             listOFInstallmentWrapper = new list<InstallmentWrapper>();
             if(quoteObj.QTC__Payment_Plan__c != null ){
                 isAddRender = true;  
                 paymentPlan = [SELECT invoiceit_s__Down_Payment__c,invoiceit_s__Down_Payment_Amount__c, Active__c, Name, invoiceit_s__Is_Plan_Editable__c,
                                invoiceit_s__Installment_Start_Date__c,invoiceit_s__No_of_Installments__c,invoiceit_s__Minimum_Installments__c,
                                invoiceit_s__Type_of_Installments__c, Payments_Date_Range__c, End_Date__c, Payment_Methods__c, Payment_Plan_Start_Date__c, Payment_Plan_End_Date__c,
                                Down_Payment_Criteria__c,invoiceit_s__Maximum_Installments__c,Max_Number_of_Payment_Methods__c
                                FROM invoiceit_s__Payment_Plan__c
                                WHERE ID =: quoteObj.QTC__Payment_Plan__c];
                
                     if(paymentPlan.Name == 'Bill Later Payment Plan'&& quoteObj.SBQQ__Account__r.Sales_Team__c != 'Premier' ){
                         System.debug('Coming inside insideinside');
                         Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'Bill Later Payment Plan can only be selected for Account sales with Premier');
                         Apexpages.addMessage(infoMessage);
                         return null;   
                     }
              
                            
                 if(paymentPlan.Down_Payment_Criteria__c != '' && paymentPlan.Down_Payment_Criteria__c != null){                                                                       
                 downCritiria = paymentPlan.Down_Payment_Criteria__c.split(';'); 
                 options = new List<SelectOption>();
                 String cc = 'Credit Card';
                  if(paymentPlan.Payment_Methods__c.contains(cc)){
                      options.add(new SelectOption('Credit Card','Credit Card'));
                  }else{
                      options.add(new SelectOption('--None--','--None--'));
                  }
                  paymentmethod =paymentPlan.Payment_Methods__c.split(';');
                  System.debug('Payment METHOD ------->'+paymentmethod);
                   
                 for(integer i=0; i<paymentmethod.size(); i++){
                     System.debug('For loop valuee is--------> '+paymentmethod[i]);
                    if(paymentmethod[i] != 'Credit Card'){
                    
                        options.add(new SelectOption(paymentmethod[i],paymentmethod[i]));
                        System.debug('Hii'+paymentmethod[i]);
                    }
                    

                 }   

                                                                                  
                 //list<SBQQ__QuoteLine__c> listOfQuoteLine  = [SELECT Id,Name,SBQQ__ListPrice__c,SBQQ__Product__c,SBQQ__Quote__c,SBQQ__ProductName__c FROM SBQQ__QuoteLine__c WHERE SBQQ__ProductName__c = : downCritiria and SBQQ__Quote__c =: quoteObj.id];                                                                                     
                
                 
                 String sQuery ='SELECT Id,Name,SBQQ__ListPrice__c,SBQQ__Product__c,SBQQ__Quote__c,SBQQ__ProductName__c FROM SBQQ__QuoteLine__c WHERE';
                 
                    
                    sQuery += '( SBQQ__ProductName__c IN: downCritiria ';
                 if(paymentPlan.Down_Payment_Criteria__c.contains('Processing/Shipping'))
                     sQuery += ' OR SBQQ__Product__r.Shipping_Processing__c = true )';
                  else
                     sQuery += ')';
                 sQuery += 'AND SBQQ__Quote__c = \'' +quoteObj.id + '\'';
                 
                 System.debug('sQuery--->'+sQuery);
                 List<SBQQ__QuoteLine__c> listOfQuoteLine = Database.query(sQuery);
                 
                 

                 
                  System.debug('listOfQuoteLinelistOfQuoteLine'+listOfQuoteLine);
                  System.debug('listOfQuoteLinelistOfQuoteLine'+listOfQuoteLine.size());
                 
                 for(SBQQ__QuoteLine__c qline: listOfQuoteLine){
                    if(paymentPlan.Down_Payment_Criteria__c.contains(qline.SBQQ__ProductName__c)) {
                        System.debug('Quote Tax');
                        firstDownPayment += qline.SBQQ__ListPrice__c;
                        System.debug('firstDownPaymentfirstDownPayment --49'+firstDownPayment);
                    }
                    else{
                        firstDownPayment += qline.SBQQ__ListPrice__c;
                    }
                    

                 }
                 
                  /*if(paymentPlan.Down_Payment_Criteria__c.contains(qline.SBQQ__ProductName__c)) {
                        System.debug('Quote Processing Fee');
                        firstDownPayment += qline.SBQQ__ListPrice__c;
                        System.debug('firstDownPaymentfirstDownPayment --54'+firstDownPayment);
                     }*/
                 
                 if(paymentPlan.Down_Payment_Criteria__c.contains('Down Payment Amount') && paymentPlan.invoiceit_s__Down_Payment__c != null) {
                    System.debug('Flat Dollar Amount');
                    firstDownPayment += paymentPlan.invoiceit_s__Down_Payment_Amount__c;
                    System.debug('firstDownPaymentfirstDownPayment--59'+firstDownPayment);
                 }
                 if(paymentPlan.Down_Payment_Criteria__c.contains('Down Payment Percentage') && paymentPlan.Down_Payment_Criteria__c != null) {
                    System.debug('Percentage Amount');
                    decimal diffAmount = quoteObj.SBQQ__NetAmount__c-firstDownPayment;
                    firstDownPayment += diffAmount*paymentPlan.invoiceit_s__Down_Payment__c/100;
                    System.debug('firstDownPaymentfirstDownPayment --65'+firstDownPayment);
                    //firstDownPayment += paymentPlan.invoiceit_s__Down_Payment__c;
                  }if(paymentPlan.Down_Payment_Criteria__c.contains('Quote Total')){
                      firstDownPayment += quoteObj.SBQQ__NetAmount__c;
                   }
                 }
                  integer iCountOfInstallment = integer.valueof(paymentPlan.invoiceit_s__Minimum_Installments__c);
                  System.debug('paymentPlan ===>'+paymentPlan.Down_Payment_Criteria__c);
                  decimal remaingAmount = quoteObj.SBQQ__NetAmount__c-firstDownPayment;
                  System.debug('remaingAmount ===>'+remaingAmount );
                  decimal  instAmount;
                  if(iCountOfInstallment > 1)
                  instAmount =  remaingAmount/(iCountOfInstallment-1);
                  
                  System.debug('No of installments ===>'+iCountOfInstallment );
                  System.debug('No of installments ===>'+quoteObj.SBQQ__NetAmount__c );
                        invoiceit_s__Payment_Plan_Installment__c paymetnInstallment;
                        
                        decimal iAmount = quoteObj.SBQQ__NetAmount__c / iCountOfInstallment; 
                        InstallmentWrapper installmentWrapperLocal;
                        for(integer i=0; i<iCountOfInstallment;i++){
                                paymetnInstallment = new invoiceit_s__Payment_Plan_Installment__c();
                                paymetnInstallment.QTC__Quote__c = quoteObj.id;
                                paymetnInstallment.invoiceit_s__Account__c = quoteObj.SBQQ__Account__c;
                                 if(i==0){
                                    paymetnInstallment.invoiceit_s__Payment_Amount__c =  firstDownPayment;
                                    paymetnInstallment.Min_Down_Payment__c = true;
                                 }else{
                                    paymetnInstallment.invoiceit_s__Payment_Amount__c =  instAmount;
                                 }
                                
                                installmentWrapperLocal = new InstallmentWrapper();
                                installmentWrapperLocal.selectpick= options;
                                installmentWrapperLocal.paymetnInstallment = paymetnInstallment;                        
                                installmentWrapperLocal.iCount = i;
                                if(!inConstuructor)
                                listOFInstallmentWrapper.add(installmentWrapperLocal);       
                                ++InstllCount;
                        }
                }else{
                    isAddRender = false;
                    Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'Please select Payment plan to process');
                    Apexpages.addMessage(infoMessage);
                } 
                firstDownPayment.setScale(2);  
                return null;          
        }
        public PageReference saveProcesspaymentPlan(){
            
            try{
            set<id> settOfPaymentMethods = new set<id>();
            set<id> settOfPaymentType = new set<id>();
            set<id> setOfPaymentDate = new set<id>();
               
            list<invoiceit_s__Payment_Plan_Installment__c> listOfInsUpdate = new list<invoiceit_s__Payment_Plan_Installment__c>();
            decimal dmindownpaymentselected = 0;
            for(InstallmentWrapper installmentWrapperLocal : listOFInstallmentWrapper){
                if(installmentWrapperLocal.paymetnInstallment.Min_Down_Payment__c ){
                    dmindownpaymentselected = dmindownpaymentselected + installmentWrapperLocal.paymetnInstallment.invoiceit_s__Payment_Amount__c;
                }
                //listOfInsUpdate.add(installmentWrapperLocal.paymetnInstallment);
                installmentWrapperLocal.paymetnInstallment.invoiceit_s__Payment_Type__c = installmentWrapperLocal.valuesOfSelect;
                
                if(installmentWrapperLocal.paymetnInstallment.invoiceit_s__Payment_Method__c != null)
                    settOfPaymentMethods.add(installmentWrapperLocal.paymetnInstallment.invoiceit_s__Payment_Method__c);
                if(installmentWrapperLocal.paymetnInstallment.invoiceit_s__Payment_Type__c == '--None--'){
                    settOfPaymentType.add(installmentWrapperLocal.paymetnInstallment.id);
                    
                }
                
                system.debug('193 is '+installmentWrapperLocal.paymetnInstallment.invoiceit_s__Payment_Type__c);
                System.debug('pAYMENT DATE ----268 '+installmentWrapperLocal.paymetnInstallment.invoiceit_s__Payment_Date__c);
                if(installmentWrapperLocal.paymetnInstallment.invoiceit_s__Payment_Date__c != null) {
                    System.debug('cOMING INIDE ');
                    if(installmentWrapperLocal.paymetnInstallment.invoiceit_s__Payment_Date__c >= paymentPlan.Payments_Date_Range__c 
                         && installmentWrapperLocal.paymetnInstallment.invoiceit_s__Payment_Date__c <= paymentPlan.End_Date__c
                       )
                    {
                        //setOfPaymentDate.add(installmentWrapperLocal.paymetnInstallment.invoiceit_s__Payment_Type__c);
                        //System.debug(''+setOfPaymentDate.size());
                        
                        //return null;
                    }
                    else 
                    {
                        System.debug('Naveen stopeed : dates mis match');
                        Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'The Entered Payment date(s) should be in between start and end date of selected payment plan. ');
                        Apexpages.addMessage(infoMessage);
                        return null;
                    }
                    if(installmentWrapperLocal.paymetnInstallment.invoiceit_s__Payment_Date__c != system.today() && installmentWrapperLocal.paymetnInstallment.Min_Down_Payment__c == true){
                        System.debug('Naveen stopeed  here id sisdfsd : dates mis match');
                        Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'Down payment date should be today');
                        Apexpages.addMessage(infoMessage);
                        return null;
                    }
                    if(installmentWrapperLocal.paymetnInstallment.invoiceit_s__Payment_Type__c=='COA' && installmentWrapperLocal.paymetnInstallment.Min_Down_Payment__c == true && quoteObj.COA__c < installmentWrapperLocal.paymetnInstallment.invoiceit_s__Payment_Amount__c){
                        Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'Insufficient COA');
                        Apexpages.addMessage(infoMessage);
                        return null;
                    }
                }else{
                    System.debug('Eles condition of ');
                        Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'Please select Payment Dates ');
                        Apexpages.addMessage(infoMessage);
                        return null;
                }
                
                //listOfInsUpdate.add(installmentWrapperLocal.paymetnInstallment);
            }
            
            if(dmindownpaymentselected < firstDownPayment){
                Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.Error, 'Cannot save a payment in which the minimum down payment requirements are not met.');
                        Apexpages.addMessage(infoMessage);
                        return null;
            }
            if(System.today() >= paymentPlan.Payment_Plan_Start_Date__c 
                         && (system.today() <= paymentPlan.Payment_Plan_End_Date__c || paymentPlan.Payment_Plan_End_Date__c == null) 
                       ){
                       
                       System.debug('If condition');
             }else{
                 System.debug('Else condition');
                 Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'Selected payment plan is not active');
                Apexpages.addMessage(infoMessage);
                return null;
             }
           
            if(settOfPaymentMethods.size() > integer.valueof(paymentPlan.Max_Number_of_Payment_Methods__c)){
                
                Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'You cannot add more than'+integer.valueof(paymentPlan.Max_Number_of_Payment_Methods__c)+' Payment Method');
                Apexpages.addMessage(infoMessage);
                return null;    
            }
            /*if(settOfPaymentType.size() > 0){
               Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'Please select the Payment Type');
                Apexpages.addMessage(infoMessage);
                return null; 
            }
            if(setOfPaymentDate.size() > 0){
               Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'Please select the payment date  betwen the start and date of payment plan ');
                Apexpages.addMessage(infoMessage);
                return null;  
            }*/
            if(quoteObj.QTC__Payment_Plan__c == null){
                Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'payment Plans is blank please select payment plan');
                Apexpages.addMessage(infoMessage);
                return null; 
            }
                        
            for(InstallmentWrapper installmentWrapperLocal : listOFInstallmentWrapper){
              installmentWrapperLocal.paymetnInstallment.invoiceit_s__Payment_Method__c = installmentWrapperLocal.paymetnInstallment.Payment_Method1__c;
              listOfInsUpdate.add(installmentWrapperLocal.paymetnInstallment);
            }
            upsert listOfInsUpdate;
            
             quoteObj.QTC__Payment_Plan__c  = paymentPlan.id; 
             quoteObj.Down_Payment_Criteria__c  = firstDownPayment;
            update quoteObj;
            
            System.debug('size is'+listOfInsUpdate.size() +' list contains'+ listOfInsUpdate);
            
            

                return new PageReference('/'+quoteObj.id);
            }catch(DMLException dMlEx){

                                Apexpages.Message errorMessage; 
                                for (Integer i = 0; i < dMlEx.getNumDml(); i++)
                                { 
                                        errorMessage = new Apexpages.Message(ApexPages.Severity.ERROR,dMlEx.getDmlMessage(i));
                                        Apexpages.addMessage(errorMessage);      
                                } 
                                return null; 
                        } 
                        catch(Exception ex){
                Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'ERROR'+ ex.getmessage() +''+ ex.getLineNumber()+''+ ex.getStackTraceString());
                Apexpages.addMessage(infoMessage);
                return null;
            }
                return null;
        }
        public PageReference addInstallment(){
            integer iWrapperListCout = listOFInstallmentWrapper.size();
            System.debug('AAAAA'+ iWrapperListCout);
            
            //if(iWrapperListCout > 0){
              if(paymentPlan.invoiceit_s__Maximum_Installments__c != null && iWrapperListCout == integer.valueof(paymentPlan.invoiceit_s__Maximum_Installments__c)){
                Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'You cannot add more than'+integer.valueof(paymentPlan.invoiceit_s__Maximum_Installments__c)+' installments');
                Apexpages.addMessage(infoMessage);
                return null;
              }
            //}
            //if(paymentPlan.Payment_Methods__c != null){
            options = new List<SelectOption>();
            String cc = 'Credit Card';
            if(paymentPlan.Payment_Methods__c.contains(cc)){
              options.add(new SelectOption('Credit Card','Credit Card'));
            }else{
              options.add(new SelectOption('--None--','--None--'));
            }
              paymentmethod =paymentPlan.Payment_Methods__c.split(';');
              //options = new List<SelectOption>();
                  //options.add(new SelectOption('--None--','--None--')); 
                 for(integer i=0; i<paymentmethod.size(); i++){
                     
                    if(paymentmethod[i] != 'Credit Card'){
                        options.add(new SelectOption(paymentmethod[i],paymentmethod[i]));
                        System.debug('Hii'+paymentmethod[i]);
                    }

                 } 

            //}
            options = new List<SelectOption>();
            String cc1 = 'Credit Card';
            if(paymentPlan.Payment_Methods__c.contains(cc1)){
              options.add(new SelectOption('Credit Card','Credit Card'));
            }else{
              options.add(new SelectOption('--None--','--None--'));
            }
            
            paymentmethod =paymentPlan.Payment_Methods__c.split(';');
             //options = new List<SelectOption>();
                  //options.add(new SelectOption('--None--','--None--')); 
                 for(integer i=0; i<paymentmethod.size(); i++){
                     
                    if(paymentmethod[i] != 'Credit Card'){
                        options.add(new SelectOption(paymentmethod[i],paymentmethod[i]));
                        System.debug('Hii'+paymentmethod[i]);
                    }

                 }                       
            InstallmentWrapper installmentWrapperLocal;
            invoiceit_s__Payment_Plan_Installment__c paymetnInstallment = new invoiceit_s__Payment_Plan_Installment__c();
            paymetnInstallment.QTC__Quote__c = quoteObj.id;
            paymetnInstallment.invoiceit_s__Account__c = quoteObj.SBQQ__Account__c;
            installmentWrapperLocal = new InstallmentWrapper();
            installmentWrapperLocal.paymetnInstallment = paymetnInstallment;
             installmentWrapperLocal.selectpick= options;
            installmentWrapperLocal.iCount = InstllCount + 1;
            listOFInstallmentWrapper.add(installmentWrapperLocal);      
            ++InstllCount;
            return null;
        }
        public void removeInstallment(){
            string  sParamCount = system.currentPageReference().getParameters().get('unWantedInstallmentCount');
            invoiceit_s__Payment_Plan_Installment__c installmentToDelete;
            
            for(integer i = 0; i< listOFInstallmentWrapper.size();i++){
                InstallmentWrapper installmentWrapperLocal = listOFInstallmentWrapper[i];
                if(installmentWrapperLocal.iCount == integer.valueof(sParamCount)){
                        listOFInstallmentWrapper.remove(i);     
                        
                        if(installmentWrapperLocal.paymetnInstallment.Id != null) {
                            installmentToDelete = new invoiceit_s__Payment_Plan_Installment__c(Id = installmentWrapperLocal.paymetnInstallment.Id);
                            delete installmentToDelete;
                        }
                        break;
                }
            }
        }
        
        /*public void isSplitAmount(){
            string  sParamCount = system.currentPageReference().getParameters().get('splitAmount');
            
            list<InstallmentWrapper> listOFNewInstallmentWrapper = new list<InstallmentWrapper>();
            InstallmentWrapper installmentWrapperLocalNew = new InstallmentWrapper();
            //InstallmentWrapper installmentWrapperLocalNew ; 
            
            for(InstallmentWrapper installmentWrapperLocal : listOFInstallmentWrapper){
            
                if(installmentWrapperLocal.iCount == integer.valueof(sParamCount)){
                   System.debug('installmentWrapperLocal.iCount'+installmentWrapperLocal.iCount); 
                   decimal splitAmount = installmentWrapperLocal.paymetnInstallment.invoiceit_s__Payment_Amount__c/2;
                   installmentWrapperLocal.paymetnInstallment.invoiceit_s__Payment_Amount__c = splitAmount;
                    installmentWrapperLocal.isSelectedValue = 'Added';
                    // new splited line
                    installmentWrapperLocalNew.paymetnInstallment = new invoiceit_s__Payment_Plan_Installment__c();
                    installmentWrapperLocalNew.paymetnInstallment.invoiceit_s__Payment_Amount__c = installmentWrapperLocal.paymetnInstallment.invoiceit_s__Payment_Amount__c;
                    installmentWrapperLocalNew.paymetnInstallment.QTC__Quote__c = quoteObj.id;
                    installmentWrapperLocalNew.isSelectedValue = 'Added';
                    
                   
                    installmentWrapperLocalNew.selectpick= options;
                    installmentWrapperLocalNew.iCount = InstllCount + 1;
                    listOFNewInstallmentWrapper.add(installmentWrapperLocal);
                    listOFNewInstallmentWrapper.add(installmentWrapperLocalNew);
                    
                    
                    //break;                  
                }else{
                 listOFNewInstallmentWrapper.add(installmentWrapperLocal);
                }
                ++InstllCount;
                
            }
            
            //listOFInstallmentWrapper.add(installmentWrapperLocalNew); 
            listOFInstallmentWrapper.clear();
            //listOFInstallmentWrapper.add(installmentWrapperLocalNew);
            listOFInstallmentWrapper.addAll(listOFNewInstallmentWrapper);
        }*/
         public PageReference addErrrorMsg(){
             Apexpages.Message infoMessage = new Apexpages.Message(ApexPages.Severity.INFO, 'Sum of payments should equal quote total.');
             Apexpages.addMessage(infoMessage);
             return null;
         }
         public class InstallmentWrapper{
                public invoiceit_s__Payment_Plan_Installment__c paymetnInstallment{get;set;}
                public integer iCount{get;set;}
                public string valuesOfSelect{get;set;}
                public boolean splitAmount{get;set;}
                public string isSelectedValue{get;set;}
                public list<SelectOption> selectpick{get;set;}
                public InstallmentWrapper(){
                        paymetnInstallment =  new invoiceit_s__Payment_Plan_Installment__c();
                        selectpick = new list<SelectOption>();
                        iCount = 0;
                        isSelectedValue = 'Available';
                }
        }       

}