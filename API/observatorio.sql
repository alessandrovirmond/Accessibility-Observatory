-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3308
-- Tempo de geração: 12/01/2025 às 20:20
-- Versão do servidor: 10.4.28-MariaDB
-- Versão do PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `observatorio`
--
CREATE DATABASE IF NOT EXISTS `observatorio` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `observatorio`;

-- --------------------------------------------------------

--
-- Estrutura para tabela `dominio`
--

CREATE TABLE IF NOT EXISTS `dominio` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `elemento_afetado`
--

CREATE TABLE IF NOT EXISTS `elemento_afetado` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `elemento_html` text NOT NULL,
  `selectores` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`selectores`)),
  `texto_contexto` text DEFAULT NULL,
  `violacao_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `violacao_id` (`violacao_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `subdominio`
--

CREATE TABLE IF NOT EXISTS `subdominio` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(255) NOT NULL,
  `nota` decimal(2),
  `total_elementos_testados` int(11) NOT NULL,
  `dominio_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `dominio_id` (`dominio_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `violacao`
--

CREATE TABLE IF NOT EXISTS `violacao` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` text NOT NULL,
  `regra_violada` varchar(255) NOT NULL,
  `como_corrigir` text NOT NULL,
  `mais_informacoes` text DEFAULT NULL,
  `nivel_impacto` text NOT NULL,
  `subdominio_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `subdominio_id` (`subdominio_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `elemento_afetado`
--
ALTER TABLE `elemento_afetado`
  ADD CONSTRAINT `elemento_afetado_ibfk_1` FOREIGN KEY (`violacao_id`) REFERENCES `violacao` (`id`);

--
-- Restrições para tabelas `subdominio`
--
ALTER TABLE `subdominio`
  ADD CONSTRAINT `subdominio_ibfk_1` FOREIGN KEY (`dominio_id`) REFERENCES `dominio` (`id`);

--
-- Restrições para tabelas `violacao`
--
ALTER TABLE `violacao`
  ADD CONSTRAINT `violacao_ibfk_1` FOREIGN KEY (`subdominio_id`) REFERENCES `subdominio` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
