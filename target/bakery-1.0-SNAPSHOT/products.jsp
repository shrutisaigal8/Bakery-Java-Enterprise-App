<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="com.bakery.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    Connection conn = DBConnection.getConnection();
    Integer userId = (Integer) session.getAttribute("user_id");
    String categoryIdParam = request.getParameter("categoryId");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Products - Sweet Delights Bakery</title>
    <link href="https://fonts.googleapis.com/css2?family=Georgia&display=swap" rel="stylesheet">
    <style>
        body { font-family:'Georgia', serif; margin:0; padding:0; background:#ffe6f0; color:#b8860b; }
        a { text-decoration:none; transition:0.3s; }
        a:hover { color:#ff69b4; }

        header { background:#fff; color:#b8860b; padding:20px 40px; text-align:center; box-shadow:0 4px 10px rgba(0,0,0,0.1); }
        header h1 { margin:0; font-size:2.5em; }

        nav { text-align:right; padding:10px 40px; background:#ffe6f0; }
        nav a { margin-left:15px; font-weight:bold; color:#b8860b; }
        nav a:hover { color:#ff69b4; }

        h2 { text-align:center; margin:40px 0 20px 0; }

        .products-container {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 30px;
            padding: 50px 40px;
        }

        .product-card {
            background: #fff;
            border-radius: 20px;
            overflow: hidden;
            text-align: center;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
            height: 450px;
        }

        .product-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 25px rgba(0,0,0,0.2);
        }

        .product-card img {
            width: 100%;
            height: 260px;
            object-fit: cover;
            border-top-left-radius: 20px;
            border-top-right-radius: 20px;
            transition: transform 0.4s;
        }

        .product-card img:hover {
            transform: scale(1.05);
        }

        .product-card h3 {
            margin: 10px 0 5px 0;
        }

        .product-card p {
            margin: 5px 0 10px 0;
            font-weight: bold;
            font-size: 1.1em;
        }

        .product-card button {
            margin-top: auto;
            margin-bottom: 20px;
            padding: 10px 20px;
            background: #b8860b;
            color: #fff;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
        }

        .product-card button:hover {
            background: #ff69b4;
        }

        @media (max-width: 992px) {
            .products-container {
                grid-template-columns: repeat(2, 1fr);
                padding: 30px 20px;
            }
        }

        @media (max-width: 600px) {
            .products-container {
                grid-template-columns: 1fr;
                padding: 20px 15px;
            }
            nav { text-align:center; }
        }

        footer {
            background:#fff;
            color:#b8860b;
            text-align:center;
            padding:30px 20px;
            margin-top:50px;
            box-shadow:0 -4px 10px rgba(0,0,0,0.05);
        }

        footer p { margin:5px 0; }
        footer a { color:#b8860b; font-weight:bold; }
        footer a:hover { color:#ff69b4; }
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
        Welcome, <%=session.getAttribute("name") %> |
        <a href="checkout.jsp">Cart</a> |
        <a href="contact_queries.jsp">Contact Queries</a> |
        <a href="logout.jsp">Logout</a>
    <%
        } else {
    %>
        <a href="login.jsp">Login</a> | <a href="signup.jsp">Sign Up</a>
    <%
        }
    %>
</nav>

<h2>
<%
    if(categoryIdParam != null){
        try{
            int catId = Integer.parseInt(categoryIdParam);
            PreparedStatement ps = conn.prepareStatement("SELECT name FROM categories WHERE id=?");
            ps.setInt(1, catId);
            ResultSet rsCat = ps.executeQuery();
            if(rsCat.next()){
                out.print(rsCat.getString("name") + " Products");
            } else {
                out.print("Products");
            }
            rsCat.close(); ps.close();
        } catch(Exception e){ out.print("Products"); }
    } else {
        out.print("All Products");
    }
%>
</h2>

<div class="products-container">
<%
    if(conn != null){
        try {
            String query;
            PreparedStatement ps;
            if(categoryIdParam != null){
                query = "SELECT p.id, p.name, p.price, c.name AS category_name FROM products p JOIN categories c ON p.category_id = c.id WHERE p.category_id = ?";
                ps = conn.prepareStatement(query);
                ps.setInt(1, Integer.parseInt(categoryIdParam));
            } else {
                query = "SELECT p.id, p.name, p.price, c.name AS category_name FROM products p JOIN categories c ON p.category_id = c.id";
                ps = conn.prepareStatement(query);
            }

            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                int productId = rs.getInt("id");
                String productName = rs.getString("name");
                double price = rs.getDouble("price");
                String categoryName = rs.getString("category_name");

                String folderName = categoryName.toLowerCase();
                String imageName = productName.toLowerCase().replace(" ", "_") + ".jpg";
%>
    <div class="product-card">
        <img src="<%=request.getContextPath()%>/images/<%=folderName%>/<%=imageName%>" alt="<%=productName%>">
        <h3><%=productName %></h3>
        <p>₹<%=String.format("%.2f", price)%></p>
        <form method="post" action="add_to_cart.jsp">
            <input type="hidden" name="product_id" value="<%=productId%>">
            <button type="submit">Add to Cart</button>
        </form>
    </div>
<%
            }
            rs.close(); ps.close();
        } catch(Exception e){
            out.println("<p style='color:red;'>Error loading products: "+e.getMessage()+"</p>");
        }
    } else {
        out.println("<p style='color:red;'>Database connection not available!</p>");
    }
%>
</div>

<footer>
    <p>Contact us: <a href="mailto:info@sweetdelights.com">info@sweetdelights.com</a> | Phone: +91-9876543210</p>
    <p>Address: 123, Bakery Street, Mumbai, India</p>
    <p>Follow us:
        <a href="#">Instagram</a> |
        <a href="#">Facebook</a> |
        <a href="#">Twitter</a>
    </p>
    <p>&copy; 2025 Sweet Delights Bakery. All rights reserved.</p>
</footer>
</body>
</html>
