package com.uitm.studentcounselling.model;

import java.io.Serializable;

public class Counselor implements Serializable {
    private String counselorId;
    private String counsName;
    private String counsEmail;
    private String counsPhone;
    private String counsPass;
    private int roleId;

    // Default Constructor
    public Counselor() {}

    // Constructor for dropdowns
    public Counselor(String counselorId, String counsName) {
        this.counselorId = counselorId;
        this.counsName = counsName;
    }

    // Getters and Setters
    public String getCounselorId() { return counselorId; }
    public void setCounselorId(String counselorId) { this.counselorId = counselorId; }

    public String getCounsName() { return counsName; }
    public void setCounsName(String counsName) { this.counsName = counsName; }

    public String getCounsEmail() { return counsEmail; }
    public void setCounsEmail(String counsEmail) { this.counsEmail = counsEmail; }

    public String getCounsPhone() { return counsPhone; }
    public void setCounsPhone(String counsPhone) { this.counsPhone = counsPhone; }

    public String getCounsPass() { return counsPass; }
    public void setCounsPass(String counsPass) { this.counsPass = counsPass; }

    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }
}