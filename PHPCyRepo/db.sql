CREATE TABLE `packages` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `downloads` int(11) DEFAULT '0',
  `views` int(11) DEFAULT '0',
  `hidden` int(1) DEFAULT '0',
  `Package` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Version` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Maintainer` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Author` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Description` text COLLATE utf8mb4_unicode_ci,
  `Section` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Priority` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Installed-Size` int(11) NOT NULL,
  `Essential` int(1) DEFAULT '0',
  `Build-Essential` int(1) DEFAULT '0',
  `Architecture` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Origin` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Bugs` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Homepage` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Tag` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Multi-Arch` varchar(128) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Depends` text COLLATE utf8mb4_unicode_ci,
  `Pre-Depends` text COLLATE utf8mb4_unicode_ci,
  `Recommends` text COLLATE utf8mb4_unicode_ci,
  `Suggests` text COLLATE utf8mb4_unicode_ci,
  `Breaks` text COLLATE utf8mb4_unicode_ci,
  `Conflicts` text COLLATE utf8mb4_unicode_ci,
  `Replaces` text COLLATE utf8mb4_unicode_ci,
  `Provides` text COLLATE utf8mb4_unicode_ci,
  `Filename` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Size` int(11) NOT NULL,
  `MD5sum` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Depiction` text COLLATE utf8mb4_unicode_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `auth` int(1) NOT NULL,
  `token` varchar(64) COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `users` (`id`, `username`, `password`, `auth`, `token`) VALUES
(1, 'admin', '$2y$10$DBhupIr7eM2pOCanZI4Jxu921AMelkxSM2Xk4Kx/xFMKOMJQzUE7W', 1, NULL);

ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `packages`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `Package` (`Package`);

ALTER TABLE `packages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;
