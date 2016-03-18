package com.symantec.cpe.Config;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class KafkaProducerConfig {

  public static Properties getProperties(String propertyFile) {
    Properties kafkaProp = new Properties();

    try {
      System.out.println("Loading properties from " + propertyFile);
      InputStream fileInputStream = new FileInputStream(propertyFile);
      kafkaProp.load(fileInputStream);
    } catch (IOException e) {
      e.printStackTrace();
      return null;
    }
    return kafkaProp;
  }


  //  private void configure(String brokerList, String sync, String a_zookeeper) {
  ////    // zoo keeper
  ////    kafkaProps.put("zookeeper.connect", a_zookeeper);
  ////    
  ////    // broker
  ////    kafkaProps.put("bootstrap.servers", brokerList);
  ////
  ////    // This is mandatory, even though we don't send keys
  ////    kafkaProps.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
  ////    kafkaProps.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");
  ////    kafkaProps.put("acks", "1");
  ////    kafkaProps.put("retries", "3");
  ////    kafkaProps.put("linger.ms", 5);
  ////    // security settings
  ////    kafkaProps.put(SslConfigs.SSL_PROTOCOL_CONFIG,"SSL");
  ////    kafkaProps.put("security.protocol", "SSL");
  ////    kafkaProps.put(SslConfigs.SSL_TRUSTSTORE_LOCATION_CONFIG, "/Users/narendra_bidari/Documents/Office/KafkaSecurity3/kafka.client.truststore.jks");
  ////    kafkaProps.put(SslConfigs.SSL_TRUSTSTORE_PASSWORD_CONFIG,"test1234");
  ////    kafkaProps.put(SslConfigs.SSL_KEYSTORE_LOCATION_CONFIG,"/Users/narendra_bidari/Documents/Office/KafkaSecurity3/kafka.server.keystore.jks");
  ////    kafkaProps.put(SslConfigs.SSL_KEYSTORE_PASSWORD_CONFIG, "test1234");
  ////    kafkaProps.put(SslConfigs.SSL_KEY_PASSWORD_CONFIG, "test1234");
  //
  //  }




}
