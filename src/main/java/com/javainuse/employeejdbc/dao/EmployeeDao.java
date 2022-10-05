package com.javainuse.employeejdbc.dao;

import java.util.List;

import com.javainuse.employeejdbc.model.Employee;

public interface EmployeeDao {
	List<Employee> getAllEmployees();
	void insertEmployee(Employee employee);
}

