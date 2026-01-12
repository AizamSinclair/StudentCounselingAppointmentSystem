package com.uitm.studentcounselling.model;

public class Student {
    
    private String studentId;
    private String studName;
    private String studPhone;
    private String studEmail;
    private String passwordHash;
    private String studAddr; // NEW COLUMN ADDED

    public Student() {}

    // --- Getters and Setters ---
    
    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }

    public String getStudName() { return studName; }
    public void setStudName(String studName) { this.studName = studName; }

    public String getStudPhone() { return studPhone; }
    public void setStudPhone(String studPhone) { this.studPhone = studPhone; }
    
    public String getStudAddr() { return studAddr; } // NEW GETTER
    public void setStudAddr(String studAddr) { this.studAddr = studAddr; } // NEW SETTER

    public String getStudEmail() { return studEmail; }
    public void setStudEmail(String studEmail) { this.studEmail = studEmail; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
}