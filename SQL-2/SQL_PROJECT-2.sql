-- Create the database
CREATE DATABASE MovieRecommendations;
-- Use the database
USE MovieRecommendations;
-- Create the table use CSV to sql DATABASE
select * from imdb_top_1000;

-- basic operations 
-- Inserting Data
INSERT INTO imdb_top_1000 (
    Poster_Link, Series_Title, Released_Year, Certificate, Runtime, Genre, 
    IMDB_Rating, Overview, Meta_score, Director, Star1, Star2, Star3, Star4, 
    No_of_Votes, Gross
) VALUES (
    'https://linktoimage.com/poster1.jpg', 'Movie Title 1', 2020, 'PG-13', '120 min', 
    'Action, Adventure', 7.5, 'An exciting movie about...', 80, 'Director Name', 
    'Star 1', 'Star 2', 'Star 3', 'Star 4', 150000, 1000000.00
);

INSERT INTO imdb_top_1000 (
    Poster_Link, Series_Title, Released_Year, Certificate, Runtime, Genre, 
    IMDB_Rating, Overview, Meta_score, Director, Star1, Star2, Star3, Star4, 
    No_of_Votes, Gross
) VALUES (
    'https://linktoimage.com/poster2.jpg', 'Movie Title 2', 2019, 'R', '135 min', 
    'Drama, Thriller', 8.2, 'A gripping tale of...', 85, 'Another Director', 
    'Actor 1', 'Actor 2', 'Actor 3', 'Actor 4', 200000, 1500000.00
);

-- Selecting Data
SELECT * FROM imdb_top_1000;

-- Retrieve specific columns.
SELECT Series_Title, Released_Year, IMDB_Rating FROM imdb_top_1000;

-- Filtering Data
 ----- Use WHERE clause to filter records.
SELECT * FROM imdb_top_1000 WHERE Released_Year = 2020;
 ----- Use AND and OR to combine conditions.
 SELECT * FROM imdb_top_1000 WHERE Released_Year = 2020 AND IMDB_Rating > 7.0;
 
 -- Sorting Data
 ----- Sort the results using ORDER BY.
 SELECT * FROM imdb_top_1000 ORDER BY IMDB_Rating DESC;
 ----- Sort by multiple columns.
 SELECT * FROM imdb_top_1000 ORDER BY Released_Year DESC, IMDB_Rating DESC;
 
 -- Updating Data
 ----- Update a specific record.
 
 ----- Disable Safe Update Mode Temporarily
 SET SQL_SAFE_UPDATES = 0;
 
 ----- Perform the Update
UPDATE imdb_top_1000
SET IMDB_Rating = 7.8
WHERE Series_Title = 'Movie Title 1';

----- Re-enable Safe Update Mode
SET SQL_SAFE_UPDATES = 1;

SELECT IMDB_Rating FROM imdb_top_1000;

-- Delete 
----- Deleting Data
----- Delete a specific record.
SET SQL_SAFE_UPDATES = 0;
DELETE FROM imdb_top_1000
WHERE Series_Title = 'Movie Title 1';

----- Delete all records from the table.
DELETE FROM imdb_top_1000;

-- Counting Records
----- Count the number of records in the table.
SELECT COUNT(*) FROM imdb_top_1000;

----- Count records with specific criteria.
SELECT COUNT(*) FROM imdb_top_1000 WHERE IMDB_Rating > 8.0;

-- Grouping Data
----- Group data using GROUP BY and use aggregate functions like AVG, SUM, MAX, MIN.
----- AVG
SELECT Genre, AVG(IMDB_Rating) as Avg_Rating
FROM imdb_top_1000
GROUP BY Genre;
----- SUM
SELECT Genre, SUM(IMDB_Rating) as Sum_Rating
FROM imdb_top_1000
GROUP BY Genre;
----- MAX
SELECT Genre, MAX(IMDB_Rating) as Max_Rating
FROM imdb_top_1000
GROUP BY Genre;
----- MIN
SELECT Genre, MIN(IMDB_Rating) as Min_Rating
FROM imdb_top_1000
GROUP BY Genre;

-- Joining Tables
----- Let's assume you have another table Actors
-- New Table
CREATE TABLE Actors (
    ActorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255),
    BirthYear INT
);

INSERT INTO Actors (Name, BirthYear) VALUES 
('Star 1', 1970), ('Star 2', 1980), ('Actor 1', 1990), ('Actor 2', 1985);

