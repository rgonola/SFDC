global class JsonResponse{
   public Result result;
  
    
    global class Result{
        public String requestRecievedFor;  
        public String CID;  
        public Double Balance; 
        public String Status;   
        public String ErrorCode;    
        public String Message;  
    }
    
   
    
    public static JsonResponse parse(String json){
        return (JsonResponse) System.JSON.deserialize(json, JsonResponse.class);
    }

    
}