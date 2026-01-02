<%@ page import="java.sql.*" %>
<%@ page import="com.bakery.util.DBConnection" %>
<%
    // Get database connection
    Connection conn = DBConnection.getConnection();

    // Redirect if already logged in
    if(session.getAttribute("user_id") != null){
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Sign Up - Bakery</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Georgia', serif;
            margin: 0;
            padding: 0;
            background: #ffe6f0; /* baby pink */
            color: #b8860b; /* gold */
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .signup-container {
            background: #ffffff; 
            padding: 40px 35px;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            width: 360px;
        }
        h2 {
            text-align: center;
            color: #b8860b;
            margin-bottom: 25px;
        }
        input[type=text], input[type=email], input[type=password] {
            width: 100%;
            padding: 12px;
            margin: 10px 0 20px 0;
            border-radius: 8px;
            border: 1px solid #ddd;
            font-size: 1em;
        }
        input[type=submit] {
            width: 100%;
            background: #b8860b;
            color: white;
            padding: 12px;
            border-radius: 8px;
            border: none;
            font-size: 1.1em;
            cursor: pointer;
            transition: background 0.3s ease;
        }
        input[type=submit]:hover {
            background: #a17405;
        }
        .error { color: red; text-align: center; }
        .success { color: green; text-align: center; }
    </style>
    <script>
        function validateForm(){
            var name=document.forms["signupForm"]["name"].value.trim();
            var email=document.forms["signupForm"]["email"].value.trim();
            var pass=document.forms["signupForm"]["password"].value.trim();
            if(name=="" || email=="" || pass==""){ 
                alert("Please fill all fields"); 
                return false; 
            }
            return true;
        }
    </script>
</head>
<body>
<div class="signup-container">
    <h2>Sign Up</h2>
    <form name="signupForm" method="post" onsubmit="return validateForm()">
        Name: <input type="text" name="name" required><br>
        Email: <input type="email" name="email" required><br>
        Password: <input type="password" name="password" required><br>
        <input type="submit" value="Sign Up">
    </form>
<%
if(request.getMethod().equalsIgnoreCase("POST") && conn != null){
    String name=request.getParameter("name");
    String email=request.getParameter("email");
    String password=request.getParameter("password");
    try {
        String check="SELECT * FROM users WHERE email=?";
        PreparedStatement ps1=conn.prepareStatement(check);
        ps1.setString(1,email);
        ResultSet rs1=ps1.executeQuery();
        if(rs1.next()){
            out.println("<p class='error'>Email already registered!</p>");
        } else {
            String sql="INSERT INTO users(name,email,password) VALUES(?,?,?)";
            PreparedStatement ps=conn.prepareStatement(sql);
            ps.setString(1,name); ps.setString(2,email); ps.setString(3,password);
            ps.executeUpdate();
            out.println("<p class='success'>Signup successful! Redirecting to login...</p>");
%>
<script>
    setTimeout(function(){
        window.location.href='login.jsp';
    }, 1500);
</script>
<%
        }
        rs1.close(); ps1.close();
    } catch(Exception e){ out.println("<p class='error'>Error: "+e.getMessage()+"</p>"); }
} else if(conn == null){
    out.println("<p class='error'>Database connection not available!</p>");
}
%>
</div>
</body>
</html>