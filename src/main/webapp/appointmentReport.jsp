<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Appointment Report | UiTM Admin</title>
    <style>
        body { background-color: #d3d3d3; margin: 0; font-family: Arial, sans-serif; }
        .report-body { padding: 40px; text-align: center; }
        
        .main-title { 
            font-size: 36px; 
            font-weight: bold; 
            text-decoration: underline; 
            margin-bottom: 5px; 
        }
        .year-label { 
            font-size: 28px; 
            font-weight: bold; 
            text-decoration: underline; 
            margin-bottom: 30px; 
        }

        /* === UPDATED: FILTER IN THE MIDDLE === */
        .filter-container { 
            display: flex;
            flex-direction: column;
            align-items: center; /* Centers the content horizontally */
            justify-content: center;
            margin-bottom: 30px; 
            font-weight: bold; 
        }

        select { 
            padding: 8px; 
            width: 180px; 
            border-radius: 5px; 
            margin-top: 10px; 
            cursor: pointer;
            border: 1px solid #7d7d7d;
            font-size: 16px;
            text-align: center;
        }

        /* Grid for boxes */
        .grid-container {
            display: grid;
            grid-template-columns: repeat(4, 200px);
            gap: 20px;
            justify-content: center;
        }
        .report-box {
            background-color: #7d7d7d; 
            padding: 20px;
            border-radius: 2px;
            min-height: 100px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            box-shadow: 2px 2px 8px rgba(0,0,0,0.2);
        }
        .box-text { font-size: 14px; font-weight: bold; line-height: 1.4; margin-bottom: 10px; }
        .box-count { font-size: 24px; font-weight: bold; color: #0000ff; } 
    </style>
</head>
<body>

    <jsp:include page="headerAdmin.jsp" />

    <div class="report-body">
        <div class="main-title">Completed Appointment Made</div>
        <div class="year-label">Year ${year}</div>

        <div class="filter-container">
            <form action="appointmentReport" method="get">
                <label>Year Filters :</label><br>
                <select name="year" onchange="this.form.submit()">
                    <% 
                        int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
                        String selectedYear = (String) request.getAttribute("year");
                        
                        for(int y = currentYear + 2; y >= 2020; y--) {
                            String yearStr = String.valueOf(y);
                    %>
                        <option value="<%= yearStr %>" <%= (yearStr.equals(selectedYear)) ? "selected" : "" %>>
                            <%= yearStr %>
                        </option>
                    <% } %>
                </select>
            </form>
        </div>

        <div class="grid-container">
            <% 
                String[] months = {"January", "February", "March", "April", "May", "June", 
                                  "July", "August", "September", "October", "November", "December"};
                int[] counts = (int[]) request.getAttribute("counts");
                String displayYear = (String) request.getAttribute("year");
                
                for(int i=0; i < 12; i++) { 
            %>
                <div class="report-box">
                    <div class="box-text">
                        Appointment Made In<br>
                        <%= months[i] %> <%= displayYear %>
                    </div>
                    <div class="box-count"><%= (counts != null) ? counts[i] : 0 %></div>
                </div>
            <% } %>
        </div>
    </div>

</body>
</html>