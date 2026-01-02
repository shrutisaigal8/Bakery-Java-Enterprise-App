<%@ page import="java.sql.*" %>
<%@ page import="com.bakery.util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Integer userId = (Integer) session.getAttribute("user_id");

    // Redirect if not logged in
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Get parameters
    String productParam = request.getParameter("product_id");
    String qtyParam = request.getParameter("quantity");

    // Validate parameters presence
    if (productParam == null || qtyParam == null || productParam.trim().isEmpty() || qtyParam.trim().isEmpty()) {
        response.sendRedirect("products.jsp");
        return;
    }

    int productId = 0;
    int quantity = 0;

    try {
        productId = Integer.parseInt(productParam);
        quantity = Integer.parseInt(qtyParam);
        if (quantity <= 0) {
            throw new NumberFormatException("Quantity must be positive");
        }
    } catch (NumberFormatException e) {
        out.println("<p style='color:red;'>Invalid input: " + e.getMessage() + "</p>");
        return;
    }

    Connection conn = null;
    PreparedStatement checkPs = null;
    PreparedStatement updatePs = null;
    PreparedStatement insertPs = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();

        // Check if the product is already in the cart for this user
        String checkSql = "SELECT id, quantity FROM cart WHERE user_id = ? AND product_id = ?";
        checkPs = conn.prepareStatement(checkSql);
        checkPs.setInt(1, userId);
        checkPs.setInt(2, productId);
        rs = checkPs.executeQuery();

        if (rs.next()) {
            // Product exists, update quantity
            int cartId = rs.getInt("id");
            int existingQty = rs.getInt("quantity");

            String updateSql = "UPDATE cart SET quantity = ? WHERE id = ?";
            updatePs = conn.prepareStatement(updateSql);
            updatePs.setInt(1, existingQty + quantity);
            updatePs.setInt(2, cartId);
            updatePs.executeUpdate();
        } else {
            // Product does not exist, insert new row
            String insertSql = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
            insertPs = conn.prepareStatement(insertSql);
            insertPs.setInt(1, userId);
            insertPs.setInt(2, productId);
            insertPs.setInt(3, quantity);
            insertPs.executeUpdate();
        }

        // Redirect to cart page after successful update
        response.sendRedirect("checkout.jsp");

    } catch (Exception e) {
        out.println("<p style='color:red;'>Error adding to cart: " + e.getMessage() + "</p>");
        out.flush();
    } finally {
        // Close resources safely
        try { if (rs != null) rs.close(); } catch (Exception ignored) {}
        try { if (checkPs != null) checkPs.close(); } catch (Exception ignored) {}
        try { if (updatePs != null) updatePs.close(); } catch (Exception ignored) {}
        try { if (insertPs != null) insertPs.close(); } catch (Exception ignored) {}
        try { if (conn != null) conn.close(); } catch (Exception ignored) {}
    }
%>
