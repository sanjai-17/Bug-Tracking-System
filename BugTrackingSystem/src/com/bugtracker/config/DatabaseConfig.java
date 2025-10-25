package com.bugtracker.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Database Configuration and Connection Manager
 * Handles all database connections for the Bug Tracking System
 */
public class DatabaseConfig {
    
    // Database Configuration Parameters
    private static final String DB_URL = "jdbc:mysql://localhost:3306/bug_tracking_system";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "Sanjai@17"; // Update with your MySQL password
    private static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    
    // Singleton instance
    private static DatabaseConfig instance;
    private Connection connection;
    
    // Private constructor for singleton pattern
    private DatabaseConfig() {
        try {
            // Load MySQL JDBC Driver
            Class.forName(DB_DRIVER);
            System.out.println("MySQL JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found");
            e.printStackTrace();
        }
    }
    
    /**
     * Get singleton instance of DatabaseConfig
     */
    public static DatabaseConfig getInstance() {
        if (instance == null) {
            synchronized (DatabaseConfig.class) {
                if (instance == null) {
                    instance = new DatabaseConfig();
                }
            }
        }
        return instance;
    }
    
    /**
     * Get database connection
     * Creates new connection if not exists or closed
     */
    public Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            System.out.println("Database connection established");
        }
        return connection;
    }
    
    /**
     * Get new connection (for concurrent operations)
     */
    public Connection getNewConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
    
    /**
     * Close database connection
     */
    public void closeConnection() {
        if (connection != null) {
            try {
                if (!connection.isClosed()) {
                    connection.close();
                    System.out.println("Database connection closed");
                }
            } catch (SQLException e) {
                System.err.println("Error closing database connection");
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Test database connection
     */
    public boolean testConnection() {
        try {
            Connection testConn = getConnection();
            return testConn != null && !testConn.isClosed();
        } catch (SQLException e) {
            System.err.println("Database connection test failed");
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get database configuration info (for debugging)
     */
    public String getConnectionInfo() {
        return "Database URL: " + DB_URL + "\nDatabase User: " + DB_USER;
    }
}