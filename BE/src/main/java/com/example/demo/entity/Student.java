package com.example.demo.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import com.fasterxml.jackson.annotation.JsonProperty;

@Entity
public class Student {
    @Id
    private int id;
    private String name;
    @JsonProperty("class_name")
    private String className;
    private String status;

    public Student() {}
    public Student(int id, String name, String className, String status) {
        this.id = id;
        this.name = name;
        this.className = className;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}
