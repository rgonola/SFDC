public class validateAccount {
    public Id id{get;set;}
    public Contact con{get;set;}
    public Boolean validate{get;set;}
    public validateAccount(ApexPages.StandardController controller) {
    
        id = apexpages.currentpage().getparameters().get('id');
        validate = false;
        try{   
            con = [select Id,Name,AccountId,DoNotCall,FirstName,Account.EBR_GTD__c,Is_Primary__c,Email,Phone,LastName from Contact where AccountId =: id And Is_Primary__c =: True limit 1];
            if(con.DoNotCall == true && con.Is_Primary__c == true && (con.Account.EBR_GTD__c < System.Today() || con.Account.EBR_GTD__c == NULL ))
            {
                system.debug('***********I am in*');    
                validate = true;
            }
        }catch(Exception e)
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Warning,'Please select at least one contact as primary'));
              
        }    
      
     
    }

}