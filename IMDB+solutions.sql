USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
-- Ans: Using TABLE_SCHEMA to fetch total no. of records for all the tables in imdb schema.

SELECT table_name, table_rows
FROM information_schema.tables
WHERE table_schema = 'imdb';


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
-- Ans: Using CASE statements to find total null values in each column of movie table.

SELECT SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_null_count,
	SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_null_count,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_null_count,
    SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_null_count,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_null_count,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_null_count,
    SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_null_count,
    SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_null_count,
    SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_null_count
FROM movie;


-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Ans: Month can be extracted by using MONTH function on the date published column.
-- Total number of movies released each year:

SELECT year, COUNT(id) AS number_of_movies
FROM movie
GROUP BY year
ORDER BY year;

-- Maximum movies are produced in 2017.
-- Total number of movies released each month:

SELECT MONTH(date_published) AS month_num,
	COUNT(id) AS number_of_movies
FROM movie
GROUP BY MONTH(date_published)
ORDER BY MONTH(date_published);


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
-- Ans: Use of LIKE operator as there can be more than one country in which the movie is released.

SELECT year, count(id) AS movies_count
FROM movie
WHERE (country LIKE '%USA%' OR country LIKE '%india%') AND year = 2019;


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
-- Ans: DISTINCT will give all the unique values in genre column.

SELECT DISTINCT(genre) AS diff_genre_list
FROM genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
-- Ans: COUNT function give the number of movies produced in each genre by GROUPING genre.

SELECT genre, COUNT(movie_id) AS number_of_movies
FROM genre
GROUP BY genre
ORDER BY number_of_movies DESC
LIMIT 1;


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
-- Ans: First list the movies having 1 genre and then counting total number of movies having 1 genre.

WITH one_genre_movie_summary AS
	(SELECT movie_id, COUNT(genre) AS genre_count
	FROM genre 
	GROUP BY movie_id
	HAVING genre_count = 1)
SELECT COUNT(movie_id) AS one_genre_movies_count
FROM one_genre_movie_summary;


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Ans: Using AVG function on duration and combining genre and movie table.

SELECT genre, ROUND(AVG(duration),2) AS avg_duration
FROM genre g
	INNER JOIN movie m ON g.movie_id = m.id
GROUP BY genre
ORDER BY avg_duration DESC;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Ans: Ranking all the Genre on the basis of number of movies and then we can get thriller genre ranking.

WITH genre_rank_summary AS
	(SELECT genre, COUNT(movie_id) AS movie_count,
		DENSE_RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
	FROM genre
	GROUP BY genre)
SELECT *
FROM genre_rank_summary
WHERE genre = 'thriller';


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/




-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
-- Ans: Use MIN and MAX function to check min and max value of ratings table columns.

SELECT MIN(avg_rating) AS min_avg_rating, 
	MAX(avg_rating) AS max_avg_rating,
	MIN(total_votes) AS min_total_votes,
	MAX(total_votes) AS max_total_votes,
	MIN(median_rating) AS min_meadian_rating,
    MAX(median_rating) AS max_median_rating
FROM ratings;


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
-- Ans: Using RANK function on avg_rating we can get top 10 movies.

SELECT title, avg_rating,
	RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM movie m
	INNER JOIN ratings r
    ON m.id = r.movie_id
LIMIT 10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have
-- Ans: ORDER BY can be used to have number of movies in each median rating.

SELECT median_rating, 
	COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:
-- Ans: By ranking all the production houses on number of movies produced having avg rating >8 we can get top production house.

WITH prod_house_summary AS 
	(SELECT production_company,
		COUNT(m.id) AS movie_count,
		DENSE_RANK() OVER(ORDER BY count(m.id) DESC) AS prod_company_rank
	FROM movie m
		INNER JOIN ratings r
		ON m.id = r.movie_id
	WHERE avg_rating > 8 AND production_company IS NOT NULL
	GROUP BY production_company)
SELECT *
FROM prod_house_summary
WHERE prod_company_rank = 1;


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Ans: Filtering data on march 2017 using MONTH function and country USA with total votes >1000 we can get number of movies in each genre.

SELECT g.genre, COUNT(g.movie_id) AS movie_count
FROM genre g 
	INNER JOIN movie m ON g.movie_id = m.id
    INNER JOIN ratings r ON m.id = r.movie_id
WHERE MONTH(m.date_published) = 3 
	AND m.year = '2017'
	AND m.country = 'USA'
    AND r.total_votes > 1000
GROUP BY genre
ORDER BY movie_count DESC;


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- Ans: We can use REGEXP for getting movies name starting with 'the' and filtering on avg rating >8.

SELECT m.title, r.avg_rating, g.genre
FROM genre g 
	INNER JOIN movie m ON g.movie_id = m.id
    INNER JOIN ratings r ON m.id = r.movie_id
WHERE title REGEXP '^the'
	AND r.avg_rating > 8
