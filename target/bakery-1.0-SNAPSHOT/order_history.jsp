<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bakery.util.DBConnection" %>

<%
    Integer userId = (Integer) session.getAttribute("user_id");
    out.println("<p>Debug: userId from session = " + userId + "</p>");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    class OrderItem {
        String name;
        int quantity;
        double price;
        OrderItem(String n, int q, double p) {
            name = n;
            quantity = q;
            price = p;
        }
    }

    class Order {
        int id;
        double total;
        Timestamp date;
        String payment;
        String address;
        List<OrderItem> items = new ArrayList<>();
        Order(int id, double total, Timestamp date, String payment, String address) {
            this.id = id;
            this.total = total;
            this.date = date;
            this.payment = payment;
            this.address = address;
        }
    }

    List<Order> orders = new ArrayList<>();

    try (Connection conn = DBConnection.getConnection()) {
        out.println("<p>Debug: Connected to DB = " + (conn != null) + "</p>");
        String sqlOrders = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        PreparedStatement psOrders = conn.prepareStatement(sqlOrders);
        psOrders.setInt(1, userId);
        ResultSet rsOrders = psOrders.executeQuery();

        while (rsOrders.next()) {
            int orderId = rsOrders.getInt("id");
            // adjust column names below if your DB uses other names
            double total = 0;
            try {
                total = rsOrders.getDouble("total_amount");
            } catch (SQLException e) {
                // fallback if total_amount doesn't exist
                try { total = rsOrders.getDouble("total"); } catch(Exception ex) { total = 0; }
            }
            Timestamp date = rsOrders.getTimestamp("created_at");
            String payment = null;
            try {
                payment = rsOrders.getString("payment_method");
            } catch(Exception ex) { payment = "N/A"; }
            String address = null;
            try {
                address = rsOrders.getString("address");
            } catch(Exception ex) { address = "Not provided"; }

            out.println("<p>Debug: Found order id = " + orderId + ", total = " + total + "</p>");

            Order order = new Order(orderId, total, date, payment, address);

            String sqlItems = "SELECT * FROM order_items WHERE order_id = ?";
            PreparedStatement psItems = conn.prepareStatement(sqlItems);
            psItems.setInt(1, orderId);
            ResultSet rsItems = psItems.executeQuery();

            while (rsItems.next()) {
                String prodName = null;
                try {
                    prodName = rsItems.getString("product_name");
                } catch(Exception ex) {
                    prodName = "Unknown";
                }
                int qty = 0;
                try {
                    qty = rsItems.getInt("quantity");
                } catch(Exception ex) {
                    qty = 0;
                }
                double price = 0;
                try {
                    price = rsItems.getDouble("price");
                } catch(Exception ex) {
                    price = 0;
                }
                out.println("<p>Debug: OrderItem - " + prodName + " qty=" + qty + " price=" + price + "</p>");
                order.items.add(new OrderItem(prodName, qty, price));
            }
            orders.add(order);
        }
    } catch (Exception e) {
        out.println("<p>Error loading order history: " + e.getMessage() + "</p>");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Order History</title>
    <style>
        body { font-family: Arial, sans-serif; background: #fff7f0; padding: 40px; }
        h1 { color: #d2691e; }
        .order { margin-bottom: 40px; padding: 20px; border: 1px solid #ddd; border-radius: 10px; background: #fff2e0; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: center; }
        th { background-color: #f2cba0; }
    </style>
</head>
<body>
    <h1>My Order History</h1>

    <%
        out.println("<p>Debug: orders.size = " + orders.size() + "</p>");
        if (orders.isEmpty()) {
    %>
        <p>You have no orders yet.</p>
    <%
        } else {
            for (Order o : orders) {
    %>
        <div class="order">
            <h2>Order ID: <%= o.id %> | Date: <%= o.date %></h2>
            <p>Total: ₹<%= String.format("%.2f", o.total) %> | Payment: <%= (o.payment != null ? o.payment : "N/A") %></p>
            <p>Shipping Address: <%= (o.address != null ? o.address : "Not provided") %></p>

            <table>
                <tr>
                    <th>Product</th>
                    <th>Quantity</th>
                    <th>Price (unit)</th>
                    <th>Subtotal</th>
                </tr>
                <%
                    for (OrderItem item : o.items) {
                %>
                <tr>
                    <td><%= item.name != null ? item.name : "Unknown Product" %></td>
                    <td><%= item.quantity %></td>
                    <td>₹<%= String.format("%.2f", item.price) %></td>
                    <td>₹<%= String.format("%.2f", item.price * item.quantity) %></td>
                </tr>
                <%
                    }
                %>
            </table>
        </div>
    <%
            }
        }
    %>

</body>
</html>
