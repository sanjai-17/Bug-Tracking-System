package com.bugtracker.dao;

import com.bugtracker.config.DatabaseConfig;
import com.bugtracker.model.BugReport;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object for Bug Report operations
 */
public class BugDAO {
    
    private DatabaseConfig dbConfig;
    
    public BugDAO() {
        this.dbConfig = DatabaseConfig.getInstance();
    }
    
    /**
     * Create new bug report
     */
    public int createBugReport(BugReport bug) {
        String sql = "INSERT INTO bug_reports (title, description, severity, priority, module, " +
                     "reported_by, steps_to_reproduce, expected_result, actual_result, " +
                     "browser_info, os_info, screenshot_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = dbConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, bug.getTitle());
            pstmt.setString(2, bug.getDescription());
            pstmt.setString(3, bug.getSeverity());
            pstmt.setString(4, bug.getPriority());
            pstmt.setString(5, bug.getModule());
            pstmt.setInt(6, bug.getReportedBy());
            pstmt.setString(7, bug.getStepsToReproduce());
            pstmt.setString(8, bug.getExpectedResult());
            pstmt.setString(9, bug.getActualResult());
            pstmt.setString(10, bug.getBrowserInfo());
            pstmt.setString(11, bug.getOsInfo());
            pstmt.setString(12, bug.getScreenshotPath());
            
            int rowsAffected = pstmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = pstmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }
    
