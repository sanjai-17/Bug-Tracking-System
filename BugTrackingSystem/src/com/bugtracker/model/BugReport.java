package com.bugtracker.model;

import java.sql.Timestamp;

/**
 * BugReport Model Class
 * Represents a bug report in the system
 */
public class BugReport {
    
    private int bugId;
    private String title;
    private String description;
    private String severity; // Critical, High, Medium, Low
    private String priority; // Urgent, High, Medium, Low
    private String status; // New, Assigned, In Progress, Resolved, Closed, Reopened
    private String module; // Product Search, Cart Management, Payment Gateway, etc.
    private int reportedBy;
    private Integer assignedTo;
    private String screenshotPath;
    private String stepsToReproduce;
    private String expectedResult;
    private String actualResult;
    private String browserInfo;
    private String osInfo;
    private Timestamp reportedDate;
    private Timestamp assignedDate;
    private Timestamp resolvedDate;
    private Timestamp closedDate;
    private Double estimatedHours;
    private Double actualHours;
    
    // Additional fields for display
    private String reportedByName;
    private String assignedToName;
    
    // Constructors
    public BugReport() {
    }
    
    public BugReport(String title, String description, String severity, String priority, 
                     String module, int reportedBy) {
        this.title = title;
        this.description = description;
        this.severity = severity;
        this.priority = priority;
        this.module = module;
        this.reportedBy = reportedBy;
        this.status = "New";
    }
    
    // Getters and Setters
    public int getBugId() {
        return bugId;
    }
    
    public void setBugId(int bugId) {
        this.bugId = bugId;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getSeverity() {
        return severity;
    }
    
    public void setSeverity(String severity) {
        this.severity = severity;
    }
    
    public String getPriority() {
        return priority;
    }
    
    public void setPriority(String priority) {
        this.priority = priority;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getModule() {
        return module;
    }
    
    public void setModule(String module) {
        this.module = module;
    }
    
    public int getReportedBy() {
        return reportedBy;
    }
    
    public void setReportedBy(int reportedBy) {
        this.reportedBy = reportedBy;
    }
    
    public Integer getAssignedTo() {
        return assignedTo;
    }
    
    public void setAssignedTo(Integer assignedTo) {
        this.assignedTo = assignedTo;
    }
    
    public String getScreenshotPath() {
        return screenshotPath;
    }
    
    public void setScreenshotPath(String screenshotPath) {
        this.screenshotPath = screenshotPath;
    }
    
    public String getStepsToReproduce() {
        return stepsToReproduce;
    }
    
    public void setStepsToReproduce(String stepsToReproduce) {
        this.stepsToReproduce = stepsToReproduce;
    }
    
    public String getExpectedResult() {
        return expectedResult;
    }
    
    public void setExpectedResult(String expectedResult) {
        this.expectedResult = expectedResult;
    }
    
    public String getActualResult() {
        return actualResult;
    }
    
    public void setActualResult(String actualResult) {
        this.actualResult = actualResult;
    }
    
    public String getBrowserInfo() {
        return browserInfo;
    }
    
    public void setBrowserInfo(String browserInfo) {
        this.browserInfo = browserInfo;
    }
    
    public String getOsInfo() {
        return osInfo;
    }
    
    public void setOsInfo(String osInfo) {
        this.osInfo = osInfo;
    }
    
    public Timestamp getReportedDate() {
        return reportedDate;
    }
    
    public void setReportedDate(Timestamp reportedDate) {
        this.reportedDate = reportedDate;
    }
    
    public Timestamp getAssignedDate() {
        return assignedDate;
    }
    
    public void setAssignedDate(Timestamp assignedDate) {
        this.assignedDate = assignedDate;
    }
    
    public Timestamp getResolvedDate() {
        return resolvedDate;
    }
    
    public void setResolvedDate(Timestamp resolvedDate) {
        this.resolvedDate = resolvedDate;
    }
    
    public Timestamp getClosedDate() {
        return closedDate;
    }
    
    public void setClosedDate(Timestamp closedDate) {
        this.closedDate = closedDate;
    }
    
    public Double getEstimatedHours() {
        return estimatedHours;
    }
    
    public void setEstimatedHours(Double estimatedHours) {
        this.estimatedHours = estimatedHours;
    }
    
    public Double getActualHours() {
        return actualHours;
    }
    
    public void setActualHours(Double actualHours) {
        this.actualHours = actualHours;
    }
    
    public String getReportedByName() {
        return reportedByName;
    }
    
    public void setReportedByName(String reportedByName) {
        this.reportedByName = reportedByName;
    }
    
    public String getAssignedToName() {
        return assignedToName;
    }
    
    public void setAssignedToName(String assignedToName) {
        this.assignedToName = assignedToName;
    }
    
    /**
     * Get CSS class for severity badge
     */
    public String getSeverityClass() {
        switch (severity) {
            case "Critical": return "badge-danger";
            case "High": return "badge-warning";
            case "Medium": return "badge-info";
            case "Low": return "badge-secondary";
            default: return "badge-light";
        }
    }
    
    /**
     * Get CSS class for status badge
     */
    public String getStatusClass() {
        switch (status) {
            case "New": return "badge-primary";
            case "Assigned": return "badge-info";
            case "In Progress": return "badge-warning";
            case "Resolved": return "badge-success";
            case "Closed": return "badge-dark";
            case "Reopened": return "badge-danger";
            default: return "badge-light";
        }
    }
    
    @Override
    public String toString() {
        return "BugReport{" +
                "bugId=" + bugId +
                ", title='" + title + '\'' +
                ", severity='" + severity + '\'' +
                ", priority='" + priority + '\'' +
                ", status='" + status + '\'' +
                ", module='" + module + '\'' +
                ", reportedDate=" + reportedDate +
                '}';
    }
}