ORDER BY avg_rating DESC;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
-- Ans: Filtering on the date publiished with median rating = 8.

SELECT median_rating, COUNT(movie_id) AS movie_count
FROM ratings r
	INNER JOIN movie m 
    ON r.movie_id = m.id
WHERE median_rating = 8
	AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
-- Ans: Using LIKE operator and SUM of total votes using CASE statements we can get the number of votes for both languages.

SELECT
	SUM(CASE WHEN languages LIKE '%german%' THEN total_votes END) AS german_movie_votes,
    SUM(CASE WHEN languages like '%italian%' THEN total_votes END) AS italian_movie_votes
FROM ratings r
	INNER JOIN movie m 
    ON r.movie_id = m.id;

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
-- Ans: Using CASE statement using SUM operator we can get total number of null records from name table.

SELECT SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
	SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM names;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Ans: Make cte for top 3 genre with avg rating > 8 and rank on count of movies and then filter top directors having avg rating >8.

WITH top_genre_summary AS
	(SELECT genre, COUNT(movie_id) AS movie_count,
		RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
    FROM genre
		INNER JOIN ratings USING (movie_id)
	WHERE avg_rating > 8
    GROUP BY genre
    ORDER BY movie_count DESC
    LIMIT 3)
SELECT n.name AS director_name, COUNT(g.movie_id) AS movie_count
FROM names n
	INNER JOIN director_mapping d ON n.id = d.name_id
	INNER JOIN genre g USING (movie_id)
	INNER JOIN ratings r ON g.movie_id = r.movie_id
    INNER JOIN top_genre_summary t ON t.genre = g.genre
WHERE avg_rating > 8
GROUP BY director_name
ORDER BY movie_count DESC
LIMIT 3;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Ans: Top 2 actors can be found by filtering records on median rating >= 8 and category as actor.

SELECT DISTINCT(name) AS actor_name, COUNT(movie_id) AS movie_count
FROM role_mapping rm
	INNER JOIN ratings r USING (movie_id)
	INNER JOIN names n ON n.id = rm.name_id
WHERE r.median_rating >= 8
	AND rm.category = 'actor'
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
-- Ans: By ranking production house on total number of votes.

SELECT production_company,
	SUM(total_votes) AS vote_count,
	RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie m
	INNER JOIN ratings r
	ON m.id = r.movie_id
GROUP BY production_company
LIMIT 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
/* Ans: Make cte for actors for calculating their weighted average and filtering on country = india and category = actor. 
RANK them on basis of their weighted average. */

WITH top_actor_summary AS
	(SELECT name AS actor_name,
		total_votes, COUNT(r.movie_id) AS movie_count,
		ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actor_avg_rating
	FROM movie m
		INNER JOIN ratings r ON m.id = r.movie_id
		INNER JOIN role_mapping rm ON m.id = rm.movie_id
		INNER JOIN names n ON rm.name_id = n.id
	WHERE country = 'india' AND category = 'actor'
    GROUP BY name
    HAVING movie_count >= 5
    ORDER BY actor_avg_rating, total_votes DESC)
SELECT *,
	RANK() OVER (ORDER BY actor_avg_rating DESC) AS actor_rank
FROM top_actor_summary;


-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
-- Ans: Make cte for calculating their weighted average by filtering required conditions and then rank on their weighted average.

WITH top_actress_summary AS
	(SELECT name AS actress_name,
		total_votes, COUNT(r.movie_id) AS movie_count,
		ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actress_avg_rating
	FROM movie m
		INNER JOIN ratings r ON m.id = r.movie_id
		INNER JOIN role_mapping rm ON m.id = rm.movie_id
		INNER JOIN names n ON rm.name_id = n.id
	WHERE country = 'india' AND category = 'actress' AND languages LIKE '%hindi%'
    GROUP BY name
    HAVING movie_count >= 3)
SELECT *,
	ROW_NUMBER() OVER (ORDER BY actress_avg_rating DESC) AS actress_rank
FROM top_actress_summary
LIMIT 5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
-- Ans: Case statement can be used to classify the avg rating in following category and filtering on genre = thriller.

WITH thriller_movie_summary AS (
	SELECT DISTINCT(title), avg_rating
	FROM movie m 
		INNER JOIN ratings r ON m.id = r.movie_id
		INNER JOIN genre g USING (movie_id)
	WHERE genre = 'thriller')
SELECT *,
	CASE WHEN avg_rating > 8 THEN 'Superhit movies'
    WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
    WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
    ELSE 'Flop movies'
    END AS avg_rating_category
FROM thriller_movie_summary;


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
-- Ans: Using FRAMES we can get running total duration and moving average of avg duration of each genre.

