<%@page import="java.sql.*"%>
<%@page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    String userId = (String) session.getAttribute("userID");
    Map<String, Object> jsonResponse = new HashMap<>();
    ObjectMapper objectMapper = new ObjectMapper();
    
    if (userId != null) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql:///MyProject", "root", "");
            
            String sql = "SELECT m.id, m.sender_id, m.message, m.timestamp, m.is_read, u.name " +
                         "FROM messages m " +
                         "JOIN userRegistration u ON m.sender_id = u.userID " +
                         "WHERE m.receiver_id = ? AND m.is_read = false " +
                         "ORDER BY m.timestamp DESC LIMIT 1";
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, userId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                jsonResponse.put("hasUnreadMessages", true);
                jsonResponse.put("messageId", rs.getInt("id"));
                jsonResponse.put("senderId", rs.getString("sender_id"));
                jsonResponse.put("senderName", rs.getString("name") != null ? rs.getString("name") : "Unknown");
                jsonResponse.put("messageText", rs.getString("message") != null ? rs.getString("message") : "");
                jsonResponse.put("timestamp", rs.getString("timestamp"));
            } else {
                jsonResponse.put("hasUnreadMessages", false);
                jsonResponse.put("messageId", null);
                jsonResponse.put("senderId", null);
                jsonResponse.put("senderName", null);
                jsonResponse.put("messageText", null);
            }
            
        } catch (Exception e) {
            jsonResponse.put("error", true);
            jsonResponse.put("errorMessage", e.getMessage());
            jsonResponse.put("hasUnreadMessages", false);
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (ps != null) try { ps.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    } else {
        jsonResponse.put("hasUnreadMessages", false);
        jsonResponse.put("error", true);
        jsonResponse.put("errorMessage", "User not logged in");
    }
    
    out.print(objectMapper.writeValueAsString(jsonResponse));
%>