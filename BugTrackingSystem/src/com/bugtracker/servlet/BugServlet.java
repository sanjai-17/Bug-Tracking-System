package com.bugtracker.servlet;

import com.bugtracker.dao.BugDAO;
import com.bugtracker.dao.UserDAO;
import com.bugtracker.model.BugReport;
import com.bugtracker.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.List;

/**
 * Servlet for handling bug report operations
 */
@WebServlet("/bug/*")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class BugServlet extends HttpServlet {
    
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
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            listBugs(request, response);
        } else if (pathInfo.equals("/create")) {
            showCreateForm(request, response);
        } else if (pathInfo.equals("/view")) {
            viewBug(request, response);
        } else if (pathInfo.equals("/edit")) {
            showEditForm(request, response);
        } else if (pathInfo.equals("/assign")) {
            showAssignForm(request, response);
        } else if (pathInfo.equals("/search")) {
            searchBugs(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/bug");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null) {
            response.sendRedirect(request.getContextPath() + "/bug");
            return;
        }
        
        switch (pathInfo) {
            case "/create":
                createBug(request, response);
                break;
            case "/update":
                updateBug(request, response);
                break;
            case "/assign":
                assignBug(request, response);
                break;
            case "/updateStatus":
                updateBugStatus(request, response);
                break;
            case "/delete":
                deleteBug(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/bug");
        }
    }
    
    /**
     * List all bugs
     */
    private void listBugs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = (User) session.getAttribute("user");
        List<BugReport> bugs;
        
        String statusFilter = request.getParameter("status");
        
        if (statusFilter != null && !statusFilter.isEmpty()) {
            bugs = bugDAO.getBugsByStatus(statusFilter);
        } else if (user.getRole().equals("Developer")) {
            bugs = bugDAO.getBugsByDeveloper(user.getUserId());
        } else if (user.getRole().equals("Customer")) {
            bugs = bugDAO.getBugsByReporter(user.getUserId());
        } else {
            bugs = bugDAO.getAllBugs();
        }
        
        request.setAttribute("bugs", bugs);
        request.getRequestDispatcher("/WEB-INF/views/bug-list.jsp").forward(request, response);
    }
    
    /**
     * Show create bug form
     */
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/bug-create.jsp").forward(request, response);
    }
    
    /**
     * Create new bug
     */
    private void createBug(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String severity = request.getParameter("severity");
        String priority = request.getParameter("priority");
        String module = request.getParameter("module");
        String stepsToReproduce = request.getParameter("stepsToReproduce");
        String expectedResult = request.getParameter("expectedResult");
        String actualResult = request.getParameter("actualResult");
        String browserInfo = request.getParameter("browserInfo");
        String osInfo = request.getParameter("osInfo");
        
        // Handle file upload
        String screenshotPath = null;
        Part filePart = request.getPart("screenshot");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = getFileName(filePart);
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdir();
            }
            screenshotPath = "uploads" + File.separator + System.currentTimeMillis() + "_" + fileName;
            filePart.write(uploadPath + File.separator + System.currentTimeMillis() + "_" + fileName);
        }
        
        BugReport bug = new BugReport(title, description, severity, priority, module, user.getUserId());
        bug.setStepsToReproduce(stepsToReproduce);
        bug.setExpectedResult(expectedResult);
        bug.setActualResult(actualResult);
        bug.setBrowserInfo(browserInfo);
        bug.setOsInfo(osInfo);
        bug.setScreenshotPath(screenshotPath);
        
        int bugId = bugDAO.createBugReport(bug);
        
        if (bugId > 0) {
            request.getSession().setAttribute("success", "Bug reported successfully! Bug ID: #" + bugId);
            response.sendRedirect(request.getContextPath() + "/bug/view?id=" + bugId);
        } else {
            request.setAttribute("error", "Failed to create bug report");
            request.getRequestDispatcher("/WEB-INF/views/bug-create.jsp").forward(request, response);
        }
    }
    
    /**
     * View bug details
     */
    private void viewBug(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String bugIdParam = request.getParameter("id");
        if (bugIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/bug");
            return;
        }
        
        try {
            int bugId = Integer.parseInt(bugIdParam);
            BugReport bug = bugDAO.getBugById(bugId);
            
            if (bug != null) {
                request.setAttribute("bug", bug);
                request.getRequestDispatcher("/WEB-INF/views/bug-detail.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Bug not found");
                response.sendRedirect(request.getContextPath() + "/bug");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/bug");
        }
    }
    
    /**
     * Show edit bug form
     */
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String bugIdParam = request.getParameter("id");
        if (bugIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/bug");
            return;
        }
        
        try {
            int bugId = Integer.parseInt(bugIdParam);
            BugReport bug = bugDAO.getBugById(bugId);
            
            if (bug != null) {
                request.setAttribute("bug", bug);
                request.getRequestDispatcher("/WEB-INF/views/bug-edit.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/bug");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/bug");
        }
    }
    
    /**
     * Update bug
     */
    private void updateBug(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int bugId = Integer.parseInt(request.getParameter("bugId"));
            BugReport bug = bugDAO.getBugById(bugId);
            
            if (bug != null) {
                bug.setTitle(request.getParameter("title"));
                bug.setDescription(request.getParameter("description"));
                bug.setSeverity(request.getParameter("severity"));
                bug.setPriority(request.getParameter("priority"));
                bug.setModule(request.getParameter("module"));
                bug.setStepsToReproduce(request.getParameter("stepsToReproduce"));
                bug.setExpectedResult(request.getParameter("expectedResult"));
                bug.setActualResult(request.getParameter("actualResult"));
                
                String estimatedHoursParam = request.getParameter("estimatedHours");
                if (estimatedHoursParam != null && !estimatedHoursParam.isEmpty()) {
                    bug.setEstimatedHours(Double.parseDouble(estimatedHoursParam));
                }
                
                if (bugDAO.updateBug(bug)) {
                    request.getSession().setAttribute("success", "Bug updated successfully");
                    response.sendRedirect(request.getContextPath() + "/bug/view?id=" + bugId);
                } else {
                    request.setAttribute("error", "Failed to update bug");
                    request.setAttribute("bug", bug);
                    request.getRequestDispatcher("/WEB-INF/views/bug-edit.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/bug");
        }
    }
    
    /**
     * Show assign bug form
     */
    private void showAssignForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String bugIdParam = request.getParameter("id");
        if (bugIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/bug");
            return;
        }
        
        try {
            int bugId = Integer.parseInt(bugIdParam);
            BugReport bug = bugDAO.getBugById(bugId);
            List<User> developers = userDAO.getAllDevelopers();
            
            if (bug != null) {
                request.setAttribute("bug", bug);
                request.setAttribute("developers", developers);
                request.getRequestDispatcher("/WEB-INF/views/bug-assign.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/bug");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/bug");
        }
    }
    
    /**
     * Assign bug to developer
     */
    private void assignBug(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        try {
            int bugId = Integer.parseInt(request.getParameter("bugId"));
            int developerId = Integer.parseInt(request.getParameter("developerId"));
            
            if (bugDAO.assignBug(bugId, developerId, user.getUserId())) {
                session.setAttribute("success", "Bug assigned successfully");
            } else {
                session.setAttribute("error", "Failed to assign bug");
            }
            
            response.sendRedirect(request.getContextPath() + "/bug/view?id=" + bugId);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/bug");
        }
    }
    
    /**
     * Update bug status
     */
    private void updateBugStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        try {
            int bugId = Integer.parseInt(request.getParameter("bugId"));
            String newStatus = request.getParameter("status");
            String comment = request.getParameter("comment");
            
            if (bugDAO.updateBugStatus(bugId, newStatus, user.getUserId(), comment)) {
                session.setAttribute("success", "Bug status updated successfully");
            } else {
                session.setAttribute("error", "Failed to update bug status");
            }
            
            response.sendRedirect(request.getContextPath() + "/bug/view?id=" + bugId);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/bug");
        }
    }
    
    /**
     * Delete bug
     */
    private void deleteBug(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            int bugId = Integer.parseInt(request.getParameter("bugId"));
            
            if (bugDAO.deleteBug(bugId)) {
                request.getSession().setAttribute("success", "Bug deleted successfully");
            } else {
                request.getSession().setAttribute("error", "Failed to delete bug");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/bug");
    }
    
    /**
     * Search bugs
     */
    private void searchBugs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String keyword = request.getParameter("keyword");
        List<BugReport> bugs = bugDAO.searchBugs(keyword);
        
        request.setAttribute("bugs", bugs);
        request.setAttribute("searchKeyword", keyword);
        request.getRequestDispatcher("/WEB-INF/views/bug-list.jsp").forward(request, response);
    }
    
    /**
     * Extract filename from file part
     */
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return "";
    }
}