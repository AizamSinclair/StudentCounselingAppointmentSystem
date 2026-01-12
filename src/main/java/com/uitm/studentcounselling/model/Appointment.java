package com.uitm.studentcounselling.model;

public class Appointment {

    private int bookingId;
    private String studentId;
    private String counselorId;
    private String bookedDate;
    private String timeSlot;
    private String reason;
    private String status;
    private String studentName;
    private String counselorName;
    private String studentPhone;
    private String remark; 
    private String note;

    public Appointment() {}

    // =========================================================================
    // --- GETTERS AND SETTERS ---
    // =========================================================================

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }
    
    public String getStudentId() { return studentId; }
    public void setStudentId(String studentId) { this.studentId = studentId; }
    
    public String getCounselorId() { return counselorId; }
    public void setCounselorId(String counselorId) { this.counselorId = counselorId; }
    
    public String getBookedDate() { return bookedDate; }
    public void setBookedDate(String bookedDate) { this.bookedDate = bookedDate; }
    
    public String getTimeSlot() { return timeSlot; }
    public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }
    
    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }
    
    public String getCounselorName() { return counselorName; }
    public void setCounselorName(String counselorName) { this.counselorName = counselorName; }
    
    public String getStudentPhone() { return studentPhone; }
    public void setStudentPhone(String studentPhone) { this.studentPhone = studentPhone; }
    
    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
}