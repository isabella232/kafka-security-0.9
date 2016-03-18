/**
 * Licensed to the Apache Software Foundation (ASF) under one or more contributor license
 * agreements. See the NOTICE file distributed with this work for additional information regarding
 * copyright ownership. The ASF licenses this file to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance with the License. You may obtain a
 * copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License
 * is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
 * or implied. See the License for the specific language governing permissions and limitations under
 * the License.
 */
package com.symantec.cpe.kafka.producer;

import java.util.Properties;
import java.util.UUID;
import java.util.concurrent.ExecutionException;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;

import com.symantec.cpe.Config.Constants;
import com.symantec.cpe.Config.KafkaProducerConfig;

public class KafkaProducerNewJava {

  private String propertyFile;
  private Properties kafkaProps = new Properties();
  private Producer<String, String> producer;
  private String topic;

  public KafkaProducerNewJava(String propertyFile) {
    this.propertyFile = propertyFile;

  }

  public void start() {
    System.out.println("started");
    kafkaProps = KafkaProducerConfig.getProperties(this.propertyFile);
    topic = kafkaProps.getProperty(Constants.TOPIC);
    producer = new KafkaProducer<String, String>(kafkaProps);
  }

  public void produceCount() {
    int count = Integer.parseInt(kafkaProps.getProperty(Constants.COUNT));
    int delay = Integer.parseInt(kafkaProps.getProperty(Constants.DELAY_MS));

    System.out.println("Starting...");
    for (int i = 0; i < count; i++) {
      String messsage = " \"{\"user\":\"user"+i+"\"}\" , \"index"+i+"\", \"type"+i+"\","+ UUID.randomUUID().toString();
      try {
        this.produce(messsage);
        System.out.println("sent" + messsage);
        Thread.sleep(delay);
      } catch (ExecutionException | InterruptedException e) {
        e.printStackTrace();
      }
    }

  }
  public void produce(String value) throws ExecutionException, InterruptedException {
    ProducerRecord<String, String> record = new ProducerRecord<String, String>(topic, value);
    producer.send(record).get();

  }

  public void close() {
    producer.close();
  }

}
