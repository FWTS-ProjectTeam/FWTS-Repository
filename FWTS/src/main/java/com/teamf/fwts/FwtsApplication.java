package com.teamf.fwts;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.filter.HiddenHttpMethodFilter;

@SpringBootApplication
@MapperScan("com.teamf.fwts.dao")
public class FwtsApplication {
   public static void main(String[] args) {
      SpringApplication.run(FwtsApplication.class, args);
   }

   @Bean
   HiddenHttpMethodFilter hiddenHttpMethodFilter() {
      return new HiddenHttpMethodFilter();
   }
}