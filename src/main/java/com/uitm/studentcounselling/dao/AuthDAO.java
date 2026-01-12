package com.uitm.studentcounselling.dao;

import com.uitm.studentcounselling.util.DBConnection; 
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class AuthDAO {

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        return DBConnection.getConnection();
    }

    /**
     * Authenticates users across Admin, Counselor, and Student tables.
     */
    public Map<String, Object> authenticate(String email, String password) throws SQLException {
        String adminSql = "SELECT ADMIN_ID, ADMIN_NAME, 1 AS ROLE FROM admin_user WHERE ADMIN_EMAIL = ? AND PASSWORD_HASH = ?";
        String counselorSql = "SELECT COUNSELORID, COUNS_NAME, 2 AS ROLE FROM counselor WHERE COUNS_EMAIL = ? AND COUNS_PASS = ?";
        String studentSql = "SELECT STUDENTID, STUD_NAME, STUD_PHONE, 3 AS ROLE FROM student WHERE STUD_EMAIL = ? AND PASSWORD_HASH = ?";

        try (Connection conn = getConnection()) {
            Map<String, Object> admin = executeLogin(conn, adminSql, email, password, "ADMIN_ID", "ADMIN_NAME", null);
            if (admin != null) return admin;

            Map<String, Object> counselor = executeLogin(conn, counselorSql, email, password, "COUNSELORID", "COUNS_NAME", null);
            if (counselor != null) return counselor;

            Map<String, Object> student = executeLogin(conn, studentSql, email, password, "STUDENTID", "STUD_NAME", "STUD_PHONE");
            if (student != null) return student;
            
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new SQLException("Database Driver not found.");
        }
        return null;
    }

    private Map<String, Object> executeLogin(Connection conn, String sql, String email, String pass, String idCol, String nameCol, String phoneCol) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, pass);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> user = new HashMap<>();
                    user.put("userId", rs.getString(idCol));
                    user.put("userName", rs.getString(nameCol));
                    user.put("userRole", rs.getInt("ROLE"));
                    user.put("userPhone", (phoneCol != null) ? rs.getString(phoneCol) : "N/A");
                    return user;
                }
            }
        }
        return null;
    }

    /**
     * Registers a new student.
     * Fixed to include ROLE_ID (3 for Students) as seen in your DB structure.
     */
    public boolean registerStudent(String id, String name, String email, String phone, String pass) throws SQLException {
        // We include ROLE_ID because your table structure shows it as a key
        String sql = "INSERT INTO student (STUDENTID, STUD_NAME, STUD_EMAIL, STUD_PHONE, PASSWORD_HASH, STUD_ADDR, ROLE_ID) VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, id);
            ps.setString(2, name);
            ps.setString(3, email);
            ps.setString(4, (phone == null || phone.isEmpty()) ? null : phone);
            ps.setString(5, pass);
            ps.setString(6, ""); // Address
            ps.setInt(7, 3);    // Default ROLE_ID for students is 3
            
            return ps.executeUpdate() > 0;
            
        } catch (ClassNotFoundException e) {
            System.err.println("Driver Error: " + e.getMessage());
            return false;
        } catch (SQLException e) {
            // Check NetBeans Output window for this specific message
            System.err.println("MYSQL ERROR: " + e.getMessage());
            throw e; 
        }
    }
}