global class iFirmUrlJson{

    public String WebCluster;   
    public String Users;    
    public String Timezone; 
    public String Stream;   
    public String SiteType; 
    public String Sitename; 
    public String SiteDataType; 
    public String ResetUserPassword;    
    public String ResetUserEmail;  
    public String LicenceName;
    public String DomainName;   
    public String CountryCode;  
    public Features Features;
    
    global class Features {
    
    public String[] Profiles;
    
    }    
    
    
    
    
    public static iFirmUrlJson parse(String json){
        return (iFirmUrlJson) System.JSON.deserialize(json, iFirmUrlJson.class);
    }
    
    
    static testMethod void testParse() {
        String json=        ' {"WebCluster":"us-test","Users":"1","Timezone":"America/New_York","Stream":"LIVE","SiteType":"iFirm","Sitename":"steadmantaxservices","SiteDataType":"SFMBLANK","ResetUserPassword":"Password12","ResetUserEmail":"lori.henderson@wolterskluwer.com","LicenceName":"1st Choice Tax Professionals","Features":{"Profiles":["Default (Test)","Practice Management (Test)"]},"DomainName":"cchifirm.us","CountryCode":"US"}';
        iFirmUrlJson obj = parse(json);
        System.assert(obj != null);
    }
  
}