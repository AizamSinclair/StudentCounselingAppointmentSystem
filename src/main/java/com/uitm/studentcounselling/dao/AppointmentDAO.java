package com.uitm.studentcounselling.dao;

import com.uitm.studentcounselling.model.Appointment;
import com.uitm.studentcounselling.util.DBConnection; 
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    // =========================================================================
    // --- I. SQL CONSTANTS ---
    // =========================================================================
    private final String SELECT_APPOINTMENT_BASE_SQL =
        "SELECT a.BOOKINGID, a.STUDENTID, a.COUNSELORID, a.BOOKEDDATE, a.TIMESLOT, a.REASON, a.STATUS, " +
        "a.REMARK, a.NOTE, s.STUD_NAME, a.STUD_PHONE, c.COUNS_NAME AS COUNSELORNAME " +
        "FROM appointment a " + 
        "JOIN student s ON a.STUDENTID = s.STUDENTID " +
        "JOIN counselor c ON a.COUNSELORID = c.COUNSELORID ";

    private final String SELECT_APPOINTMENT_BY_ID_SQL = SELECT_APPOINTMENT_BASE_SQL + "WHERE a.BOOKINGID = ?";
        
    private final String UPDATE_FINAL_STATUS_SQL =
        "UPDATE appointment SET STATUS = ?, REMARK = ?, NOTE = ?, BOOKEDDATE = ?, TIMESLOT = ? " +
        "WHERE BOOKINGID = ?";
        
    private final String INSERT_APPOINTMENT_SQL = 
        "INSERT INTO appointment (STUDENTID, STUDENTNAME, STUD_PHONE, COUNSELORID, BOOKEDDATE, TIMESLOT, REASON, STATUS) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, 'Pending')";

    private final String INSERT_FOLLOWUP_SQL = 
        "INSERT INTO appointment (STUDENTID, STUDENTNAME, STUD_PHONE, COUNSELORID, BOOKEDDATE, TIMESLOT, REASON, STATUS) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, 'Next Follow-Up')";

    private final String SELECT_STUDENT_INFO_BY_BOOKING_SQL = 
        "SELECT a.STUDENTID, a.COUNSELORID, s.STUD_NAME, a.STUD_PHONE, a.REASON, a.REMARK, a.NOTE " +
        "FROM appointment a " +
        "JOIN student s ON a.STUDENTID = s.STUDENTID " +
        "WHERE a.BOOKINGID = ?";
        
    private final String COUNSELOR_RESCHEDULE_SQL =
        "UPDATE appointment SET BOOKEDDATE = ?, TIMESLOT = ?, COUNSELORID = ?, STATUS = ? " +
        "WHERE BOOKINGID = ?";

    private final String UPDATE_TO_FOLLOWUP_SCHEDULED_SQL = 
        "UPDATE appointment SET BOOKEDDATE = ?, TIMESLOT = ?, REMARK = ?, NOTE = ?, STATUS = 'Follow-Up Scheduled' " +
        "WHERE BOOKINGID = ?";

    // =========================================================================
    // --- II. HELPER METHODS ---
    // =========================================================================

    private Connection getConnection() throws SQLException, ClassNotFoundException {
        return DBConnection.getConnection();
    }
    
    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        Appointment appt = new Appointment();
        appt.setBookingId(rs.getInt("BOOKINGID"));
        appt.setStudentId(rs.getString("STUDENTID"));
        appt.setCounselorId(rs.getString("COUNSELORID"));
        
        Date d = rs.getDate("BOOKEDDATE");
        appt.setBookedDate(d != null ? d.toString() : "");
        
        appt.setTimeSlot(rs.getString("TIMESLOT"));
        appt.setReason(rs.getString("REASON"));
        appt.setStatus(rs.getString("STATUS"));
        appt.setRemark(rs.getString("REMARK"));
        appt.setNote(rs.getString("NOTE"));
        appt.setStudentPhone(rs.getString("STUD_PHONE"));
        appt.setStudentName(rs.getString("STUD_NAME"));
        
        try { 
            appt.setCounselorName(rs.getString("COUNSELORNAME"));
        } catch (SQLException e) {
            // Fallback if the alias is missing
            appt.setCounselorName(rs.getString("COUNS_NAME"));
        }
        return appt;
    }

    // =========================================================================
    // --- III. ANALYTICS & DASHBOARD ---
    // =========================================================================

    public int getAppointmentCountByStatus(String status, String counselorId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM appointment WHERE COUNSELORID = ? AND UPPER(STATUS) = UPPER(?)";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, counselorId.trim());
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) count = rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }
    
    public int getFollowUpCount(String counselorId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM appointment WHERE COUNSELORID = ? AND STATUS IN ('Next Follow-Up', 'Accepted', 'Declined')";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, counselorId.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) count = rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    public int getHistoricalAppointmentCount(String counselorId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM appointment WHERE COUNSELORID = ? AND UPPER(STATUS) IN ('DONE SESSION', 'NO SHOW', 'CANCELLED')";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, counselorId.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) count = rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    public int[] getMonthlyAppointmentCounts(int year) {
        int[] monthlyCounts = new int[12];
        String sql = "SELECT MONTH(BOOKEDDATE) as m, COUNT(*) as total FROM appointment " +
                     "WHERE YEAR(BOOKEDDATE) = ? AND STATUS IN ('Done Session', 'No Show', 'Cancelled') GROUP BY MONTH(BOOKEDDATE)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int monthIndex = rs.getInt("m") - 1;
                    if (monthIndex >= 0 && monthIndex < 12) monthlyCounts[monthIndex] = rs.getInt("total");
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return monthlyCounts;
    }

    public int getYearlyFinalizedCount(int year) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM appointment WHERE STATUS IN ('Done Session', 'No Show', 'Cancelled') AND YEAR(BOOKEDDATE) = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) count = rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    public int getAllTimeFinalizedCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM appointment WHERE STATUS IN ('Done Session', 'No Show', 'Cancelled')";
        try (Connection conn = getConnection(); Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) count = rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return count;
    }

    // =========================================================================
    // --- IV. SLOT & AVAILABILITY ---
    // =========================================================================

    public boolean isSlotAvailable(String counselorId, String date, String time) {
        String sql = "SELECT COUNT(*) FROM appointment WHERE COUNSELORID = ? AND BOOKEDDATE = ? AND TIMESLOT = ? AND UPPER(STATUS) NOT IN ('CANCELLED', 'DECLINED')";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, counselorId.trim());
            ps.setDate(2, java.sql.Date.valueOf(date)); 
            ps.setString(3, time);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) == 0;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean isSlotTaken(String date, String time, String counselorId, int currentBookingId) {
        boolean taken = false;
        String sql = "SELECT COUNT(*) FROM appointment WHERE BOOKEDDATE = ? AND TIMESLOT = ? AND COUNSELORID = ? AND STATUS NOT IN ('Cancelled', 'Declined', 'Done Session', 'No Show') AND BOOKINGID != ?"; 
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(date));
            ps.setString(2, time);
            ps.setString(3, counselorId.trim());
            ps.setInt(4, currentBookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) taken = rs.getInt(1) > 0;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return taken;
    }

    // =========================================================================
    // --- V. RETRIEVAL & LISTING ---
    // =========================================================================

    public Appointment selectAppointmentById(int bookingId) {
        Appointment appointment = null;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(SELECT_APPOINTMENT_BY_ID_SQL)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) appointment = mapResultSetToAppointment(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return appointment;
    }

    public List<Appointment> selectStudentAllAppointments(String studentId) {
        List<Appointment> list = new ArrayList<>();
        String sql = SELECT_APPOINTMENT_BASE_SQL + "WHERE a.STUDENTID = ? ORDER BY a.BOOKEDDATE DESC, a.TIMESLOT ASC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, studentId.trim());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToAppointment(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Appointment> getAppointmentsByStatusAndCounselor(String status, String counselorId) {
        List<Appointment> list = new ArrayList<>();
        String sql = SELECT_APPOINTMENT_BASE_SQL + "WHERE a.COUNSELORID = ? AND UPPER(a.STATUS) = UPPER(?) ORDER BY a.BOOKEDDATE ASC, a.TIMESLOT ASC";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, counselorId.trim());
            ps.setString(2, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToAppointment(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Appointment> getAppointmentsForCounselorByStatusAndSearch(String statusFilter, String counselorId, String searchTerm) {
        List<Appointment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(SELECT_APPOINTMENT_BASE_SQL);
        sql.append("WHERE a.COUNSELORID = ? ");
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("AND UPPER(a.STATUS) = UPPER(?) ");
        } else {
            sql.append("AND UPPER(a.STATUS) IN ('DONE SESSION', 'NO SHOW', 'CANCELLED') ");
        }
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("AND (LOWER(s.STUD_NAME) LIKE ? OR a.STUDENTID LIKE ?) ");
        }
        sql.append("ORDER BY a.BOOKEDDATE DESC, a.TIMESLOT ASC");
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setString(idx++, counselorId.trim());
            if (statusFilter != null && !statusFilter.isEmpty()) ps.setString(idx++, statusFilter);
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String pattern = "%" + searchTerm.toLowerCase() + "%";
                ps.setString(idx++, pattern);
                ps.setString(idx++, pattern);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToAppointment(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Appointment> getFollowUpSpecificRecords(String counselorId, String searchTerm) {
        List<Appointment> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(SELECT_APPOINTMENT_BASE_SQL);
        sql.append("WHERE a.COUNSELORID = ? AND UPPER(a.STATUS) IN ('NEXT FOLLOW-UP', 'ACCEPTED', 'DECLINED') ");
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("AND (LOWER(s.STUD_NAME) LIKE ? OR a.STUDENTID LIKE ?) ");
        }
        sql.append("ORDER BY a.BOOKEDDATE DESC");
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            ps.setString(1, counselorId.trim());
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String p = "%" + searchTerm.toLowerCase() + "%";
                ps.setString(2, p);
                ps.setString(3, p);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapResultSetToAppointment(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // =========================================================================
    // --- VI. ACTION & UPDATE METHODS ---
    // =========================================================================

    public boolean confirmAppointment(int bookingId) {
        String sql = "UPDATE appointment SET STATUS = 'Confirmed' WHERE BOOKINGID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
    
    public boolean cancelAppointment(int bookingId) {
        String sql = "UPDATE appointment SET STATUS = 'Cancelled' WHERE BOOKINGID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
    
    public boolean finalizeSessionDetails(int bookingId, String finalStatus, String remark, String note, String nextDate, String nextTime) {
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(UPDATE_FINAL_STATUS_SQL)) {
            ps.setString(1, finalStatus);
            ps.setString(2, remark);
            ps.setString(3, note);
            ps.setDate(4, java.sql.Date.valueOf(nextDate));
            ps.setString(5, nextTime);
            ps.setInt(6, bookingId);    
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
    
    public boolean finalizeWithFollowUp(int bookingId, String nextDate, String nextTime, String remark, String note) {
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(UPDATE_TO_FOLLOWUP_SCHEDULED_SQL)) {
            ps.setDate(1, java.sql.Date.valueOf(nextDate));
            ps.setString(2, nextTime);
            ps.setString(3, remark);
            ps.setString(4, note);
            ps.setInt(5, bookingId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean updateAppointmentStatus(int bookingId, String newStatus) {
        String sql = "UPDATE appointment SET STATUS = ? WHERE BOOKINGID = ?";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean createFollowUpAppointment(String studentId, String studentName, String counselorId, String bookedDate, String timeSlot, String reason, String studentPhone) {
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(INSERT_FOLLOWUP_SQL)) {
            ps.setString(1, studentId.trim());
            ps.setString(2, studentName);
            ps.setString(3, studentPhone);
            ps.setString(4, counselorId.trim());
            ps.setDate(5, java.sql.Date.valueOf(bookedDate));
            ps.setString(6, timeSlot);
            ps.setString(7, reason);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public Appointment getStudentDetailsForFollowUp(int previousBookingId) {
        Appointment appt = null;
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(SELECT_STUDENT_INFO_BY_BOOKING_SQL)) {
            ps.setInt(1, previousBookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    appt = new Appointment();
                    appt.setStudentId(rs.getString("STUDENTID"));
                    appt.setCounselorId(rs.getString("COUNSELORID"));
                    appt.setStudentName(rs.getString("STUD_NAME"));
                    appt.setStudentPhone(rs.getString("STUD_PHONE"));
                    appt.setReason(rs.getString("REASON"));
                    appt.setRemark(rs.getString("REMARK"));
                    appt.setNote(rs.getString("NOTE"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return appt;
    }
    
    public boolean counselorRescheduleAppointment(int bookingId, String newDate, String newTimeSlot, String newCounselorId, String newStatus) {
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(COUNSELOR_RESCHEDULE_SQL)) {
            ps.setDate(1, java.sql.Date.valueOf(newDate));
            ps.setString(2, newTimeSlot);
            ps.setString(3, newCounselorId.trim());
            ps.setString(4, newStatus);
            ps.setInt(5, bookingId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean deleteAppointment(int bookingId, String studentId) {
        String sql = "DELETE FROM appointment WHERE BOOKINGID = ? AND STUDENTID = ? AND (STATUS = 'Pending' OR STATUS = 'Next Follow-Up')";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setString(2, studentId.trim());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean updateAppointment(Appointment appt) {
        String sql = "UPDATE appointment SET BOOKEDDATE = ?, TIMESLOT = ?, COUNSELORID = ?, REASON = ?, STUD_PHONE = ? WHERE BOOKINGID = ? AND STUDENTID = ? AND STATUS = 'Pending'";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(appt.getBookedDate()));
            ps.setString(2, appt.getTimeSlot());
            ps.setString(3, appt.getCounselorId().trim());
            ps.setString(4, appt.getReason());
            ps.setString(5, appt.getStudentPhone());
            ps.setInt(6, appt.getBookingId());
            ps.setString(7, appt.getStudentId().trim());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
    
    public boolean insertAppointment(Appointment appt) {
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(INSERT_APPOINTMENT_SQL)) {
            ps.setString(1, appt.getStudentId().trim());
            ps.setString(2, appt.getStudentName()); 
            ps.setString(3, appt.getStudentPhone());
            ps.setString(4, appt.getCounselorId().trim());
            ps.setDate(5, java.sql.Date.valueOf(appt.getBookedDate()));
            ps.setString(6, appt.getTimeSlot());
            ps.setString(7, appt.getReason());

            return ps.executeUpdate() > 0;
        } catch (Exception e) { 
            System.err.println("CRITICAL ERROR IN DAO.insertAppointment: " + e.getMessage());
            e.printStackTrace(); 
            return false; 
        }
    }

    public boolean confirmFollowUpAppointment(int bookingId, String studentId) {
        String sql = "UPDATE appointment SET STATUS = 'Accepted' WHERE BOOKINGID = ? AND STUDENTID = ? AND STATUS = 'Next Follow-Up'";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setString(2, studentId.trim());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean cancelFollowUpAppointment(int bookingId, String studentId) {
        String sql = "UPDATE appointment SET STATUS = 'Declined' WHERE BOOKINGID = ? AND STUDENTID = ? AND STATUS = 'Next Follow-Up'";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setString(2, studentId.trim());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}