-- INNER JOIN
----- Returns records that have matching values in both tables.
----- Example: List all movies along with their first star actor's details.
SELECT imdb_top_1000.Series_Title, imdb_top_1000.Released_Year, imdb_top_1000.IMDB_Rating, Actors.Name, Actors.BirthYear
FROM imdb_top_1000
INNER JOIN Actors ON imdb_top_1000.Star1 = Actors.Name;

-- LEFT JOIN (or LEFT OUTER JOIN)
----- Returns all records from the left table (imdb_top_1000), and the matched records from the right table (Actors). 
----- The result is NULL from the right side if there is no match.
----- Example: List all movies along with their first star actor's details, including movies without a corresponding actor.
SELECT imdb_top_1000.Series_Title, imdb_top_1000.Released_Year, imdb_top_1000.IMDB_Rating, Actors.Name, Actors.BirthYear
FROM imdb_top_1000
LEFT JOIN Actors ON imdb_top_1000.Star1 = Actors.Name;

-- RIGHT JOIN (or RIGHT OUTER JOIN)
----- Returns all records from the right table (Actors), and the matched records from the left table (imdb_top_1000). 
----- The result is NULL from the left side when there is no match.
----- Example: List all actors and their movies, including actors who haven't starred in any movie.
SELECT imdb_top_1000.Series_Title, Actors.Name
FROM imdb_top_1000
RIGHT JOIN Actors ON imdb_top_1000.Star1 = Actors.Name;

-- FULL JOIN (or FULL OUTER JOIN)
----- Returns all records when there is a match in either left or right table. 
----- If there is no match, the result is NULL on the side that does not have a match. 
----- Note that MySQL does not directly support FULL JOIN, so we use UNION of LEFT JOIN and RIGHT JOIN.
----- Example: List all movies and actors, including movies without corresponding actors and actors without corresponding movies.
SELECT imdb_top_1000.Series_Title, imdb_top_1000.Released_Year, imdb_top_1000.IMDB_Rating, Actors.Name, Actors.BirthYear
FROM imdb_top_1000
LEFT JOIN Actors ON imdb_top_1000.Star1 = Actors.Name

UNION

SELECT imdb_top_1000.Series_Title, imdb_top_1000.Released_Year, imdb_top_1000.IMDB_Rating, Actors.Name, Actors.BirthYear
FROM imdb_top_1000
RIGHT JOIN Actors ON imdb_top_1000.Star1 = Actors.Name;

-- CROSS JOIN
----- Returns the Cartesian product of the two tables, i.e., it returns all possible combinations of rows from the two tables.
----- Example: List all possible combinations of movies and actors.
SELECT imdb_top_1000.Series_Title, Actors.Name
FROM imdb_top_1000
CROSS JOIN Actors;

-- SELF JOIN
----- A self join is a regular join but the table is joined with itself.
----- Example: Compare movies directed by the same director.
----- If you want to compare movies that fall under the same genre, you can modify the self join condition to use the Genre column:
SELECT A.Series_Title AS Movie1, A.Released_Year AS Year1, B.Series_Title AS Movie2, B.Released_Year AS Year2, A.Director
FROM imdb_top_1000 A
INNER JOIN imdb_top_1000 B 
    ON A.Director = B.Director 
    AND (A.Series_Title <> B.Series_Title OR A.Released_Year <> B.Released_Year)
ORDER BY A.Director
LIMIT 1000;

-- Advanced Filtering with LIKE
----- Use the LIKE keyword for pattern matching.
SELECT * FROM imdb_top_1000
WHERE Series_Title LIKE 'Movie%';

-- Subqueries
----- A subquery is a query nested inside another query.
----- Example: Find movies with an IMDB rating higher than the average rating
SELECT Series_Title, IMDB_Rating
FROM imdb_top_1000
WHERE IMDB_Rating > (SELECT AVG(IMDB_Rating) FROM imdb_top_1000);

-- Common Table Expressions (CTEs)
----- A CTE is a temporary result set that you can reference within a SELECT, INSERT, UPDATE, or DELETE statement.
----- Example: Find the top 5 highest rated movies
WITH TopMovies AS (
    SELECT Series_Title, IMDB_Rating
    FROM imdb_top_1000
    ORDER BY IMDB_Rating DESC
    LIMIT 5
)
SELECT * FROM TopMovies;

-- Window Functions
----- Window functions perform calculations across a set of table rows that are related to the current row.
----- Example: Calculate the rank of each movie based on its IMDB rating
SELECT Series_Title, IMDB_Rating,
       RANK() OVER (ORDER BY IMDB_Rating DESC) AS MovieRank
FROM imdb_top_1000;

