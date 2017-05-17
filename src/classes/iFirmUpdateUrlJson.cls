global class iFirmUpdateUrlJson{

      
   public String Users;    
   public String Timezone;    
   public String ResetUserEmail;  
   public String LicenceName;  
   public String CountryCode;  
   public Features Features;
    
    global class Features {
    
    public String[] Profiles;
    
    }    
    
    
    
    
    public static iFirmUpdateUrlJson parse(String json){
        return (iFirmUpdateUrlJson) System.JSON.deserialize(json, iFirmUpdateUrlJson.class);
    }
    
    
    static testMethod void testParse() {
        String json=        '{"Users":"1","Timezone":"America/New_York","ResetUserEmail":"lori.henderson@wolterskluwer.com","LicenceName":"N E ROME & ASSOCIATES CPA","Features":{"Profiles":["Default (Test)","Default (Test)","Practice Management (Test)","Practice Management (Test)"]},"CountryCode":"US"}';
        iFirmUpdateUrlJson obj = parse(json);
        System.assert(obj != null);
    }
  
}