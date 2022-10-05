package com.javainuse.employeejdbc;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@RestController
@EnableAutoConfiguration
@SpringBootApplication
public class EmployeeJdbcApplication {

	public static void main(String[] args) {
		SpringApplication.run(EmployeeJdbcApplication.class, args);
	}

}
