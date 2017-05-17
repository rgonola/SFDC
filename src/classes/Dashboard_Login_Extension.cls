public class Dashboard_Login_Extension {

   
    public boolean iserror {get;set;}
    public String username {get;set;}
    public String password {get;set;}
    public Dashboard_Login__c dsh {get;set;}
    
    public Dashboard_Login_Extension () {
      
      dsh = new Dashboard_Login__c ();
     
    }
 public pagereference onLogin() {
  
         iserror=false; 
         
        String clientId = ApexPages.currentPage().getParameters().get('clientid');
       
          
        system.debug('****clientId*****'+clientId);
        if(dsh.Username__c == null || dsh.Username__c == ''){
            VFUtil.AddErrorMessage('Username is required');
            iserror=true;
            return null;
        }
    
        if(dsh.Password__c== null || dsh.Password__c== ''){
            VFUtil.AddErrorMessage('Password is required');
            iserror=true;
            return null;
        }
       
      
       List<Dashboard_Login__c>  login =[select id,Name,Username__c,Password__c   from Dashboard_Login__c Where Username__c=:dsh.Username__c];
        
        if(login.size()==0){
          
           VFUtil.AddErrorMessage('Username not found.');
            iserror=true;
            return null;
        
        }else{
        
        if(dsh.Password__c != login[0].Password__c ){
          
           VFUtil.AddErrorMessage('Please enter valid Password.');
            iserror=true;
            return null;
            }else{
            
            
            Cookie cooky = new Cookie('dshlogin', login[0].Id, null, 172800, false); 
            ApexPages.currentPage().setCookies(new Cookie[]{cooky }); 
            
             Decimal r=math.random();                  
           PageReference url = new PageReference('/apex/Bar_chart');
           url.setRedirect(true);
           return url;            
           
           
            
            }
            
            
            
        }
           return null;
          }
   
   
 
  



}