<%@ page import="java.sql.*" %>
<%@ page import="com.bakery.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if(userId == null){
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = DBConnection.getConnection();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cart - Sweet Delights Bakery</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body { font-family:'Georgia', serif; background:#ffe6f0; color:#b8860b; margin:0; padding:20px; }
        nav { padding:15px 30px; background:#fff; display:flex; gap:20px; }
        nav a { text-decoration:none; color:#b8860b; font-weight:bold; }
        nav a:hover { color:#ff69b4; }

        .container { max-width:1000px; margin:auto; background:#fff; padding:30px; border-radius:15px; box-shadow:0 8px 20px rgba(0,0,0,0.05); }
        h2 { text-align:center; margin-bottom:20px; }
        table { width:100%; border-collapse:collapse; margin-bottom:20px; }
        th, td { padding:12px; border-bottom:1px solid #ddd; text-align:center; }
        th { background:#f8f8f8; }
        img { width:100px; height:80px; object-fit:cover; border-radius:5px; }
        input[type=number] { width:50px; padding:5px; }
        .remove-btn { padding:5px 10px; background:#e63946; color:#fff; border:none; border-radius:5px; cursor:pointer; }
        .remove-btn:hover { background:#b8860b; }
        .checkout-btn { padding:12px 25px; background:#b8860b; color:#fff; border:none; border-radius:10px; font-weight:bold; cursor:pointer; float:right; }
        .checkout-btn:hover { background:#ff69b4; }
        .total { text-align:right; font-size:1.2em; font-weight:bold; margin-top:15px; }
    </style>
</head>
<body>

<nav>
    <a href="categories.jsp">Categories</a>
    <a href="products.jsp">Products</a>
    <a href="order_history.jsp">Orders</a>
    <a href="logout.jsp">Logout</a>
</nav>

<div class="container">
    <h2>Your Cart</h2>
<%
    if(conn != null){
        try {
            String sql = "SELECT c.id AS cart_id, c.quantity, p.id AS product_id, p.name, p.price, p.image " +
                         "FROM cart c JOIN products p ON c.product_id = p.id WHERE c.user_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            double total = 0;
            boolean hasItems = false;
%>
    <table>
        <tr>
            <th>Product</th>
            <th>Image</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Subtotal</th>
            <th>Action</th>
        </tr>
<%
            while(rs.next()){
                hasItems = true;
                int cartId = rs.getInt("cart_id");
                String name = rs.getString("name");
                String image = rs.getString("image");
                double price = rs.getDouble("price");
                int quantity = rs.getInt("quantity");
                double subtotal = price * quantity;
                total += subtotal;
%>
        <tr>
            <td><%=name%></td>
            <td><img src="<%=image%>" alt="<%=name%>"></td>
            <td>?<%=price%></td>
            <td><%=quantity%></td>
            <td>?<%=String.format("%.2f", subtotal)%></td>
            <td>
                <form method="post" action="remove_from_cart.jsp">
                    <input type="hidden" name="cart_id" value="<%=cartId%>">
                    <button type="submit" class="remove-btn">Remove</button>
                </form>
            </td>
        </tr>
<%
            }
%>
    </table>
<%
            if(hasItems){
%>
    <div class="total">Total: ?<%=String.format("%.2f", total)%></div>
    <form action="checkout.jsp" method="get">
        <button type="submit" class="checkout-btn">Proceed to Checkout</button>
    </form>
<%
            } else {
                out.println("<p>Your cart is empty!</p>");
            }

            rs.close(); ps.close();
        } catch(Exception e){
            out.println("<p style='color:red;'>Error loading cart: "+e.getMessage()+"</p>");
        }
    } else {
        out.println("<p style='color:red;'>Database connection not available!</p>");
    }
%>
</div>

</body>
</html>  