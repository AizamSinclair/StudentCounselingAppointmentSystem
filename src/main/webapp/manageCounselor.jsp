<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Counselor | UiTM Admin</title>
    <style>
        /* Base Reset & Layout */
        body { 
            background-color: #e0e0e0; 
            font-family: Arial, sans-serif; 
            margin: 0; 
            padding: 0; 
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .page-title {
            text-decoration: underline;
            font-weight: bold;
            text-align: center;
            margin: 30px 0;
            font-size: 2.5rem;
        }

        /* Form Section */
        .add-section {
            background-color: #d18297; 
            padding: 20px;
            max-width: 450px;
            margin: 0 auto 40px auto;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .text-center { text-align: center; }
        .mt-3 { margin-top: 15px; }
        .mt-2 { margin-top: 10px; }
        .mt-5 { margin-top: 50px; }

        /* Grid for Counselor Cards */
        .counselor-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
            width: 100%;
        }

        /* Counselor Card Styling */
        .counselor-card {
            background-color: #757575; 
            color: white; 
            padding: 20px; 
            border-radius: 5px;
            font-size: 0.95rem;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
            display: flex;
            flex-direction: column;
        }

        /* Label/Value Rows */
        .info-row {
            display: flex;
            margin-bottom: 8px; 
            align-items: center;
        }

        .info-label { 
            width: 140px; 
            font-weight: bold; 
            color: #000000; 
        }

        .info-colon { 
            width: 20px; 
            font-weight: bold; 
            color: #000000; 
        }

        .info-value { 
            flex: 1; 
            font-weight: bold; 
            color: #ffffff; 
            word-break: break-all;
        }

        /* Form Inputs */
        .input-box {
            width: 100%;
            border-radius: 15px;
            border: 1px solid #ccc;
            padding: 5px 12px;
            box-sizing: border-box;
        }

        /* Buttons */
        .btn-add {
            background-color: #00ccff;
            color: black; 
            font-weight: bold; 
            border: none;
            padding: 10px 25px; 
            border-radius: 8px; 
            font-size: 0.8rem;
            cursor: pointer;
        }
        
        .btn-add:hover { background-color: #0099cc; }

        .btn-edit {
            background-color: #00bfff;
            color: black; 
            border: none; 
            font-weight: bold;
            padding: 8px 20px; 
            border-radius: 5px; 
            text-transform: uppercase; 
            font-size: 0.8rem;
            width: 150px; 
            text-align: center;
            display: inline-block;
        }

        .btn-delete {
            background-color: #ff0000;
            color: white; 
            border: none; 
            font-weight: bold;
            padding: 8px 20px; 
            border-radius: 5px; 
            text-transform: uppercase; 
            font-size: 0.8rem;
            width: 150px; 
            text-align: center;
            display: inline-block;
        }

        .button-container {
            display: flex; 
            flex-direction: column; 
            align-items: center; 
            margin-top: 15px; 
        }

        a { text-decoration: none; }
        
        .no-data {
            text-align: center;
            color: #666;
            width: 100%;
        }
    </style>
</head>
<body>

    <jsp:include page="headerAdmin.jsp" />

    <div class="container">
        <h1 class="page-title">Counselor Details</h1>

        <div class="add-section">
            <form action="AddCounselorServlet" method="POST">
                <div class="info-row">
                    <div class="info-label">Counselor Name</div><div class="info-colon">:</div>
                    <div class="info-value"><input type="text" name="cname" class="input-box" required></div>
                </div>
                <div class="info-row">
                    <div class="info-label">Staff ID</div><div class="info-colon">:</div>
                    <div class="info-value"><input type="text" name="cid" class="input-box" required></div>
                </div>
                <div class="info-row">
                    <div class="info-label">Phone Number</div><div class="info-colon">:</div>
                    <div class="info-value"><input type="text" name="cphone" class="input-box" required></div>
                </div>
                <div class="info-row">
                    <div class="info-label">Email</div><div class="info-colon">:</div>
                    <div class="info-value"><input type="email" name="cemail" class="input-box" required></div>
                </div>
                
                <div class="info-row">
                    <div class="info-label">Password</div><div class="info-colon">:</div>
                    <div class="info-value">
                        <input type="password" 
                               name="cpass" 
                               class="input-box" 
                               required 
                               pattern="^(?=.*[A-Z])(?=.*\d).{8,30}$"
                               title="8-30 characters, 1 uppercase letter, 1 number">
                    </div>
                </div>

                <div class="text-center mt-3">
                    <button type="submit" class="btn-add">ADD COUNSELOR</button>
                </div>
            </form>
        </div>

        <div class="counselor-grid">
            <c:forEach var="c" items="${counselorList}">
                <div class="counselor-card">
                    <div class="info-row">
                        <div class="info-label">Counselor Name</div><div class="info-colon">:</div>
                        <div class="info-value"><c:out value="${c.counsName}"/></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Staff ID</div><div class="info-colon">:</div>
                        <div class="info-value"><c:out value="${c.counselorId}"/></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Phone Number</div><div class="info-colon">:</div>
                        <div class="info-value"><c:out value="${c.counsPhone}"/></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Email</div><div class="info-colon">:</div>
                        <div class="info-value"><c:out value="${c.counsEmail}"/></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Password</div><div class="info-colon">:</div>
                        <div class="info-value"><c:out value="${c.counsPass}"/></div>
                    </div>

                    <div class="button-container">
                        <a href="EditCounselorServlet?id=${c.counselorId}" class="btn-edit">EDIT</a>
                        <a href="deleteCounselor?id=${c.counselorId}" 
                           class="btn-delete mt-2" 
                           onclick="return confirm('Confirm delete for Counselor ID: ${c.counselorId}?')">DELETE</a>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty counselorList}">
                <div class="no-data mt-5">
                    <p>No counselors found in the database.</p>
                </div>
            </c:if>
        </div>
    </div>

    <script type="text/javascript">
        <% Boolean added = (Boolean) session.getAttribute("addSuccess");
           if (added != null && added) { %>
            alert("Add Counselor Successful!");
            <% session.removeAttribute("addSuccess"); %>
        <% } %>

        <% Boolean edited = (Boolean) session.getAttribute("editSuccess");
           if (edited != null && edited) { %>
            alert("Edit Successful!");
            <% session.removeAttribute("editSuccess"); %>
        <% } %>

        <% Boolean deleted = (Boolean) session.getAttribute("deleteSuccess");
           if (deleted != null && deleted) { %>
            alert("Counselor Deleted Successfully!");
            <% session.removeAttribute("deleteSuccess"); %>
        <% } %>
    </script>
</body>
</html>