-- Database initialization for cybersecurity capstone project
-- Creates tables for storing penetration testing results

CREATE TABLE IF NOT EXISTS assessments (
    id SERIAL PRIMARY KEY,
    target_ip VARCHAR(45),
    target_domain VARCHAR(255),
    assessment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    assessment_type VARCHAR(50),
    status VARCHAR(20) DEFAULT 'running'
);

CREATE TABLE IF NOT EXISTS vulnerabilities (
    id SERIAL PRIMARY KEY,
    assessment_id INTEGER REFERENCES assessments(id),
    vulnerability_type VARCHAR(100),
    severity VARCHAR(20),
    cvss_score DECIMAL(3,1),
    description TEXT,
    location VARCHAR(255),
    remediation TEXT,
    discovered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS scan_results (
    id SERIAL PRIMARY KEY,
    assessment_id INTEGER REFERENCES assessments(id),
    tool_name VARCHAR(100),
    scan_type VARCHAR(100),
    results JSONB,
    scan_duration INTEGER,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_assessments_date ON assessments(assessment_date);
CREATE INDEX IF NOT EXISTS idx_vulnerabilities_severity ON vulnerabilities(severity);
CREATE INDEX IF NOT EXISTS idx_scan_results_tool ON scan_results(tool_name);

-- Insert sample data
INSERT INTO assessments (target_ip, target_domain, assessment_type, status) 
VALUES ('192.168.1.100', 'ecommerce-test.local', 'comprehensive', 'completed')
ON CONFLICT DO NOTHING;