    /**
     * Get bug by ID with user names
     */
    public BugReport getBugById(int bugId) {
        String sql = "SELECT br.*, u1.full_name as reported_by_name, u2.full_name as assigned_to_name " +
                     "FROM bug_reports br " +
                     "JOIN users u1 ON br.reported_by = u1.user_id " +
                     "LEFT JOIN users u2 ON br.assigned_to = u2.user_id " +
                     "WHERE br.bug_id = ?";
        
        try (Connection conn = dbConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, bugId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractBugFromResultSet(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Get all bugs
     */
    public List<BugReport> getAllBugs() {
        List<BugReport> bugs = new ArrayList<>();
        String sql = "SELECT br.*, u1.full_name as reported_by_name, u2.full_name as assigned_to_name " +
                     "FROM bug_reports br " +
                     "JOIN users u1 ON br.reported_by = u1.user_id " +
                     "LEFT JOIN users u2 ON br.assigned_to = u2.user_id " +
                     "ORDER BY br.reported_date DESC";
        
        try (Connection conn = dbConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                bugs.add(extractBugFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bugs;
    }
    
    /**
     * Get bugs by status
     */
    public List<BugReport> getBugsByStatus(String status) {
        List<BugReport> bugs = new ArrayList<>();
        String sql = "SELECT br.*, u1.full_name as reported_by_name, u2.full_name as assigned_to_name " +
                     "FROM bug_reports br " +
                     "JOIN users u1 ON br.reported_by = u1.user_id " +
                     "LEFT JOIN users u2 ON br.assigned_to = u2.user_id " +
                     "WHERE br.status = ? ORDER BY br.reported_date DESC";
        
        try (Connection conn = dbConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                bugs.add(extractBugFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bugs;
    }
    
    /**
     * Get bugs assigned to developer
     */
    public List<BugReport> getBugsByDeveloper(int developerId) {
        List<BugReport> bugs = new ArrayList<>();
        String sql = "SELECT br.*, u1.full_name as reported_by_name, u2.full_name as assigned_to_name " +
                     "FROM bug_reports br " +
                     "JOIN users u1 ON br.reported_by = u1.user_id " +
                     "LEFT JOIN users u2 ON br.assigned_to = u2.user_id " +
                     "WHERE br.assigned_to = ? ORDER BY br.priority, br.reported_date DESC";
        
        try (Connection conn = dbConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, developerId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                bugs.add(extractBugFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bugs;
    }
    
    /**
     * Get bugs reported by user
     */
    public List<BugReport> getBugsByReporter(int reporterId) {
        List<BugReport> bugs = new ArrayList<>();
        String sql = "SELECT br.*, u1.full_name as reported_by_name, u2.full_name as assigned_to_name " +
                     "FROM bug_reports br " +
                     "JOIN users u1 ON br.reported_by = u1.user_id " +
                     "LEFT JOIN users u2 ON br.assigned_to = u2.user_id " +
                     "WHERE br.reported_by = ? ORDER BY br.reported_date DESC";
        
        try (Connection conn = dbConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, reporterId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                bugs.add(extractBugFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bugs;
    }
    
    /**
     * Assign bug to developer
     */
    public boolean assignBug(int bugId, int developerId, int assignedBy) {
        try (Connection conn = dbConfig.getConnection();
             CallableStatement cstmt = conn.prepareCall("{CALL assign_bug(?, ?, ?)}")) {
            
            cstmt.setInt(1, bugId);
            cstmt.setInt(2, developerId);
            cstmt.setInt(3, assignedBy);
            
            return cstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Update bug status
     */
    public boolean updateBugStatus(int bugId, String newStatus, int updatedBy, String comment) {
        try (Connection conn = dbConfig.getConnection();
             CallableStatement cstmt = conn.prepareCall("{CALL update_bug_status(?, ?, ?, ?)}")) {
            
            cstmt.setInt(1, bugId);
            cstmt.setString(2, newStatus);
            cstmt.setInt(3, updatedBy);
            cstmt.setString(4, comment);
            
            return cstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Update bug details
     */
    public boolean updateBug(BugReport bug) {
        String sql = "UPDATE bug_reports SET title = ?, description = ?, severity = ?, " +
                     "priority = ?, module = ?, steps_to_reproduce = ?, expected_result = ?, " +
                     "actual_result = ?, estimated_hours = ? WHERE bug_id = ?";
        
        try (Connection conn = dbConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, bug.getTitle());
            pstmt.setString(2, bug.getDescription());
            pstmt.setString(3, bug.getSeverity());
            pstmt.setString(4, bug.getPriority());
            pstmt.setString(5, bug.getModule());
            pstmt.setString(6, bug.getStepsToReproduce());
            pstmt.setString(7, bug.getExpectedResult());
            pstmt.setString(8, bug.getActualResult());
            pstmt.setDouble(9, bug.getEstimatedHours() != null ? bug.getEstimatedHours() : 0);
            pstmt.setInt(10, bug.getBugId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Delete bug report
     */
    public boolean deleteBug(int bugId) {
        String sql = "DELETE FROM bug_reports WHERE bug_id = ?";
        
        try (Connection conn = dbConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, bugId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get bug statistics
     */
    public Map<String, Integer> getBugStatistics() {
        Map<String, Integer> stats = new HashMap<>();
        String sql = "SELECT * FROM bug_statistics";
        
        try (Connection conn = dbConfig.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                stats.put("total", rs.getInt("total_bugs"));
                stats.put("new", rs.getInt("new_bugs"));
                stats.put("assigned", rs.getInt("assigned_bugs"));
                stats.put("inProgress", rs.getInt("in_progress_bugs"));
                stats.put("resolved", rs.getInt("resolved_bugs"));
                stats.put("closed", rs.getInt("closed_bugs"));
                stats.put("critical", rs.getInt("critical_bugs"));
                stats.put("high", rs.getInt("high_bugs"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }
    
    /**
     * Search bugs
     */
    public List<BugReport> searchBugs(String keyword) {
        List<BugReport> bugs = new ArrayList<>();
        String sql = "SELECT br.*, u1.full_name as reported_by_name, u2.full_name as assigned_to_name " +
                     "FROM bug_reports br " +
                     "JOIN users u1 ON br.reported_by = u1.user_id " +
                     "LEFT JOIN users u2 ON br.assigned_to = u2.user_id " +
                     "WHERE br.title LIKE ? OR br.description LIKE ? " +
                     "ORDER BY br.reported_date DESC";
        
        try (Connection conn = dbConfig.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                bugs.add(extractBugFromResultSet(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bugs;
    }
    
    /**
     * Extract BugReport from ResultSet
     */
    private BugReport extractBugFromResultSet(ResultSet rs) throws SQLException {
        BugReport bug = new BugReport();
        bug.setBugId(rs.getInt("bug_id"));
        bug.setTitle(rs.getString("title"));
        bug.setDescription(rs.getString("description"));
        bug.setSeverity(rs.getString("severity"));
        bug.setPriority(rs.getString("priority"));
        bug.setStatus(rs.getString("status"));
        bug.setModule(rs.getString("module"));
        bug.setReportedBy(rs.getInt("reported_by"));
        
        int assignedTo = rs.getInt("assigned_to");
        bug.setAssignedTo(rs.wasNull() ? null : assignedTo);
        
        bug.setScreenshotPath(rs.getString("screenshot_path"));
        bug.setStepsToReproduce(rs.getString("steps_to_reproduce"));
        bug.setExpectedResult(rs.getString("expected_result"));
        bug.setActualResult(rs.getString("actual_result"));
        bug.setBrowserInfo(rs.getString("browser_info"));
        bug.setOsInfo(rs.getString("os_info"));
        bug.setReportedDate(rs.getTimestamp("reported_date"));
        bug.setAssignedDate(rs.getTimestamp("assigned_date"));
        bug.setResolvedDate(rs.getTimestamp("resolved_date"));
        bug.setClosedDate(rs.getTimestamp("closed_date"));
        
        Double estimatedHours = rs.getDouble("estimated_hours");
        bug.setEstimatedHours(rs.wasNull() ? null : estimatedHours);
        
        Double actualHours = rs.getDouble("actual_hours");
        bug.setActualHours(rs.wasNull() ? null : actualHours);
        
        bug.setReportedByName(rs.getString("reported_by_name"));
        bug.setAssignedToName(rs.getString("assigned_to_name"));
        
        return bug;
    }
}