-- Pivoting Data
----- Pivoting data involves rotating a table-valued expression by turning the unique 
----- values from one column into multiple columns in the output.
----- Example: Pivot data to show the count of movies per genre
----- Note: Standard SQL does not have a direct PIVOT function like in some SQL dialects. 
----- Here's how you can do it using CASE statements.
SELECT
    Genre,
    COUNT(CASE WHEN Released_Year = 2020 THEN 1 END) AS '2020',
    COUNT(CASE WHEN Released_Year = 2021 THEN 1 END) AS '2021'
FROM imdb_top_1000
GROUP BY Genre;

-- Full-Text Search
----- Full-text search allows you to quickly search through large text columns.
----- Example: Search for movies that have 'love' in their overview.
-- Create FULLTEXT Index:
CREATE FULLTEXT INDEX ft_index ON imdb_top_1000 (Overview);
-- Perform Full-Text Search:
SELECT Series_Title, Overview
FROM imdb_top_1000
WHERE MATCH(Overview) AGAINST('love');

-- Stored Procedures
----- Stored procedures are SQL code that you can save and reuse.
----- Example: Create a stored procedure to get movies by director

----- Change the delimiter to $$
DELIMITER $$

----- Create the stored procedure
CREATE PROCEDURE GetMoviesByDirector(IN directorName VARCHAR(255))
BEGIN
    SELECT Series_Title, Released_Year, IMDB_Rating
    FROM imdb_top_1000
    WHERE Director = directorName;
END$$

----- Reset the delimiter back to ;
DELIMITER ;

-- Call the stored procedure
CALL GetMoviesByDirector('Christopher Nolan');


-- Triggers
----- Triggers are SQL code that automatically execute in response to certain events on a particular table or view.
----- Example: Create a trigger to log changes to the IMDB rating.

-- Create the RatingChanges table
CREATE TABLE RatingChanges (
    ChangeID INT AUTO_INCREMENT PRIMARY KEY,
    Series_Title VARCHAR(255),
    OldRating DECIMAL(3,1),
    NewRating DECIMAL(3,1),
    ChangeDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Change the delimiter to $$
DELIMITER $$

-- Create the trigger
CREATE TRIGGER before_rating_update
BEFORE UPDATE ON imdb_top_1000
FOR EACH ROW
BEGIN
    IF NEW.IMDB_Rating != OLD.IMDB_Rating THEN
        INSERT INTO RatingChanges (Series_Title, OldRating, NewRating)
        VALUES (OLD.Series_Title, OLD.IMDB_Rating, NEW.IMDB_Rating);
    END IF;
END$$

-- Reset the delimiter back to ;
DELIMITER ;

-- User-Defined Functions (UDFs):
-- UDFs are custom functions that you can create to perform specific tasks.
-- Example: Create a UDF to calculate the age of a movie.

-- Change the delimiter to $$
DELIMITER $$

-- Create the function with DETERMINISTIC characteristic
CREATE FUNCTION MovieAge(releaseYear INT) RETURNS INT
DETERMINISTIC
BEGIN
    RETURN YEAR(CURDATE()) - releaseYear;
END$$

-- Reset the delimiter back to ;
DELIMITER ;

-- Use the UDF in a query
SELECT Series_Title, Released_Year, MovieAge(Released_Year) AS Age
FROM imdb_top_1000;

-- project :
-- Objective
----- This project aims to develop a movie recommendation system using SQL queries. 
----- The system will generate personalized movie recommendations for users by analyzing movie ratings 
----- and user preferences, enhancing their movie-watching experience.

-- Dataset Overview and Preprocessing
----- A dataset containing movie ratings and user information is required to build the recommendation system. 
----- The dataset may include attributes such as movie IDs, user IDs, ratings, genres, and timestamps. 
----- Before analyzing the data, preprocessing steps like data cleaning, handling missing values, 
----- and data normalization may be necessary to ensure accurate results.

-- SQL Queries for Analysis
----- SQL queries will be employed to analyze the dataset to generate movie recommendations. 
----- These queries may involve aggregating ratings, calculating similarity scores between movies or users, 
----- and identifying top-rated or similar movies. Using SQL, the recommendation system can efficiently process large datasets 
----- and provide accurate recommendations based on user preferences.

-- Key Insights and Findings
----- The analysis of movie ratings and user preferences will yield valuable insights. 
----- The recommendation system can identify popular movies, genres with high user ratings, and movies frequently watched together. 
----- These insights can help movie platforms understand user preferences, improve their movie catalog, 
----- and provide tailored recommendations, ultimately enhancing user satisfaction.


-- To build a movie recommendation system using SQL, we will need to define the database schema, load the data, 
-- and then create SQL queries to analyze the data and generate recommendations. 
-- Below is a step-by-step guide to set up the project, perform preprocessing, and create the necessary SQL queries for analysis.

-- Step 1: Define the Database Schema
-- We'll create three tables: movies, users, and ratings.

-- 1)Movies table will store movie details.
-- 2)Users table will store user information.
-- 3)Ratings table will store user ratings for movies.
-- Create Tables
-- Create Movies table
CREATE TABLE movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(255),
    genre VARCHAR(255),
    released_year INT,
    imdb_rating DECIMAL(3, 1),
    director VARCHAR(255),
    overview TEXT
);

