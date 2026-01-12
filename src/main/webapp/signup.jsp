<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UiTM Student Counseling | Sign Up</title>
    <style>
        :root {
            --dark-green-bg: #384238;
            --light-green-card: #c4f0cb;
            --input-white: #ffffff;
            --blue-btn: #4bb3f7;
            --dark-text: #000000;
            --link-blue: #4bb3f7;
        }

        body { margin: 0; font-family: Arial, sans-serif; }
        .background { height: 100vh; width: 100%; background-color: var(--dark-green-bg); display: flex; justify-content: center; align-items: center; }

        .signup-card { 
            max-width: 380px; width: 90%; padding: 30px 40px; 
            background-color: var(--light-green-card); border-radius: 20px; 
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3); text-align: center; 
            box-sizing: border-box; 
        }

        .title { color: var(--dark-text); font-size: 1.5em; font-weight: 900; margin-bottom: 25px; margin-top: 10px; }

        form { display: flex; flex-direction: column; align-items: flex-start; width: 100%; }
        label { color: var(--dark-text); font-size: 1em; font-weight: bold; margin-bottom: 5px; margin-top: 10px; }
        
        /* Simple Wrapper for positioning */
        .password-wrapper {
            position: relative;
            width: 100%;
        }

        input { 
            width: 100%; padding: 12px 15px; margin-bottom: 10px; border: none; 
            border-radius: 30px; background-color: var(--input-white); 
            box-sizing: border-box; font-size: 1em; 
        }

        /* The small eye inside the input */
        .eye-icon {
            position: absolute;
            right: 15px;
            top: 12px;
            cursor: pointer;
            font-size: 1.1em;
            color: #555;
            user-select: none;
        }

        .sign-up-btn { 
            width: 100%; padding: 14px; margin-top: 15px; margin-bottom: 10px; 
            background-color: var(--blue-btn); color: var(--input-white); 
            border: none; border-radius: 30px; font-size: 1.1em; font-weight: bold; 
            cursor: pointer; transition: background-color 0.3s; 
        }
        .sign-up-btn:hover { background-color: #3aa2e6; }

        .signin-link { width: 100%; text-align: center; margin-top: 5px; font-size: 0.9em; color: #666; }
        .signin-link a { color: var(--link-blue); text-decoration: underline; font-weight: bold; font-style: italic; }
    </style>
</head>
<body>
    <div class="background">
        <div class="signup-card">
            
            <h2 class="title">SIGN UP YOUR ACCOUNT</h2>

            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                    <p style="color: red; font-weight: bold; margin-bottom: 10px;"><%= error %></p>
            <%
                }
            %>
            
            <form action="AuthServlet?action=register" method="post" id="registrationForm">
                
                <label for="studentName">Student Name:</label>
                <input type="text" id="studentName" name="studentName" required>
                
                <label for="studentID">Student ID :</label>
                <input type="text" id="studentID" name="studentID" required>
                
                <label for="studentEmail">Student Email :</label>
                <input type="email" id="studentEmail" name="studentEmail" required>
                
                <input type="hidden" name="studentPhone" value="">
                
                <label for="password">Password :</label>
                <div class="password-wrapper">
                    <input type="password" 
                           id="password" 
                           name="password" 
                           required 
                           minlength="8" 
                           maxlength="30"
                           pattern="(?=.*[A-Z])(?=.*\d).{8,30}"
                           title="Must contain at least one uppercase letter, one number, and be 8-30 characters long.">
                </div>

                <input type="hidden" name="action" value="register">
                
                <button type="submit" class="sign-up-btn">SIGN UP</button>
                
                <div class="signin-link">
                    Have an account ? 
                    <a href="login.jsp">Sign in</a>
                </div>

            </form>
        </div>
    </div>

    <script>
        function toggleVisibility() {
            var x = document.getElementById("password");
            if (x.type === "password") {
                x.type = "text";
            } else {
                x.type = "password";
            }
        }

        document.getElementById('registrationForm').onsubmit = function(e) {
            const password = document.getElementById('password').value;
            const regex = /^(?=.*[A-Z])(?=.*\d).{8,30}$/;

            if (!regex.test(password)) {
                e.preventDefault();
                alert("Security Error: Password must be 8-30 characters long and include at least one uppercase letter and one number.");
            }
        };
    </script>
</body>
</html>