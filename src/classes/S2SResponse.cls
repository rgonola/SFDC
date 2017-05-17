global class S2SResponse{
   public Result Result;
  
    
    global class Result{
        public String AccountId;  
        public String ContactID; 
        public String Response_Message; 
        public String OppId;
          
    }
    
   
    
    public static S2SResponse parse(String json){
        return (S2SResponse) System.JSON.deserialize(json, S2SResponse.class);
    }

    
}