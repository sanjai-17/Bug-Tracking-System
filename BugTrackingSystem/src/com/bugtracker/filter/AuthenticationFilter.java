package com.bugtracker.filter;

import com.bugtracker.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Authentication Filter to protect secured pages
 */
@WebFilter(filterName = "AuthenticationFilter")
public class AuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Get session
        HttpSession session = httpRequest.getSession(false);
        
        // Check if user is logged in
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);
        
        // Allow access to login and register pages
        boolean isLoginRequest = uri.endsWith("login") || uri.endsWith("register");
        boolean isPublicResource = uri.contains("/css/") || uri.contains("/js/") || 
                                   uri.contains("/images/") || uri.contains("/uploads/");
        
        if (isLoggedIn || isLoginRequest || isPublicResource) {
            // User is logged in or accessing public resource
            if (isLoggedIn) {
                User user = (User) session.getAttribute("user");
                String userRole = user.getRole();
                
                // Role-based access control
                if (uri.contains("/admin/") && !"Admin".equals(userRole)) {
                    httpResponse.sendRedirect(contextPath + "/");
                    return;
                } else if (uri.contains("/developer/") && !"Developer".equals(userRole)) {
                    httpResponse.sendRedirect(contextPath + "/");
                    return;
                } else if (uri.contains("/customer/") && !"Customer".equals(userRole)) {
                    httpResponse.sendRedirect(contextPath + "/");
                    return;
                }
            }
            chain.doFilter(request, response);
        } else {
            // User is not logged in, redirect to login page
            httpResponse.sendRedirect(contextPath + "/login");
        }
    }

    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}