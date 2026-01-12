package com.uitm.studentcounselling.dao;

import com.uitm.studentcounselling.model.Counselor;
import com.uitm.studentcounselling.util.DBConnection; 
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CounselorDAO {

    // =========================================================================
    // --- I. CONNECTION HELPER ---
    // =========================================================================

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        return DBConnection.getConnection();
    }

    // =========================================================================
    // --- II. DASHBOARD STATS ---
    // =========================================================================

    public int getTotalCounselorCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM counselor"; 
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
    // --- III. ADMIN MANAGEMENT FUNCTIONS ---
    // =========================================================================

    public boolean insertCounselor(Counselor c) {
        // Matches your 6 columns: COUNSELORID, COUNS_NAME, COUNS_EMAIL, COUNS_PHONE, COUNS_PASS, ROLE_ID
        String sql = "INSERT INTO counselor (COUNSELORID, COUNS_NAME, COUNS_EMAIL, COUNS_PHONE, COUNS_PASS, ROLE_ID) VALUES (?, ?, ?, ?, ?, 2)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, c.getCounselorId());
            ps.setString(2, c.getCounsName());
            ps.setString(3, c.getCounsEmail());
            ps.setString(4, c.getCounsPhone());
            ps.setString(5, c.getCounsPass());
            
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException | ClassNotFoundException e) {
            // Logs the exact MySQL error to the NetBeans console
            System.err.println("CRITICAL ERROR in insertCounselor: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateCounselor(Counselor c) {
        String sql = "UPDATE counselor SET COUNS_NAME = ?, COUNS_EMAIL = ?, COUNS_PHONE = ?, COUNS_PASS = ? WHERE COUNSELORID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, c.getCounsName());
            ps.setString(2, c.getCounsEmail());
            ps.setString(3, c.getCounsPhone());
            ps.setString(4, c.getCounsPass());
            ps.setString(5, c.getCounselorId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteCounselor(String id) {
        String sql = "DELETE FROM counselor WHERE COUNSELORID = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            return false;
        }
    }

    // =========================================================================
    // --- IV. DATA RETRIEVAL FUNCTIONS ---
    // =========================================================================

    public List<Counselor> selectAllCounselors() {
        List<Counselor> counselors = new ArrayList<>();
        String sql = "SELECT * FROM counselor ORDER BY COUNS_NAME ASC"; 
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                counselors.add(mapResultSetToCounselor(rs));
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return counselors;
    }

    public Counselor selectCounselorById(String id) {
        Counselor c = null;
        String sql = "SELECT * FROM counselor WHERE COUNSELORID = ?"; 
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    c = mapResultSetToCounselor(rs);
                }
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return c;
    }

    // =========================================================================
    // --- V. HELPER MAPPING ---
    // =========================================================================

    private Counselor mapResultSetToCounselor(ResultSet rs) throws SQLException {
        Counselor c = new Counselor();
        c.setCounselorId(rs.getString("COUNSELORID"));
        c.setCounsName(rs.getString("COUNS_NAME"));
        c.setCounsEmail(rs.getString("COUNS_EMAIL"));
        c.setCounsPhone(rs.getString("COUNS_PHONE"));
        c.setCounsPass(rs.getString("COUNS_PASS"));
        // Setting the Role ID from DB to the Model
        c.setRoleId(rs.getInt("ROLE_ID")); 
        return c;
    }
}