SELECT genre,
	ROUND(AVG(duration)) AS avg_duration,
    SUM(ROUND(AVG(duration), 1)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
    AVG(ROUND(AVG(duration), 2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS moving_avg_duration
FROM movie m
	INNER JOIN genre g
	ON m.id = g.movie_id
GROUP BY genre;

/* Output table:
+---------+---------------+--------------------------+----------------------+
|genre	  |	avg_duration  |	running_total_duration	 |	moving_avg_duration |
+---------+---------------+--------------------------+----------------------+
|Action	  |		113		  |			112.9			 |		112.880000		|
|Adventure|		102		  |			214.8			 |		107.375000		|
|Comedy	  |		103		  |			317.4			 |		105.790000		|
|Crime	  |		107		  |			424.5			 |		106.105000		|
|Drama	  |		107		  |			531.3			 |		106.238000		|
|Family	  |		101		  |			632.3			 |		105.360000		|
|Fantasy  |		105		  |			737.4			 |		105.328571		|
|Horror	  |		93		  |			830.1			 |		103.752500		|
|Mystery  |		102		  |			931.9			 |		103.535556		|
|Others	  |		100		  |			1032.1			 |		103.198000		|
|Romance  |		110		  |			1141.6			 |		103.773636		|
|Sci-Fi	  |		98		  |			1239.5			 |		102.415455		|
|Thriller |		102		  |			1341.1			 |		102.389091		|
+---------+---------------+--------------------------+----------------------+  */
-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
/* Ans: Make cte for top 3 genre by ranking them on movies count of each genre. Replace $ and INR with blanks. RANK top movies
on worldwide gross income and join genre cte for getting top 5 movies which belong to top 3 genre. */

WITH top_genre_summary AS (
	SELECT genre, COUNT(g.movie_id) as number_of_movies,
		RANK() OVER(ORDER BY COUNT(g.movie_id) DESC) AS genre_rank
	FROM genre g
		INNER JOIN movie m ON g.movie_id = m.id
        INNER JOIN ratings r ON g.movie_id = r.movie_id
	GROUP BY genre
	LIMIT 3),
top_movies_summary AS (
SELECT genre, year, title AS movie_name,
	CAST(REPLACE(REPLACE(IFNULL(worlwide_gross_income, 0), 'INR',''), '$', '') AS DECIMAL(10)) AS worldwide_gross_income,
	DENSE_RANK() OVER(PARTITION BY year 
				ORDER BY CAST(REPLACE(REPLACE(IFNULL(worlwide_gross_income, 0), 'INR',''), '$', '') AS DECIMAL(10)) DESC) AS movie_rank
FROM genre g
		INNER JOIN movie m ON g.movie_id = m.id
WHERE genre IN (SELECT genre FROM top_genre_summary)
)
SELECT *
FROM top_movies_summary
WHERE movie_rank <= 5
ORDER BY year;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
-- Ans: RANK production house on number of movies with median rating >= 8and Use POSITION(,) for filtering multilingual movies.

SELECT production_company,
	COUNT(movie_id) AS movie_count,
    RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS prod_comp_rank
FROM ratings r
	INNER JOIN movie m ON r.movie_id = m.id
WHERE median_rating >= 8 AND
	production_company IS NOT NULL AND
    POSITION(',' IN languages) > 0
GROUP BY production_company
LIMIT 2;


-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
-- Ans: Calculate weighted average of actress and RANK on movies with avg rating > 8 in drama genre.

WITH top_actress_summary AS 
	(SELECT name AS actress_name, SUM(total_votes) AS total_votes,
		COUNT(rm.movie_id) AS movie_count,
		ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actress_avg_rating,
		DENSE_RANK() OVER(ORDER BY avg_rating DESC) AS actress_rank
	FROM role_mapping rm
		INNER JOIN names n ON rm.name_id = n.id
		INNER JOIN ratings r USING (movie_id)
		INNER JOIN genre g USING (movie_id)
	WHERE category = 'actress' AND avg_rating > 8
		AND genre= 'drama'
	GROUP BY name)
SELECT *
FROM top_actress_summary
WHERE actress_rank <= 3;


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
/* Ans: LEAD function is used for calculating inter_date_published and the DATEDIFF function for date diff.
AVG of date_diff is used to calculate inter movies days. to find top directors.*/

WITH inter_duration_summary AS (
	SELECT name_id, name, movie_id, avg_rating, total_votes, duration, date_published,
		LEAD(date_published, 1) OVER(PARTITION BY name_id ORDER BY date_published, movie_id) AS inter_date_published
	FROM director_mapping d
		INNER JOIN names n ON d.name_id = n.id
		INNER JOIN ratings r USING (movie_id)
		INNER JOIN movie m ON d.movie_id = m.id),
director_summary AS (
	SELECT *, DATEDIFF(inter_date_published, date_published) AS date_diff
	FROM inter_duration_summary)
SELECT name_id AS director_id,
	name AS director_name,
    COUNT(movie_id) AS number_of_movies,
    ROUND(AVG(date_diff)) AS avg_inter_movie_days,
    ROUND(AVG(avg_rating), 2) AS avg_rating,
    SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration
FROM director_summary
GROUP BY name_id
ORDER BY number_of_movies DESC
LIMIT 9;
