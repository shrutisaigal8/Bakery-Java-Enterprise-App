<%@ page import="java.sql.*" %>
<%@ page import="com.bakery.util.DBConnection" %>
<%
Connection conn = DBConnection.getConnection();
if(session.getAttribute("user_id") != null){
    response.sendRedirect("index.jsp");
}
%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Bakery</title>
    <link href="https://fonts.googleapis.com/css2?family=Georgia:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Georgia', serif;
            margin: 0; padding: 0;
            background: #ffe6f0; /* baby pink */
            color: #b8860b; /* gold text */
            display: flex; justify-content: center; align-items: center; height: 100vh;
        }
        .login-container {
            background: #ffffff; 
            padding: 40px 30px; 
            border-radius: 15px; 
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            width: 350px;
            text-align: center;
        }
        h2 { color: #b8860b; margin-bottom: 20px; }
        input[type=email], input[type=password] {
            width: 100%; padding: 12px; margin: 10px 0 20px 0; border-radius: 8px; border: 1px solid #ddd;
        }
        input[type=submit] {
            width: 100%; background: #b8860b; color: white; border: none; padding: 12px; border-radius: 8px;
            font-size: 16px; cursor: pointer; transition: background 0.3s;
        }
        input[type=submit]:hover { background: #a17405; }
        .error { color: red; margin-bottom: 15px; }
        .success { color: green; margin-bottom: 15px; }
        a { text-decoration: none; color: #b8860b; }
        a:hover { color: #ff69b4; }
    </style>
    <script>
        function validateForm(){
            var email=document.forms["loginForm"]["email"].value;
            var pass=document.forms["loginForm"]["password"].value;
            if(email=="" || pass==""){ alert("Please fill all fields"); return false; }
            return true;
        }
    </script>
</head>
<body>
<div class="login-container">
    <h2>Login</h2>
    <form name="loginForm" method="post" onsubmit="return validateForm()">
        Email: <input type="email" name="email" required><br>
        Password: <input type="password" name="password" required><br>
        <input type="submit" value="Login">
    </form>
<%
if(request.getMethod().equalsIgnoreCase("POST") && conn != null){
    String email=request.getParameter("email");
    String password=request.getParameter("password");
    try {
        String sql="SELECT * FROM users WHERE email=? AND password=?";
        PreparedStatement ps=conn.prepareStatement(sql);
        ps.setString(1,email);
        ps.setString(2,password);
        ResultSet rs=ps.executeQuery();
        if(rs.next()){
            int userId = rs.getInt("id"); // <-- changed from "user_id" to "id"
            session.setAttribute("user_id", userId);
            session.setAttribute("name", rs.getString("name"));
%>
<script>
    window.location.href='index.jsp';
</script>
<%
        } else {
            out.println("<p class='error'>Invalid email or password!</p>");
        }
        rs.close(); ps.close();
    } catch(Exception e){ out.println("<p class='error'>Error: "+e.getMessage()+"</p>"); }
}
%>

<p>Don't have an account? <a href="signup.jsp">Sign Up</a></p>
</div>
</body>
</html>
