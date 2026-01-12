<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@include file="header.jsp" %>

    <div style="text-align: center; padding: 50px;">
        <h1 style="color: red;">❌ Appointment Booking Failed ❌</h1>
        
        <p style="font-size: 1.2em; color: #555;">
            An error occurred while trying to process your appointment.
        </p>
        
        <%-- Retrieve and display the error message set by the Servlet --%>
        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            if (errorMessage != null) {
        %>
            <div style="border: 2px solid red; background-color: #ffe0e0; padding: 20px; margin-top: 20px; display: inline-block; text-align: left;">
                <h3 style="margin-top: 0; color: #cc0000;">Error Details:</h3>
                <p style="color: #333;"><%= errorMessage %></p>
            </div>
        <%
            } else {
        %>
            <p>No specific error message was provided. Please contact support.</p>
        <%
            }
        %>
        
        <p style="margin-top: 30px;">
            <a href="bookappointment.jsp" style="text-decoration: none; padding: 10px 20px; background-color: #4bb3f7; color: white; border-radius: 5px;">Go Back to Booking Page</a>
        </p>
    </div>

<%@include file="footer.jsp" %>