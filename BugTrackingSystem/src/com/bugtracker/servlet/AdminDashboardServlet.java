package com.bugtracker.servlet;

import com.bugtracker.dao.BugDAO;
import com.bugtracker.dao.UserDAO;
import com.bugtracker.model.BugReport;
import com.bugtracker.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * Admin Dashboard Servlet
 */
@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    
    private BugDAO bugDAO;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        bugDAO = new BugDAO();
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        if (!"Admin".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        // Get statistics
        Map<String, Integer> stats = bugDAO.getBugStatistics();
        request.setAttribute("stats", stats);
        
        // Get recent bugs
        List<BugReport> recentBugs = bugDAO.getAllBugs();
        if (recentBugs.size() > 10) {
            recentBugs = recentBugs.subList(0, 10);
        }
        request.setAttribute("recentBugs", recentBugs);
        
        // Get all developers
        List<User> developers = userDAO.getAllDevelopers();
        request.setAttribute("developers", developers);
        
        // Get unassigned bugs
        List<BugReport> unassignedBugs = bugDAO.getBugsByStatus("New");
        request.setAttribute("unassignedBugs", unassignedBugs);
        
        request.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp").forward(request, response);
    }
}