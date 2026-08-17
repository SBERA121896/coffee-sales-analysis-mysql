CREATE DATABASE coffe_sales;
USE coffe_sales;

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100),
    price INT
);

CREATE TABLE city(
	city_id	INT AUTO_INCREMENT PRIMARY KEY,
    city_name VARCHAR(50),
    population	INT,
    estimated_rent	INT,
    city_rank INT
);

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    city_id INT,
    FOREIGN KEY (city_id)
        REFERENCES city (city_id)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    sale_date DATE,
    product_id INT,
    customer_id INT,
    total INT,
    rating INT,
    FOREIGN KEY (product_id)
        REFERENCES products (product_id),
    FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)
);
    