global class PfxAccountpullResponse{
   public Result Result;
  
    
    global class Result{
        public String AccountId;  
        public String ContactID; 
        public String Response_Message; 
          
    }
    
   
    
    public static PfxAccountpullResponse parse(String json){
        return (PfxAccountpullResponse) System.JSON.deserialize(json, PfxAccountpullResponse.class);
    }

    
}