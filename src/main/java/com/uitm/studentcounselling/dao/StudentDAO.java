package com.uitm.studentcounselling.dao;

import com.uitm.studentcounselling.model.Student;
import com.uitm.studentcounselling.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {

    // =========================================================================
    // --- I. CONNECTION HELPER ---
    // =========================================================================

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        return DBConnection.getConnection();
    }

    // =========================================================================
    // --- II. DASHBOARD STATS ---
    // =========================================================================

    public int getTotalStudentCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM STUDENT"; // Removed ADMIN1.
        try (Connection conn = getConnection(); 
             Statement st = conn.createStatement(); 
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return count;
    }

    // =========================================================================
    // --- III. CORE STUDENT METHODS ---
    // =========================================================================

    /** Fetches a single student by ID */
    public Student selectStudentById(String studentId) {
        Student student = null;
        String sql = "SELECT * FROM STUDENT WHERE STUDENTID = ?"; // Removed ADMIN1. and TRIM
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    student = mapResultSetToStudent(rs);
                }
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return student;
    }

    /** Specifically for EditProfileServlet */
    public boolean updateStudentProfile(Student s) {
        String sql = "UPDATE STUDENT SET STUD_NAME = ?, STUD_PHONE = ?, STUD_ADDR = ? WHERE STUDENTID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getStudName());
            ps.setString(2, s.getStudPhone());
            ps.setString(3, s.getStudAddr());
            ps.setString(4, s.getStudentId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
            return false; 
        }
    }

    /** Updates the student record including Email and Password */
    public boolean updateStudent(Student s) {
        String sql = "UPDATE STUDENT SET STUD_NAME = ?, STUD_PHONE = ?, STUD_EMAIL = ?, PASSWORD_HASH = ?, STUD_ADDR = ? WHERE STUDENTID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getStudName());
            ps.setString(2, s.getStudPhone());
            ps.setString(3, s.getStudEmail());
            ps.setString(4, s.getPasswordHash());
            ps.setString(5, s.getStudAddr());
            ps.setString(6, s.getStudentId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
            return false; 
        }
    }

    /** Lists all students with optional search */
    public List<Student> selectAllStudents(String searchQuery) {
        List<Student> studentList = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM STUDENT"); // Removed ADMIN1.
        boolean hasSearch = (searchQuery != null && !searchQuery.trim().isEmpty());
        
        if (hasSearch) {
            sql.append(" WHERE LOWER(STUD_NAME) LIKE ? OR STUDENTID LIKE ?");
        }
        sql.append(" ORDER BY STUD_NAME ASC");

        try (Connection conn = getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (hasSearch) {
                String term = "%" + searchQuery.toLowerCase() + "%";
                ps.setString(1, term);
                ps.setString(2, term);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    studentList.add(mapResultSetToStudent(rs));
                }
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return studentList;
    }

    /** Deletes a student */
    public boolean deleteStudent(String studentId) {
        String sql = "DELETE FROM STUDENT WHERE STUDENTID = ?"; // Removed ADMIN1. and TRIM
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, studentId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { 
            e.printStackTrace(); 
            return false; 
        }
    }

    // =========================================================================
    // --- IV. HELPER MAPPING ---
    // =========================================================================

    private Student mapResultSetToStudent(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setStudentId(rs.getString("STUDENTID"));
        s.setStudName(rs.getString("STUD_NAME"));
        s.setStudPhone(rs.getString("STUD_PHONE"));
        s.setStudEmail(rs.getString("STUD_EMAIL"));
        s.setPasswordHash(rs.getString("PASSWORD_HASH"));
        s.setStudAddr(rs.getString("STUD_ADDR"));
        return s;
    }
}