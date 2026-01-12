<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UiTM Student Counseling | Sign In</title>
    
    <style>
        /* Color Palette */
        :root {
            --dark-green-bg: #384238;
            --light-green-card: #c4f0cb; 
            --input-white: #ffffff;
            --blue-btn: #4bb3f7;
            --dark-text: #000000;
            --uitm-purple: #4b2671;
        }

        body { /* Base body */ margin: 0; font-family: Arial, sans-serif; }
        .background { /* Background container */ height: 100vh; width: 100%; background-color: var(--dark-green-bg); display: flex; justify-content: center; align-items: center; }
        .signin-card { /* Sign In Card */ width: 350px; padding: 30px 40px; background-color: var(--light-green-card); border-radius: 20px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3); text-align: center; }
        .logo-placeholder { text-align: center; margin: 0 auto 15px; padding-top: 0; }
        .uitm-logo { width: 250px; height: auto; display: block; margin: 0 auto; }
        .title { color: var(--dark-text); font-size: 24px; font-weight: 900; margin-bottom: 25px; }
        form { display: flex; flex-direction: column; align-items: flex-start; width: 100%; }
        label { color: var(--dark-text); font-size: 16px; font-weight: bold; margin-bottom: 5px; margin-top: 15px; }
        input[type="text"], input[type="email"], input[type="password"] {
            width: 100%; padding: 10px 15px; margin-bottom: 10px; border: none; border-radius: 30px; background-color: var(--input-white); box-sizing: border-box; font-size: 16px; 
        }
        .log-in-btn { width: 100%; padding: 12px; margin-top: 25px; background-color: var(--blue-btn); color: var(--input-white); border: none; border-radius: 30px; font-size: 18px; font-weight: bold; cursor: pointer; transition: background-color 0.3s; }
        .log-in-btn:hover { background-color: #3aa2e6; }
        .signup-link { margin-top: 15px; font-size: 14px; color: #666; text-align: center; width: 100%; }
        .signup-link a { color: var(--blue-btn); text-decoration: none; font-weight: bold; font-style: italic; text-decoration: underline;}
        
        /* New style for error and success messages */
        .error-message {
            color: red;
            font-weight: bold;
            margin-bottom: 15px;
            text-align: center;
            width: 100%;
        }
        .success-message {
            color: green;
            font-weight: bold;
            margin-bottom: 15px;
            text-align: center;
            width: 100%;
        }
    </style>
</head>
<body>
    <div class="background">
        <div class="signin-card">
            
            <div class="logo-placeholder">
                <img src="images/logo_uitm.png" alt="UiTM Logo" class="uitm-logo">
            </div>

            <h2 class="title">SIGN IN TO YOUR ACCOUNT</h2>
            
            <%-- Display ERROR MESSAGES --%>
            <% 
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <p class="error-message"> <%= error %> </p>
            <% 
                } 
            %>

            <%-- Display REGISTRATION SUCCESS MESSAGE --%>
            <% 
                String registration = request.getParameter("registration");
                if ("success".equals(registration)) {
            %>
                <p class="success-message">
                    Registration successful! Please sign in.
                </p>
            <% 
                } 
            %>

            <%-- THE CRITICALLY CORRECTED FORM ACTION --%>
            <form action="AuthServlet" method="post">
                
                <label for="email">Email :</label>
                <input type="email" id="email" name="email" placeholder="e.g. 0000000000@uitm.edu.my" required>
                
                <label for="password">Password :</label>
                <input type="password" id="password" name="password" placeholder="" required>
                
                <input type="hidden" name="action" value="login">
                
                <button type="submit" class="log-in-btn">LOG IN</button>
            </form>

            <div class="signup-link">
                Don't have an account ? 
                <a href="signup.jsp">Sign Up now</a>
            </div>
        </div>
    </div>
</body>
</html>