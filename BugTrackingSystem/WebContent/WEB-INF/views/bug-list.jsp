<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.bugtracker.model.*" %>
<%
    User currentUser = (User) session.getAttribute("user");
    List<BugReport> bugs = (List<BugReport>) request.getAttribute("bugs");
    String searchKeyword = (String) request.getAttribute("searchKeyword");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Bugs - Bug Tracking System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; }
        .bug-list-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            padding: 30px;
            margin: 30px auto;
        }
        .filter-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .bug-row:hover {
            background-color: #f8f9fa;
            cursor: pointer;
        }
        .badge-custom {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-bug"></i> Bug Tracker
            </a>
            <div class="navbar-nav ms-auto">
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
        <div class="bug-list-container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-list"></i> All Bugs</h2>
                <a href="${pageContext.request.contextPath}/bug/create" class="btn btn-primary">
                    <i class="fas fa-plus"></i> Report New Bug
                </a>
            </div>

            <!-- Search and Filter Section -->
            <div class="filter-section">
                <div class="row">
                    <div class="col-md-6">
                        <form action="${pageContext.request.contextPath}/bug/search" method="get" class="d-flex">
                            <input type="text" class="form-control me-2" name="keyword" 
                                   placeholder="Search bugs..." value="<%= searchKeyword != null ? searchKeyword : "" %>">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search"></i> Search
                            </button>
                        </form>
                    </div>
                    <div class="col-md-6">
                        <div class="btn-group w-100" role="group">
                            <a href="${pageContext.request.contextPath}/bug" 
                               class="btn btn-outline-secondary">All</a>
                            <a href="${pageContext.request.contextPath}/bug?status=New" 
                               class="btn btn-outline-primary">New</a>
                            <a href="${pageContext.request.contextPath}/bug?status=In Progress" 
                               class="btn btn-outline-warning">In Progress</a>
                            <a href="${pageContext.request.contextPath}/bug?status=Resolved" 
                               class="btn btn-outline-success">Resolved</a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bugs Table -->
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th width="80">Bug ID</th>
                            <th>Title</th>
                            <th width="120">Status</th>
                            <th width="120">Severity</th>
                            <th width="120">Priority</th>
                            <th width="150">Module</th>
                            <th width="150">Assigned To</th>
                            <th width="150">Reported Date</th>
                            <th width="100">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (bugs != null && !bugs.isEmpty()) {
                            for (BugReport bug : bugs) { %>
                        <tr class="bug-row" onclick="window.location='${pageContext.request.contextPath}/bug/view?id=<%= bug.getBugId() %>'">
                            <td><strong>#<%= bug.getBugId() %></strong></td>
                            <td><%= bug.getTitle() %></td>
                            <td>
                                <span class="badge <%= bug.getStatusClass() %> badge-custom">
                                    <%= bug.getStatus() %>
                                </span>
                            </td>
                            <td>
                                <span class="badge <%= bug.getSeverityClass() %> badge-custom">
                                    <%= bug.getSeverity() %>
                                </span>
                            </td>
                            <td>
                                <span class="badge bg-secondary badge-custom">
                                    <%= bug.getPriority() %>
                                </span>
                            </td>
                            <td><small><%= bug.getModule() %></small></td>
                            <td>
                                <small>
                                    <%= bug.getAssignedToName() != null ? bug.getAssignedToName() : "<span class='text-muted'>Unassigned</span>" %>
                                </small>
                            </td>
                            <td>
                                <small><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(bug.getReportedDate()) %></small>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/bug/view?id=<%= bug.getBugId() %>" 
                                   class="btn btn-sm btn-info text-white" onclick="event.stopPropagation();">
                                    <i class="fas fa-eye"></i>
                                </a>
                                <% if ("Admin".equals(currentUser.getRole())) { %>
                                <a href="${pageContext.request.contextPath}/bug/edit?id=<%= bug.getBugId() %>" 
                                   class="btn btn-sm btn-warning" onclick="event.stopPropagation();">
                                    <i class="fas fa-edit"></i>
                                </a>
                                <% } %>
                            </td>
                        </tr>
                        <% } 
                        } else { %>
                        <tr>
                            <td colspan="9" class="text-center text-muted py-5">
                                <i class="fas fa-inbox fa-3x mb-3"></i>
                                <p>No bugs found</p>
                                <a href="${pageContext.request.contextPath}/bug/create" class="btn btn-primary">
                                    <i class="fas fa-plus"></i> Report Your First Bug
                                </a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Summary Footer -->
            <% if (bugs != null && !bugs.isEmpty()) { %>
            <div class="alert alert-info mt-3">
                <i class="fas fa-info-circle"></i> 
                Showing <strong><%= bugs.size() %></strong> bug(s)
                <% if (searchKeyword != null) { %>
                    for search: "<strong><%= searchKeyword %></strong>"
                <% } %>
            </div>
            <% } %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>