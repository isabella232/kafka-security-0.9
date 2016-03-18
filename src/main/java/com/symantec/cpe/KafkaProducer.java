package com.symantec.cpe;

import com.symantec.cpe.kafka.producer.KafkaProducerNewJava;

public class KafkaProducer {
  
  public static void main(String[] args) {
    
    if(args == null || args.length<1){
      System.out.println("jar -cp <JarName> com.symantec.cpe.KafkaProducer <propertyfile>");
       
    }else{
       KafkaProducerNewJava newJava = new KafkaProducerNewJava(args[0]);
      
//      // For abrupt termination
//      Runtime.getRuntime().addShutdownHook(new Thread() {
//        public void run() {  
//          System.out.println("Closing connection on CTRL C");
//          if(newJava !=null){
//            newJava.close();
//            System.out.println("Closed");
//          }
//
//        }
//      });
      try{
        // start program
        newJava.start();
        // send message
        newJava.produceCount();
        // close connection.
//        newJava.close();
        System.out.println("Finished successfully");
      }catch(Exception e){
        
        if(newJava !=null){
          newJava.close();
          System.out.println("Closed");
        }
        System.out.println("Error while running the program");
        e.printStackTrace();
      }
      
    }
    
  }

}
