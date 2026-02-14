CREATE DATABASE IF NOT EXISTS clinica_san_nicola
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE clinica_san_nicola;


CREATE TABLE patients (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    fiscal_code CHAR(16) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;


CREATE TABLE doctors (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    specialty VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;


CREATE TABLE appointments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,

    patient_id BIGINT NOT NULL,
    doctor_id BIGINT NOT NULL,

    start_time DATETIME NOT NULL,
    reason VARCHAR(500),

    status ENUM('BOOKED', 'COMPLETED', 'CANCELED') DEFAULT 'BOOKED',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_appointment_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_appointment_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(id)
        ON DELETE CASCADE,

    CONSTRAINT uq_doctor_time UNIQUE (doctor_id, start_time)
) ENGINE=InnoDB;


CREATE TABLE reports (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,

    appointment_id BIGINT NOT NULL UNIQUE,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    outcome VARCHAR(255),

    CONSTRAINT fk_report_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES appointments(id)
        ON DELETE CASCADE
) ENGINE=InnoDB;


CREATE INDEX idx_appointments_patient ON appointments(patient_id);
CREATE INDEX idx_appointments_doctor ON appointments(doctor_id);
CREATE INDEX idx_appointments_time ON appointments(start_time);

-- Pazienti
INSERT INTO patients (first_name, last_name, fiscal_code, email) VALUES
('Mario', 'Rossi', 'RSSMRA80A01H501U', 'mario.rossi@email.it'),
('Giulia', 'Verdi', 'VRDGLI90B22F205Z', 'giulia.verdi@email.it');

-- Medici
INSERT INTO doctors (first_name, last_name, specialty) VALUES
('Laura', 'Bianchi', 'Cardiologia'),
('Paolo', 'Neri', 'Ortopedia');

-- Prenotazioni
INSERT INTO appointments (patient_id, doctor_id, start_time, reason) VALUES
(1, 1, '2026-03-10 09:00:00', 'Controllo cardiologico'),
(2, 2, '2026-03-11 10:30:00', 'Dolore al ginocchio');

-- Referti
INSERT INTO reports (appointment_id, notes, outcome) VALUES
(1, 'Pressione nella norma. ECG regolare.', 'Visita regolare');


SELECT * FROM reports;

