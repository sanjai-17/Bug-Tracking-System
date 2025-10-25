<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bugtracker.model.*, java.text.SimpleDateFormat" %>
<%
    User currentUser = (User) session.getAttribute("user");
    BugReport bug = (BugReport) request.getAttribute("bug");
    if (currentUser == null || bug == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bug #<%= bug.getBugId() %> - <%= bug.getTitle() %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .bug-detail-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            padding: 30px;
            margin: 30px auto;
            max-width: 1200px;
        }
        .bug-header {
            border-bottom: 3px solid #667eea;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }
        .info-label {
            font-weight: 600;
            color: #666;
            margin-bottom: 5px;
        }
        .info-value {
            font-size: 16px;
            margin-bottom: 20px;
        }
        .action-btn {
            margin: 5px;
        }
        .timeline {
            border-left: 3px solid #667eea;
            padding-left: 20px;
            margin-left: 10px;
        }
        .timeline-item {
            margin-bottom: 20px;
            position: relative;
        }
        .timeline-item:before {
            content: '';
            position: absolute;
            left: -26px;
            top: 0;
            width: 15px;
            height: 15px;
            border-radius: 50%;
            background: #667eea;
            border: 3px solid white;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-bug"></i> Bug Tracker
            </a>
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Update Bug Status</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="${pageContext.request.contextPath}/bug/updateStatus" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="bugId" value="<%= bug.getBugId() %>">
                        
                        <div class="mb-3">
                            <label for="status" class="form-label">New Status</label>
                            <select class="form-select" id="status" name="status" required>
                                <option value="">Select Status</option>
                                <option value="Assigned" <%= "Assigned".equals(bug.getStatus()) ? "selected" : "" %>>Assigned</option>
                                <option value="In Progress" <%= "In Progress".equals(bug.getStatus()) ? "selected" : "" %>>In Progress</option>
                                <option value="Resolved" <%= "Resolved".equals(bug.getStatus()) ? "selected" : "" %>>Resolved</option>
                                <option value="Closed" <%= "Closed".equals(bug.getStatus()) ? "selected" : "" %>>Closed</option>
                                <option value="Reopened" <%= "Reopened".equals(bug.getStatus()) ? "selected" : "" %>>Reopened</option>
                            </select>
                        </div>
                        
                        <div class="mb-3">
                            <label for="comment" class="form-label">Comment</label>
                            <textarea class="form-control" id="comment" name="comment" rows="3" 
                                      placeholder="Add a comment about this status change"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Status</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Form -->
    <form id="deleteForm" action="${pageContext.request.contextPath}/bug/delete" method="post" style="display: none;">
        <input type="hidden" name="bugId" value="<%= bug.getBugId() %>">
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete() {
            if (confirm('Are you sure you want to delete this bug? This action cannot be undone.')) {
                document.getElementById('deleteForm').submit();
            }
        }
    </script>
</body>
</html>="navbar-nav ms-auto">
                <span class="navbar-text text-white me-3">
                    <i class="fas fa-user"></i> <%= currentUser.getFullName() %>
                </span>
                <a class="btn btn-outline-light btn-sm" href="${pageContext.request.contextPath}/<%= currentUser.getRole().toLowerCase() %>/dashboard">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="bug-detail-container">
            <% if (session.getAttribute("success") != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <%= session.getAttribute("success") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <% session.removeAttribute("success"); %>
            <% } %>

            <div class="bug-header">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <h2><i class="fas fa-bug"></i> Bug #<%= bug.getBugId() %>: <%= bug.getTitle() %></h2>
                        <p class="text-muted mb-0">
                            Reported by <%= bug.getReportedByName() %> on <%= sdf.format(bug.getReportedDate()) %>
                        </p>
                    </div>
                    <div>
                        <span class="badge <%= bug.getStatusClass() %> fs-6"><%= bug.getStatus() %></span>
                    </div>
                </div>
            </div>

            <div class="row">
                <!-- Left Column -->
                <div class="col-md-8">
                    <div class="card mb-3">
                        <div class="card-header bg-light">
                            <h5 class="mb-0"><i class="fas fa-info-circle"></i> Description</h5>
                        </div>
                        <div class="card-body">
                            <p><%= bug.getDescription() %></p>
                        </div>
                    </div>

                    <div class="card mb-3">
                        <div class="card-header bg-light">
                            <h5 class="mb-0"><i class="fas fa-list-ol"></i> Steps to Reproduce</h5>
                        </div>
                        <div class="card-body">
                            <pre style="white-space: pre-wrap;"><%= bug.getStepsToReproduce() != null ? bug.getStepsToReproduce() : "Not provided" %></pre>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="card mb-3">
                                <div class="card-header bg-light">
                                    <h6 class="mb-0"><i class="fas fa-check"></i> Expected Result</h6>
                                </div>
                                <div class="card-body">
                                    <p><%= bug.getExpectedResult() != null ? bug.getExpectedResult() : "Not provided" %></p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card mb-3">
                                <div class="card-header bg-light">
                                    <h6 class="mb-0"><i class="fas fa-times"></i> Actual Result</h6>
                                </div>
                                <div class="card-body">
                                    <p><%= bug.getActualResult() != null ? bug.getActualResult() : "Not provided" %></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <% if (bug.getScreenshotPath() != null) { %>
                    <div class="card mb-3">
                        <div class="card-header bg-light">
                            <h5 class="mb-0"><i class="fas fa-image"></i> Screenshot</h5>
                        </div>
                        <div class="card-body">
                            <img src="${pageContext.request.contextPath}/<%= bug.getScreenshotPath() %>" 
                                 class="img-fluid" alt="Bug Screenshot">
                        </div>
                    </div>
                    <% } %>
                </div>

                <!-- Right Column -->
                <div class="col-md-4">
                    <div class="card mb-3">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0"><i class="fas fa-info"></i> Details</h5>
                        </div>
                        <div class="card-body">
                            <div class="info-label">Severity</div>
                            <div class="info-value">
                                <span class="badge <%= bug.getSeverityClass() %> fs-6"><%= bug.getSeverity() %></span>
                            </div>

                            <div class="info-label">Priority</div>
                            <div class="info-value">
                                <span class="badge bg-secondary fs-6"><%= bug.getPriority() %></span>
                            </div>

                            <div class="info-label">Module</div>
                            <div class="info-value"><%= bug.getModule() %></div>

                            <div class="info-label">Assigned To</div>
                            <div class="info-value">
                                <%= bug.getAssignedToName() != null ? bug.getAssignedToName() : "<span class='text-muted'>Unassigned</span>" %>
                            </div>

                            <div class="info-label">Browser</div>
                            <div class="info-value"><%= bug.getBrowserInfo() != null ? bug.getBrowserInfo() : "Not specified" %></div>

                            <div class="info-label">Operating System</div>
                            <div class="info-value"><%= bug.getOsInfo() != null ? bug.getOsInfo() : "Not specified" %></div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="card">
                        <div class="card-header bg-success text-white">
                            <h5 class="mb-0"><i class="fas fa-bolt"></i> Actions</h5>
                        </div>
                        <div class="card-body">
                            <% if ("Admin".equals(currentUser.getRole())) { %>
                                <a href="${pageContext.request.contextPath}/bug/edit?id=<%= bug.getBugId() %>" 
                                   class="btn btn-warning w-100 action-btn">
                                    <i class="fas fa-edit"></i> Edit Bug
                                </a>
                                <a href="${pageContext.request.contextPath}/bug/assign?id=<%= bug.getBugId() %>" 
                                   class="btn btn-primary w-100 action-btn">
                                    <i class="fas fa-user-plus"></i> Assign Developer
                                </a>
                            <% } %>

                            <% if ("Developer".equals(currentUser.getRole()) || "Admin".equals(currentUser.getRole())) { %>
                                <button type="button" class="btn btn-info w-100 action-btn text-white" 
                                        data-bs-toggle="modal" data-bs-target="#statusModal">
                                    <i class="fas fa-sync"></i> Update Status
                                </button>
                            <% } %>

                            <a href="${pageContext.request.contextPath}/bug" 
                               class="btn btn-secondary w-100 action-btn">
                                <i class="fas fa-arrow-left"></i> Back to List
                            </a>

                            <% if ("Admin".equals(currentUser.getRole())) { %>
                                <button type="button" class="btn btn-danger w-100 action-btn" 
                                        onclick="confirmDelete()">
                                    <i class="fas fa-trash"></i> Delete Bug
                                </button>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Status Update Modal -->
    <div class="modal fade" id="statusModal" tabindex="-1">
        <div class="modal-dialog">
            <div class