<%@ page import="java.sql.*" %>
<%@ page import="com.bakery.util.DBConnection" %>
<%
    Connection conn = DBConnection.getConnection();
    Integer userId = (Integer) session.getAttribute("user_id");
    String userName = (String) session.getAttribute("name");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sweet Delights Bakery</title>
    <link href="https://fonts.googleapis.com/css2?family=Georgia&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Georgia', serif; margin:0; padding:0; background:#ffe6f0; color:#b8860b; }
        a { text-decoration:none; transition:0.3s; }
        a:hover { color:#ff69b4; }

        /* Header */
        header { background:#fff; color:#b8860b; padding:20px 40px; text-align:center; box-shadow:0 4px 10px rgba(0,0,0,0.1); }
        header h1 { margin:0; font-size:2.8em; }

        /* Navigation */
        nav { text-align:right; padding:10px 40px; background:#ffe6f0; }
        nav a { margin-left:15px; font-weight:bold; color:#b8860b; }

        /* Hero Section */
        .hero { position:relative; background:url('https://www.ukiosks.com/wp-content/uploads/2023/11/9-bakery-shop-2.jpg') no-repeat center center/cover; height:450px; display:flex; justify-content:center; align-items:center; flex-direction:column; text-align:center; font-size:2.2em; font-weight:bold; color:#fff; }
        .hero::before { content:""; position:absolute; top:0; left:0; right:0; bottom:0; background:rgba(0,0,0,0.5); z-index:0; }
        .hero * { position:relative; z-index:1; }
        .hero button { margin-top:20px; padding:12px 25px; background:#b8860b; color:#fff; border:none; border-radius:10px; cursor:pointer; font-size:0.6em; font-weight:bold; transition:0.3s; }
        .hero button:hover { background:#ff69b4; }

        /* About Section */
        .about { display:flex; flex-wrap:wrap; justify-content:center; align-items:center; padding:60px 20px; background:#fff; margin:20px; border-radius:20px; box-shadow:0 8px 20px rgba(0,0,0,0.05); }
        .about img { width:500px; max-width:100%; border-radius:15px; margin:20px; }
        .about div { max-width:500px; margin:20px; font-size:1.2em; line-height:1.8; }

        /* Categories Section */
        .categories-container { display:grid; grid-template-columns:repeat(auto-fit,minmax(250px,1fr)); gap:35px; padding:50px 40px; }
        .category { background:#fff; border-radius:20px; overflow:hidden; text-align:center; box-shadow:0 8px 20px rgba(0,0,0,0.1); transition: transform 0.3s, box-shadow 0.3s; cursor:pointer; }
        .category:hover { transform:translateY(-8px); box-shadow:0 15px 25px rgba(0,0,0,0.2); }
        .category img { width:100%; height:250px; object-fit:cover; transition: transform 0.4s; }
        .category img:hover { transform:scale(1.05); }
        .category a { display:block; padding:18px; color:#b8860b; font-weight:700; font-size:1.1em; }
        .category a:hover { color:#ff69b4; letter-spacing:1px; }

        /* Footer */
        footer { background:#fff; color:#b8860b; text-align:center; padding:30px 20px; margin-top:50px; box-shadow:0 -4px 10px rgba(0,0,0,0.05); }
        footer a { color:#b8860b; font-weight:bold; }
        footer a:hover { color:#ff69b4; }

        @media(max-width:768px){ .hero{font-size:1.8em;height:350px;} .categories-container{padding:30px 20px; gap:25px;} .about{flex-direction:column;text-align:center;} }
        @media(max-width:480px){ .hero{font-size:1.5em;height:250px;} .about{padding:30px 15px;font-size:1em;margin:15px;} .categories-container{padding:20px 15px; gap:20px;} nav{text-align:center;} }
    </style>
</head>
<body>

<header>
    <h1>Sweet Delights Bakery</h1>
</header>

<nav>
<%
    if(userId != null){
%>
    Welcome, <%= userName %> | 
    <a href="checkout.jsp">Cart</a> | 
    <a href="order_history.jsp">My Orders</a> | 
    <a href="logout.jsp">Logout</a>
     <a href="contact_queries.jsp">Contact Us</a>
<%
    } else {
%>
    <a href="login.jsp">Login</a> | 
    <a href="signup.jsp">Sign Up</a>
<%
    }
%>
</nav>

<div class="hero">
    <button onclick="window.location.href='products.jsp'">Shop Now</button>
</div>

<div class="about">
    <img src="https://antdisplay.com/pub/media/magefan_blog/bakery_shop_3_.png" alt="Our Bakery">
    <div>
        <h2>About Sweet Delights</h2>
        <p>We bake with love and passion, creating cakes, pastries, bread, and cookies with the freshest ingredients.</p>
        <p>Every product is handcrafted to ensure a sweet experience for you and your loved ones.</p>
    </div>
</div>

<h2 style="text-align:center; margin: 60px 0 20px;">Explore Our Categories</h2>
<div class="categories-container">
<%
    if(conn != null){
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT DISTINCT id, name FROM categories")){
            while(rs.next()){
                int catId = rs.getInt("id");
                String catName = rs.getString("name");

                // Map category names to image files
                String imageName = "";
                switch(catName.toLowerCase()){
                    case "cakes": imageName="cakes.jpg"; break;
                    case "bread": imageName="bread.jpg"; break;
                    case "pastries": imageName="pastries.jpg"; break;
                    case "cookies": imageName="cookies.jpg"; break;
                    default: imageName="default.jpg"; // fallback image
                }
%>
    <div class="category">
        <img src="<%=request.getContextPath()%>/images/categories/<%=imageName%>" alt="<%=catName%>">
        <a href="products.jsp?categoryId=<%=catId%>"><%=catName %></a>
    </div>
<%
            }
        } catch(Exception e){
            out.println("<p style='color:red;'>Error loading categories: "+e.getMessage()+"</p>");
        }
    } else {
        out.println("<p style='color:red;'>Database connection not available!</p>");
    }
%>
</div>

<footer>
    <p>Contact us: <a href="mailto:info@sweetdelights.com">info@sweetdelights.com</a> | Phone: +91-9876543210</p>
    <p>Address: 123, Bakery Street, Mumbai, India</p>
    <p>&copy; 2025 Sweet Delights Bakery. All rights reserved.</p>
</footer>

</body>
</html>
