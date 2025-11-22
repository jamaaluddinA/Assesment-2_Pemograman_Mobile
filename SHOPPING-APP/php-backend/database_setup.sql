-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 21 Nov 2025 pada 10.07
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `shopping_app`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `category` varchar(100) NOT NULL,
  `imagePath` varchar(500) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `products`
--

INSERT INTO `products` (`id`, `name`, `category`, `imagePath`, `description`, `price`, `quantity`, `created_at`) VALUES
(1, 'iPhone 14 Pro', 'Electronics', 'assets/images/product_1.jpeg', 'Latest iPhone with advanced camera', 14999000.00, 10, '2025-11-21 07:58:41'),
(2, 'Samsung Galaxy S23', 'Electronics', 'assets/images/product_2.jpeg', 'Powerful Android smartphone', 12999000.00, 15, '2025-11-21 07:58:41'),
(3, 'MacBook Air M2', 'Electronics', 'assets/images/product_1.jpeg', 'Lightweight and powerful laptop', 19999000.00, 5, '2025-11-21 07:58:41'),
(4, 'Nike Air Max', 'Fashion', 'assets/images/product_2.jpeg', 'Comfortable running shoes', 1999000.00, 20, '2025-11-21 07:58:41'),
(5, 'Coffee Maker', 'Home Appliances', 'assets/images/product_1.jpeg', 'Automatic coffee machine', 899000.00, 8, '2025-11-21 07:58:41'),
(6, 'iPhone 14 Pro', 'Electronics', 'assets/images/product_1.jpeg', 'Latest iPhone with advanced camera', 14999000.00, 10, '2025-11-21 09:06:05'),
(7, 'Samsung Galaxy S23', 'Electronics', 'assets/images/product_2.jpeg', 'Powerful Android smartphone', 12999000.00, 15, '2025-11-21 09:06:05'),
(8, 'MacBook Air M2', 'Electronics', 'assets/images/product_1.jpeg', 'Lightweight and powerful laptop', 19999000.00, 5, '2025-11-21 09:06:05'),
(9, 'Nike Air Max', 'Fashion', 'assets/images/product_2.jpeg', 'Comfortable running shoes', 1999000.00, 20, '2025-11-21 09:06:05'),
(10, 'Coffee Maker', 'Home Appliances', 'assets/images/product_1.jpeg', 'Automatic coffee machine', 899000.00, 8, '2025-11-21 09:06:05');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
