package com.uitm.studentcounselling;

import com.uitm.studentcounselling.dao.AuthDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class AuthServlet extends HttpServlet {
    private final AuthDAO authDAO = new AuthDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("login".equalsIgnoreCase(action)) handleLogin(request, response);
        else if ("register".equalsIgnoreCase(action)) handleRegistration(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action != null && action.equalsIgnoreCase("logout")) {
            // 1. Get the session, but don't create a new one
            HttpSession session = request.getSession(false);
            if (session != null) {
                // 2. Clear all session data
                session.invalidate();
            }
            
            // 3. UPDATED: Always redirect to index.jsp with LogoutSuccess status
            response.sendRedirect("index.jsp?status=LogoutSuccess");
            
        } else {
            // If someone hits this servlet via GET without a logout action
            response.sendRedirect("index.jsp");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Map<String, Object> user = authDAO.authenticate(email, password);
            if (user != null) {
                HttpSession session = request.getSession();
                int role = (int) user.get("userRole");
                String name = (String) user.get("userName");
                String id = (String) user.get("userId");

                session.setAttribute("userId", id);
                session.setAttribute("userName", name);
                session.setAttribute("userRole", role);
                session.setAttribute("userEmail", email);
                session.setAttribute("userPhone", user.get("userPhone"));

                if (role == 1) {
                    session.setAttribute("adminName", name);
                    response.sendRedirect("adminDashboard?status=LoginSuccess");
                } else if (role == 2) {
                    session.setAttribute("counselorId", id);
                    session.setAttribute("counselorName", name);
                    response.sendRedirect("counselorDashboard?status=LoginSuccess");
                } else {
                    response.sendRedirect("index.jsp?status=LoginSuccess");
                }
            } else {
                request.setAttribute("error", "Invalid Credentials.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            log("Database Error", e);
            request.setAttribute("error", "System Error.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    private void handleRegistration(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            authDAO.registerStudent(request.getParameter("studentID"), request.getParameter("studentName"),
                    request.getParameter("studentEmail"), request.getParameter("studentPhone"), request.getParameter("password"));
            response.sendRedirect("login.jsp?registration=success");
        } catch (SQLException e) {
            request.setAttribute("error", "Registration failed.");
            request.getRequestDispatcher("signup.jsp").forward(request, response);
        }
    }
}