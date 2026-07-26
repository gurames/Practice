-- ============================================================
-- БАЗА ДАННЫХ «ТУРИЗМ»
-- ============================================================

-- Удаляем базу данных, если она существует, и создаем заново
DROP DATABASE IF EXISTS tourism_db;
CREATE DATABASE tourism_db;
USE tourism_db;

-- ============================================================
-- 1. ТАБЛИЦА-СПРАВОЧНИК: Клиенты
-- ============================================================
CREATE TABLE clients (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    patronymic VARCHAR(50) NULL,
    passport_number VARCHAR(20) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NULL,
    date_of_birth DATE NOT NULL,
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- ============================================================
-- 2. ТАБЛИЦА-СПРАВОЧНИК: Направления
-- ============================================================
CREATE TABLE destinations (
    destination_id INT PRIMARY KEY AUTO_INCREMENT,
    country VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    hotel_name VARCHAR(200) NOT NULL,
    hotel_stars INT DEFAULT 3 CHECK (hotel_stars BETWEEN 1 AND 5),
    description TEXT,
    is_available BOOLEAN DEFAULT TRUE
);

-- ============================================================
-- 3. ТАБЛИЦА-СПРАВОЧНИК: Услуги
-- ============================================================
CREATE TABLE services (
    service_id INT PRIMARY KEY AUTO_INCREMENT,
    service_name VARCHAR(100) NOT NULL,
    service_type ENUM('трансфер', 'экскурсия', 'страховка', 'питание', 
                      'авиабилеты', 'проживание', 'аренда_авто', 'другое') NOT NULL,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    description TEXT,
    is_available BOOLEAN DEFAULT TRUE
);

-- ============================================================
-- 4. ТАБЛИЦА-СПРАВОЧНИК: Сотрудники
-- ============================================================
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    last_name VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    patronymic VARCHAR(50) NULL,
    position VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10, 2) CHECK (salary >= 0),
    is_active BOOLEAN DEFAULT TRUE
);

