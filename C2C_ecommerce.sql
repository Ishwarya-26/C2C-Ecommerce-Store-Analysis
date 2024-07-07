USE e_commerce;

-- 1. Top 10 countries with the highest number of buyers and sellers combined
WITH CombinedTransactions AS (
    SELECT Country, 
           COUNT(Product_bought) AS Buyers, 
           COUNT(Product_sold) AS Sellers
    FROM users_data
    WHERE Product_bought >= 1 OR Product_sold >= 1
    GROUP BY Country
)
SELECT Country, (Buyers + Sellers) AS Total_Transactions
FROM CombinedTransactions
ORDER BY Total_Transactions DESC
LIMIT 10;

-- 2. Countries with highest average social engagement
SELECT Country, 
       ROUND(AVG(Social_Followers)) AS AvgSocialFollowers, 
       ROUND(AVG(Social_Follows)) AS AvgSocialFollows
FROM users_data
GROUP BY Country
ORDER BY AvgSocialFollowers DESC
LIMIT 10;

-- 3. Countries with users who have made transactions and have the Android app installed
SELECT u.Country, COUNT(*) AS Total_Users
FROM users_data u
WHERE (u.Product_sold >= 1 OR u.Product_bought >= 1)
AND u.Has_AndroidApp = 'True'
GROUP BY u.Country
ORDER BY Total_Users DESC
LIMIT 10;

-- 4. Users from each country who have not logged in since the last 100 days and have a profile picture
WITH InactiveUsers AS (
    SELECT country, 
           SUM(CASE WHEN Days_SinceLastLogin >= 100 THEN 1 ELSE 0 END) AS InactiveUsersCount,
           SUM(CASE WHEN Days_SinceLastLogin >= 100 AND Has_ProfilePicture = 'True' THEN 1 ELSE 0 END) AS InactiveUsersWithProfilePicCount
    FROM users_data
    GROUP BY Country
)
SELECT Country, InactiveUsersCount, InactiveUsersWithProfilePicCount
FROM InactiveUsers
ORDER BY InactiveUsersCount DESC
LIMIT 10;

-- 5. Average number of products bought by male and female users for each country
SELECT u.Country, u.Gender, AVG(u.Product_bought) AS AvgProductsBought
FROM users_data u
WHERE u.Product_bought >= 1
GROUP BY u.Country, u.Gender
ORDER BY AvgProductsBought DESC
LIMIT 10;
