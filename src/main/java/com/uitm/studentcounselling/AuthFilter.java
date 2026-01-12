package com.uitm.studentcounselling;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false); 
        String path = req.getServletPath();

        // 1. ALLOW PUBLIC ACCESS (Added aboutus and contact for guests)
        boolean isPublicPage = path.equals("/index.jsp") || path.equals("/") || 
                               path.equals("/login.jsp") || path.equals("/signup.jsp") ||
                               path.equals("/aboutus.jsp") || path.equals("/contact.jsp") || // Guest Pages
                               path.equals("/AuthServlet") || path.startsWith("/css/") || 
                               path.startsWith("/js/") || path.startsWith("/images/");

        if (isPublicPage) {
            chain.doFilter(request, response);
            return;
        }

        // 2. CHECK LOGIN
        if (session == null || session.getAttribute("userRole") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?status=PleaseLogin");
            return;
        }

        Integer userRole = (Integer) session.getAttribute("userRole");
        boolean authorized = false;

        // 3. ROLE-BASED AUTHORIZATION
        if (userRole == 1) {
            // Admin Access
            if (path.contains("adminDashboard") || path.contains("Manage") || 
                path.contains("Counselor") || path.contains("Student") || 
                path.contains("Record") || path.equals("/appointmentReport")) {
                authorized = true;
            }
        } 
        else if (userRole == 2) {
            // Counselor Access
            if (path.contains("counselorDashboard") || path.equals("/manageAppointments") || 
                path.contains("/followUpAppointment") || path.equals("/studentRecords") || 
                path.equals("/viewAppointmentDetails") || path.equals("/editProfile")) {
                authorized = true;
            }
        } 
        else if (userRole == 3) {
            // Student Access (Added FollowUpActionServlet for confirm/decline)
            if (path.equals("/bookAppointment") || path.equals("/BookAppointmentServlet") || 
                path.equals("/checkSlot") || path.equals("/CheckSlotServlet") || 
                path.equals("/checkStatus") || path.equals("/bookingSuccess.jsp") || 
                path.equals("/editProfile") || path.equals("/CancelAppointmentServlet") ||
                path.equals("/EditAppointmentServlet") || path.equals("/FollowUpActionServlet")) {
                authorized = true;
            }
        }

        // 4. FINAL DECISION
        if (authorized) {
            chain.doFilter(request, response);
        } else {
            req.setAttribute("error", "Access Denied: You do not have permission for this area.");
            req.getRequestDispatcher("/unauthorized.jsp").forward(request, response);
        }
    }

    @Override public void init(FilterConfig f) {}
    @Override public void destroy() {}
}