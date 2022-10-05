package com.javainuse.employeejdbc.service;

import java.util.List;

import com.javainuse.employeejdbc.model.Employee;

public interface EmployeeService {
	List<Employee> getAllEmployees();
	void insertEmployee(Employee employee);
}
