USE ecommerce;

-- 1.What are the top 10 countries with the highest number of buyers and sellers combined on the ecommerce platform?

WITH CombinedTransactions AS (
    SELECT Country, COUNT(Product_bought) AS Buyers, COUNT(Product_sold) AS Sellers
    FROM users_data
    WHERE Product_bought >= 1 OR Product_sold >= 1
    GROUP BY Country
)

SELECT Country, Buyers + Sellers AS Total_Transactions
FROM CombinedTransactions
ORDER BY Total_Transactions DESC
LIMIT 10;

-- 2. Which countries and genders are the most engaged with the ecommerce platform in terms of social followers and follows?
SELECT Country, AVG(Social_Followers) AS AvgSocialFollowers, AVG(Social_Follows) AS AvgSocialFollows
FROM users_data
GROUP BY Country
ORDER BY AvgSocialFollowers DESC
LIMIT 10;

-- 3.Which countries have users who have made transactions on the ecommerce platform and also have the Android app installed?
SELECT u.Country, COUNT(*) AS NumUsers
FROM users_data u
WHERE (u.Product_sold >= 1 OR u.Product_bought >= 1)
AND u.Has_AndroidApp = 'True'
GROUP BY u.Country;


-- 4.How many users from each country have not logged in since the last 100 days, and how many of them have a profile picture?
WITH InactiveUsers AS (
    SELECT country, 
           SUM(CASE WHEN Days_SinceLastLogin >= 100 THEN 1 ELSE 0 END) AS InactiveUsersCount,
           SUM(CASE WHEN Days_SinceLastLogin >= 100 AND Has_ProfilePicture = 'True' THEN 1 ELSE 0 END) AS InactiveUsersWithProfilePicCount
    FROM users_data
    GROUP BY Country
)

SELECT Country, InactiveUsersCount, InactiveUsersWithProfilePicCount
FROM InactiveUsers;

-- 5.What is the average number of products bought by male and female users for each country?
SELECT u.Country, u.Gender,AVG(u.Product_bought) AS AvgProductsBought
FROM users_data u
WHERE u.Product_bought >= 1
GROUP BY u.Country, u.Gender;



