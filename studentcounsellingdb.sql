-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 10, 2026 at 07:33 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `studentcounsellingdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin_user`
--

CREATE TABLE `admin_user` (
  `ADMIN_ID` int(12) NOT NULL,
  `ADMIN_EMAIL` varchar(50) NOT NULL,
  `PASSWORD_HASH` varchar(30) NOT NULL,
  `ROLE_ID` int(11) DEFAULT 1,
  `ADMIN_NAME` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin_user`
--

INSERT INTO `admin_user` (`ADMIN_ID`, `ADMIN_EMAIL`, `PASSWORD_HASH`, `ROLE_ID`, `ADMIN_NAME`) VALUES
(1, 'admin@uitm.edu.my', 'admin123', 1, 'System Admin');

-- --------------------------------------------------------

--
-- Table structure for table `appointment`
--

CREATE TABLE `appointment` (
  `BOOKINGID` int(11) NOT NULL,
  `STUDENTID` varchar(12) NOT NULL,
  `STUDENTNAME` varchar(100) DEFAULT NULL,
  `STUD_PHONE` varchar(20) DEFAULT NULL,
  `COUNSELORID` varchar(12) NOT NULL,
  `BOOKEDDATE` date DEFAULT NULL,
  `TIMESLOT` varchar(50) DEFAULT NULL,
  `REASON` text DEFAULT NULL,
  `STATUS` varchar(20) DEFAULT 'Pending',
  `REMARK` text DEFAULT NULL,
  `NOTE` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointment`
--

INSERT INTO `appointment` (`BOOKINGID`, `STUDENTID`, `STUDENTNAME`, `STUD_PHONE`, `COUNSELORID`, `BOOKEDDATE`, `TIMESLOT`, `REASON`, `STATUS`, `REMARK`, `NOTE`) VALUES
(2, '2025121601', 'Aizam Mukmin bin Shaharuddin', '0111111111', 'C001', '2026-01-20', '8:30 - 9:30 AM', 'stress', 'Done Session', 'adasd', 'ddda dada'),
(4, '2025121602', 'Bela Anak Bidin', '0111111112', 'C001', '2026-01-09', '8:30 - 9:30 AM', 'Procrastination: \"Struggling to stay motivated and starting assignments at the last minute.\"', 'Done Session', 'Assessed the student\'s procrastination habits, which stem from a fear of failure rather than laziness. Established a baseline for academic goal setting. The session concluded with a commitment to the \'2-minute rule\' for starting minor tasks. Effectiveness of this behavioral change will be reviewed in the next meeting.', 'Student showed significant resistance initially but opened up about high internal expectations. Discussed \'perfectionism paralysis.\' We broke down the upcoming assignment into 5 micro-goals. Recommended the Pomodoro technique (25/5 intervals). Student is to report back on the completion of the first micro-goal by Wednesday.'),
(7, '2025121601', 'Aizam Mukmin bin Shaharuddin', '0111111111', 'C001', '2026-02-10', '10:00 - 11:00 AM', 'Academic Pressure: \"Feeling overwhelmed by the expectations of maintaining a high GPA.\"', 'Done Session', 'no need follow all going well', 'noted with the student and giving suitable techniques to help his problem');

-- --------------------------------------------------------

--
-- Table structure for table `counselor`
--

CREATE TABLE `counselor` (
  `COUNSELORID` varchar(12) NOT NULL,
  `COUNS_NAME` varchar(100) DEFAULT NULL,
  `COUNS_EMAIL` varchar(50) DEFAULT NULL,
  `COUNS_PHONE` varchar(20) DEFAULT NULL,
  `COUNS_PASS` varchar(30) DEFAULT NULL,
  `ROLE_ID` int(11) DEFAULT 2
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `counselor`
--

INSERT INTO `counselor` (`COUNSELORID`, `COUNS_NAME`, `COUNS_EMAIL`, `COUNS_PHONE`, `COUNS_PASS`, `ROLE_ID`) VALUES
('C001', 'Sir Mahmud', 'mahmud@uitm.edu.my', '0111192822', 'Cpass123', 2),
('C002', 'Sir Ashraf Sinclair', 'ashraf@uitm.edu.my', '0111111119', 'Ashraf123', 2);

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `STUDENTID` varchar(12) NOT NULL,
  `STUD_NAME` varchar(100) NOT NULL,
  `STUD_PHONE` varchar(20) DEFAULT NULL,
  `STUD_EMAIL` varchar(50) NOT NULL,
  `PASSWORD_HASH` varchar(30) NOT NULL,
  `STUD_ADDR` text DEFAULT NULL,
  `ROLE_ID` int(11) DEFAULT 3
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`STUDENTID`, `STUD_NAME`, `STUD_PHONE`, `STUD_EMAIL`, `PASSWORD_HASH`, `STUD_ADDR`, `ROLE_ID`) VALUES
('2025121601', 'Aizam Mukmin bin Shaharuddin', '0111111111', '2025121601@student.uitm.edu.my', 'Aizammukmin1', 'Bintulu, Sarawak', 3),
('2025121602', 'Bela Anak Bidin', '0111111112', '2025121602@student.uitm.edu.my', 'Bela1234', 'Limbang, Sarawak', 3);

-- --------------------------------------------------------

--
-- Table structure for table `user_roles`
--

CREATE TABLE `user_roles` (
  `ROLE_ID` int(11) NOT NULL,
  `ROLE_NAME` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_roles`
--

INSERT INTO `user_roles` (`ROLE_ID`, `ROLE_NAME`) VALUES
(1, 'Admin'),
(2, 'Counselor'),
(3, 'Student');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin_user`
--
ALTER TABLE `admin_user`
  ADD PRIMARY KEY (`ADMIN_ID`),
  ADD UNIQUE KEY `ADMIN_EMAIL` (`ADMIN_EMAIL`),
  ADD KEY `FK_ADMIN_ROLE` (`ROLE_ID`);

--
-- Indexes for table `appointment`
--
ALTER TABLE `appointment`
  ADD PRIMARY KEY (`BOOKINGID`),
  ADD KEY `FK_APP_STUDENT` (`STUDENTID`),
  ADD KEY `FK_APP_COUNS` (`COUNSELORID`);

--
-- Indexes for table `counselor`
--
ALTER TABLE `counselor`
  ADD PRIMARY KEY (`COUNSELORID`),
  ADD KEY `FK_COUNS_ROLE` (`ROLE_ID`);

--
-- Indexes for table `student`
--
ALTER TABLE `student`
  ADD PRIMARY KEY (`STUDENTID`),
  ADD UNIQUE KEY `STUD_EMAIL` (`STUD_EMAIL`),
  ADD KEY `FK_STUD_ROLE` (`ROLE_ID`);

--
-- Indexes for table `user_roles`
--
ALTER TABLE `user_roles`
  ADD PRIMARY KEY (`ROLE_ID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointment`
--
ALTER TABLE `appointment`
  MODIFY `BOOKINGID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admin_user`
--
ALTER TABLE `admin_user`
  ADD CONSTRAINT `FK_ADMIN_ROLE` FOREIGN KEY (`ROLE_ID`) REFERENCES `user_roles` (`ROLE_ID`);

--
-- Constraints for table `appointment`
--
ALTER TABLE `appointment`
  ADD CONSTRAINT `FK_APP_COUNS` FOREIGN KEY (`COUNSELORID`) REFERENCES `counselor` (`COUNSELORID`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `FK_APP_STUDENT` FOREIGN KEY (`STUDENTID`) REFERENCES `student` (`STUDENTID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `counselor`
--
ALTER TABLE `counselor`
  ADD CONSTRAINT `FK_COUNS_ROLE` FOREIGN KEY (`ROLE_ID`) REFERENCES `user_roles` (`ROLE_ID`);

--
-- Constraints for table `student`
--
ALTER TABLE `student`
  ADD CONSTRAINT `FK_STUD_ROLE` FOREIGN KEY (`ROLE_ID`) REFERENCES `user_roles` (`ROLE_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