-- ============================================================
-- 5. ТАБЛИЦА ПЕРЕМЕННОЙ ИНФОРМАЦИИ: Заказы туров
-- ============================================================
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    
    -- Внешние ключи на таблицы-справочники
    client_id INT NOT NULL,
    destination_id INT NOT NULL,
    employee_id INT NOT NULL,
    service_id INT NOT NULL,
    
    -- Дополнительные атрибуты заказа
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    tour_start_date DATE NOT NULL,
    tour_end_date DATE NOT NULL,
    number_of_travelers INT NOT NULL CHECK (number_of_travelers >= 1),
    total_price DECIMAL(12, 2) NOT NULL CHECK (total_price >= 0),
    discount_percent DECIMAL(5, 2) DEFAULT 0 CHECK (discount_percent BETWEEN 0 AND 100),
    final_price DECIMAL(12, 2) GENERATED ALWAYS AS 
        (total_price * (1 - discount_percent / 100)) STORED,
    status ENUM('новый', 'подтвержден', 'оплачен', 'отменен', 'завершен') 
        DEFAULT 'новый',
    payment_status ENUM('не оплачен', 'частично оплачен', 'полностью оплачен') 
        DEFAULT 'не оплачен',
    comments TEXT,
    
    -- Внешние ключи
    CONSTRAINT fk_orders_client 
        FOREIGN KEY (client_id) REFERENCES clients(client_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_orders_destination 
        FOREIGN KEY (destination_id) REFERENCES destinations(destination_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_orders_employee 
        FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    CONSTRAINT fk_orders_service 
        FOREIGN KEY (service_id) REFERENCES services(service_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    -- Дополнительное ограничение: дата окончания тура должна быть позже даты начала
    CONSTRAINT chk_dates CHECK (tour_end_date > tour_start_date)
);

-- ============================================================
-- СОЗДАНИЕ ИНДЕКСОВ ДЛЯ УЛУЧШЕНИЯ ПРОИЗВОДИТЕЛЬНОСТИ
-- ============================================================
CREATE INDEX idx_orders_client_id ON orders(client_id);
CREATE INDEX idx_orders_destination_id ON orders(destination_id);
CREATE INDEX idx_orders_employee_id ON orders(employee_id);
CREATE INDEX idx_orders_service_id ON orders(service_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_tour_start_date ON orders(tour_start_date);
CREATE INDEX idx_orders_tour_end_date ON orders(tour_end_date);

-- ============================================================
-- 6. ПРИМЕРЫ ТЕСТОВЫХ ДАННЫХ (опционально)
-- ============================================================

-- Заполнение таблицы clients
INSERT INTO clients (last_name, first_name, patronymic, passport_number, phone, email, date_of_birth) VALUES
('Иванов', 'Иван', 'Иванович', '1234 567890', '+7(999)111-22-33', 'ivanov@mail.ru', '1985-05-15'),
('Петрова', 'Елена', 'Сергеевна', '2345 678901', '+7(999)222-33-44', 'petrova@mail.ru', '1990-08-22'),
('Сидоров', 'Алексей', 'Петрович', '3456 789012', '+7(999)333-44-55', 'sidorov@mail.ru', '1978-11-02'),
('Козлова', 'Мария', 'Андреевна', '4567 890123', '+7(999)444-55-66', 'kozlova@mail.ru', '1995-03-10'),
('Смирнов', 'Дмитрий', 'Владимирович', '5678 901234', '+7(999)555-66-77', 'smirnov@mail.ru', '1980-07-19');

-- Заполнение таблицы destinations
INSERT INTO destinations (country, city, hotel_name, hotel_stars, description) VALUES
('Турция', 'Анталия', 'Sun Paradise Resort', 5, 'Пятизвездочный отель на первой береговой линии с собственным пляжем.'),
('Египет', 'Шарм-эль-Шейх', 'Red Sea Palace', 4, 'Отель с видом на Красное море, отличный дайвинг.'),
('Греция', 'Крит', 'Minoan Beach Hotel', 4, 'Отель на побережье с бассейнами и спа-центром.'),
('Италия', 'Рим', 'Roman Empire Hotel', 5, 'Исторический отель в центре Рима.'),
('Таиланд', 'Пхукет', 'Andaman Pearl Resort', 5, 'Роскошный курорт с видом на Андаманское море.');

-- Заполнение таблицы services
INSERT INTO services (service_name, service_type, price, description) VALUES
('Трансфер из аэропорта', 'трансфер', 50.00, 'Встреча в аэропорту и трансфер до отеля.'),
('Обзорная экскурсия по городу', 'экскурсия', 75.00, 'Экскурсия с профессиональным гидом.'),
('Медицинская страховка', 'страховка', 30.00, 'Страховка на весь период пребывания.'),
('Полупансион (завтрак+ужин)', 'питание', 120.00, 'Двухразовое питание в отеле.'),
('Авиабилеты туда-обратно', 'авиабилеты', 450.00, 'Эконом-класс, прямой рейс.'),
('Аренда автомобиля', 'аренда_авто', 85.00, 'Автомобиль эконом-класса на 7 дней.');

-- Заполнение таблицы employees
INSERT INTO employees (last_name, first_name, patronymic, position, phone, email, hire_date, salary) VALUES
('Морозов', 'Андрей', 'Владимирович', 'Менеджер по туризму', '+7(999)777-11-22', 'morozov@tourism.ru', '2020-01-15', 60000.00),
('Соколова', 'Ольга', 'Игоревна', 'Старший менеджер', '+7(999)888-22-33', 'sokolova@tourism.ru', '2019-05-20', 75000.00),
('Волков', 'Максим', 'Сергеевич', 'Консультант', '+7(999)999-33-44', 'volkov@tourism.ru', '2021-03-10', 45000.00),
('Новикова', 'Анна', 'Алексеевна', 'Специалист по бронированию', '+7(999)000-44-55', 'novikova@tourism.ru', '2022-07-01', 50000.00);

-- Заполнение таблицы orders (переменная информация)
INSERT INTO orders (client_id, destination_id, employee_id, service_id, 
                   tour_start_date, tour_end_date, number_of_travelers, 
                   total_price, discount_percent, status, payment_status, comments) VALUES
(1, 1, 1, 4, '2026-08-01', '2026-08-10', 2, 2400.00, 10.00, 'подтвержден', 'частично оплачен', 'Бронирование с видом на море'),
(2, 2, 2, 5, '2026-07-15', '2026-07-22', 1, 900.00, 5.00, 'оплачен', 'полностью оплачен', 'Одиночный тур'),
(3, 3, 1, 3, '2026-09-05', '2026-09-15', 3, 3600.00, 15.00, 'новый', 'не оплачен', 'Семейный тур с детьми'),
(4, 4, 3, 4, '2026-10-01', '2026-10-08', 2, 2800.00, 0.00, 'подтвержден', 'не оплачен', 'Тур в Италию'),
(5, 5, 2, 6, '2026-11-10', '2026-11-20', 2, 3200.00, 20.00, 'новый', 'частично оплачен', 'Аренда авто включена');

-- ============================================================
-- ПРИМЕРЫ ЗАПРОСОВ ДЛЯ ДЕМОНСТРАЦИИ РАБОТЫ БД
-- ============================================================

-- 1. Получить все заказы с информацией о клиентах и направлениях
SELECT 
    o.order_id,
    CONCAT(c.last_name, ' ', c.first_name) AS client_name,
    CONCAT(d.country, ', ', d.city) AS destination,
    o.tour_start_date,
    o.tour_end_date,
    o.total_price,
    o.final_price,
    o.status,
    o.payment_status
FROM orders o
JOIN clients c ON o.client_id = c.client_id
JOIN destinations d ON o.destination_id = d.destination_id
ORDER BY o.order_date DESC;

-- 2. Получить общую сумму продаж по сотрудникам
SELECT 
    e.last_name,
    e.first_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.final_price) AS total_revenue
FROM employees e
LEFT JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id
ORDER BY total_revenue DESC;

-- 3. Получить список активных туров по направлениям
SELECT 
    d.country,
    d.city,
    COUNT(o.order_id) AS tours_count,
    SUM(o.number_of_travelers) AS total_travelers
FROM destinations d
LEFT JOIN orders o ON d.destination_id = o.destination_id
WHERE o.status NOT IN ('отменен', 'завершен')
GROUP BY d.destination_id
ORDER BY tours_count DESC;

-- 4. Получить заказы с указанием дополнительных услуг
SELECT 
    CONCAT(c.last_name, ' ', c.first_name) AS client,
    s.service_name,
    s.service_type,
    s.price AS service_price,
    o.tour_start_date
FROM orders o
JOIN clients c ON o.client_id = c.client_id
JOIN services s ON o.service_id = s.service_id
WHERE s.is_available = TRUE;