-- Create Users table
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(255),
    birth_year INT
);

-- Create Ratings table
CREATE TABLE ratings (
    user_id INT,
    movie_id INT,
    rating DECIMAL(2, 1),
    rating_timestamp TIMESTAMP,
    PRIMARY KEY (user_id, movie_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

-- Load the Data
----- You would typically load data from CSV files or another source into these tables. 
----- Here's an example of how to load data using SQL INSERT statements:
-- Insert data into Movies table
INSERT INTO movies (movie_id, title, genre, released_year, imdb_rating, director, overview) VALUES
(1, 'The Shawshank Redemption', 'Drama', 1994, 9.3, 'Frank Darabont', 'Two imprisoned men bond over a number of years, finding solace and eventual redemption through acts of common decency.'),
(2, 'The Godfather', 'Crime, Drama', 1972, 9.2, 'Francis Ford Coppola', 'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.');

-- Insert data into Users table
INSERT INTO users (user_id, name, birth_year) VALUES
(1, 'Alice', 1990),
(2, 'Bob', 1985);

-- Insert data into Ratings table
INSERT INTO ratings (user_id, movie_id, rating, rating_timestamp) VALUES
(1, 1, 9.5, '2024-01-01 12:00:00'),
(2, 2, 9.0, '2024-01-02 13:00:00');

-- SQL Queries for Analysis
-- Aggregate Ratings
----- Calculate the average rating for each movie.
SELECT movie_id, AVG(rating) AS avg_rating
FROM ratings
GROUP BY movie_id;

-- Top-Rated Movies
----- Find the top 5 highest-rated movies.
SELECT m.title, AVG(r.rating) AS avg_rating
FROM ratings r
JOIN movies m ON r.movie_id = m.movie_id
GROUP BY r.movie_id
ORDER BY avg_rating DESC
LIMIT 5;

-- User Preferences
----- Find the favorite genre of a user based on their highest-rated movies.
SELECT u.name, m.genre, AVG(r.rating) AS avg_rating
FROM ratings r
JOIN movies m ON r.movie_id = m.movie_id
JOIN users u ON r.user_id = u.user_id
WHERE u.user_id = 1
GROUP BY m.genre
ORDER BY avg_rating DESC
LIMIT 1;

-- Movies Frequently Watched Together
----- Find pairs of movies that are frequently watched together by the same users.
SELECT r1.movie_id AS movie1, r2.movie_id AS movie2, COUNT(*) AS watch_count
FROM ratings r1
JOIN ratings r2 ON r1.user_id = r2.user_id AND r1.movie_id < r2.movie_id
GROUP BY r1.movie_id, r2.movie_id
ORDER BY watch_count DESC
LIMIT 10;

-- Key Insights and Findings
----- Advanced SQL Techniques
-- Common Table Expressions (CTEs)
----- Use CTEs for complex queries.
WITH AvgRatings AS (
    SELECT movie_id, AVG(rating) AS avg_rating
    FROM ratings
    GROUP BY movie_id
)
SELECT m.title, ar.avg_rating
FROM AvgRatings ar
JOIN movies m ON ar.movie_id = m.movie_id
ORDER BY ar.avg_rating DESC
LIMIT 5;

-- Window Functions
----- Rank movies within each genre.
SELECT title, genre, imdb_rating,
       RANK() OVER (PARTITION BY genre ORDER BY imdb_rating DESC) AS genre_rank
FROM movies;

-- Stored Procedures
----- Create a stored procedure to get personalized recommendations.
DELIMITER $$

CREATE PROCEDURE GetRecommendations(IN userID INT)
BEGIN
    SELECT m.title, AVG(r.rating) AS avg_rating
    FROM ratings r
    JOIN movies m ON r.movie_id = m.movie_id
    WHERE r.user_id = userID
    GROUP BY r.movie_id
    ORDER BY avg_rating DESC
    LIMIT 5;
END$$

DELIMITER ;

-- Call the stored procedure
CALL GetRecommendations(1);








































 












