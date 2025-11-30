create database nutrition 
-- Search Function (Meals Conatins Chicken)
SELECT "Food", "Category"
FROM "nutrition_cf - Sheet5"
WHERE Food LIKE '%Chicken%';
-- Top 5 meals With kcal and Proteins units where Proteins >20
SELECT top 5 "Food", "Proteins", "Energy_kcal"
FROM "nutrition_cf - Sheet5"
WHERE Proteins > 20
ORDER BY Proteins DESC
--Number of meals in each category 
SELECT "Category", COUNT(*) as Count
FROM "nutrition_cf - Sheet5"
GROUP BY Category;
--Types Of Allergies 
SELECT DISTINCT Allergy 
FROM "nutrition_cf - Sheet5";
--Avg vs Max and Min kcal 
SELECT 
    MIN("Energy_kcal") as Min_Calories, 
    MAX("Energy_kcal") as Max_Calories, 
    AVG("Energy_kcal") as Avg_Calories 
FROM "nutrition_cf - Sheet5";
--TOP 5 meals of carbon foodprint percentage 
SELECT Top 5 "Food", "Carbon Foodprint"
FROM "nutrition_cf - Sheet5"
ORDER BY "Carbon Foodprint" DESC 
--Meals With Protein and fats units where Proteins >15
SELECT Food, Proteins, Fats 
FROM  "nutrition_cf - Sheet5"
WHERE Proteins > 15 AND Fats < 5;
-- meals with ingredients contain Paneer>
SELECT Food, Ingredients 
FROM "nutrition_cf - Sheet5"
WHERE Ingredients LIKE '%Paneer%';
-- Meals with kcal and level of kcal 
SELECT Food, "Energy_kcal",
    CASE
        WHEN "Energy_kcal" > 500 THEN 'High Calorie'
        WHEN "Energy_kcal" BETWEEN 200 AND 500 THEN 'Medium Calorie'
        ELSE 'Low Calorie'
    END AS Calorie_Category
FROM "nutrition_cf - Sheet5";
--identify and rank high-protein foods.
SELECT Food, Proteins
FROM "nutrition_cf - Sheet5"
WHERE Proteins > (SELECT AVG(Proteins) FROM "nutrition_cf - Sheet5")
ORDER BY Proteins DESC;
--filter for specific regional meals.
SELECT Food, Region, Type
FROM "nutrition_cf - Sheet5"
WHERE Region IN ('North', 'South') 
  AND Type IN ('Breakfast', 'Dinner');

--AVG of carbon foodprint for each category 
SELECT Category, AVG("Carbon Foodprint") as Avg_Carbon
FROM "nutrition_cf - Sheet5"
GROUP BY Category
HAVING AVG("Carbon Foodprint") > 0.5;
--meals wihh its category 
SELECT CONCAT(Food, ' is a ', Type, ' dish (', Category, ')') as Description
FROM "nutrition_cf - Sheet5";
--meals with its Allergies 
SELECT Food, Allergy
FROM "nutrition_cf - Sheet5"
WHERE Allergy NOT LIKE '%soy%' 
  AND Allergy NOT LIKE '%dairy%';
--Categories vs its Total items and Avg calories ft carbon foodprint 
SELECT Category,
       COUNT(*) as Total_Items,
       ROUND(AVG("Energy_kcal"), 0) as Avg_Calories,
       ROUND(AVG("Carbon Foodprint"), 2) as Avg_Carbon_Footprint
FROM "nutrition_cf - Sheet5"
GROUP BY Category;
--Top high protein meal vs high fiber meal
SELECT top 2 Food, 'High Protein' as Tag, Proteins as Value
FROM "nutrition_cf - Sheet5"
ORDER BY Proteins DESC
SELECT top 2 Food, 'High Fiber' as Tag, Fiber as Value
FROM "nutrition_cf - Sheet5"
ORDER BY Fiber DESC
--Update rows
UPDATE "nutrition_cf - Sheet5"
SET Region = 'South, North' 
WHERE Food = 'Upma';
--Delete Rows 
DELETE FROM "nutrition_cf - Sheet5"
WHERE Food = 'Upma';
-- meals with kcal units between 300 and 350
SELECT Food, "Energy_kcal"
FROM "nutrition_cf - Sheet5"
WHERE "Energy_kcal" BETWEEN 300 AND 350;
--Meals With each categories and calories 
SELECT Category, Food, "Energy_kcal"
FROM "nutrition_cf - Sheet5" n1
WHERE "Energy_kcal" > (
    SELECT AVG("Energy_kcal")
    FROM "nutrition_cf - Sheet5" n2
    WHERE n1.Category = n2.Category
)
ORDER BY Category, "Energy_kcal" DESC;

-- higlight the category with upper case and it's type with lower one 
SELECT Food, 
       UPPER(Category) as CATEGORY_CAPS, 
       LOWER(Type) as type_lower
FROM "nutrition_cf - Sheet5"
-- Meals with its allergies status 
SELECT Food, COALESCE(Allergy, 'Safe/No Info') as Allergy_Status
FROM "nutrition_cf - Sheet5";

--top 5 food items that have a higher protein content than their category's average, but a lower carbon footprint than their category's average.
WITH Category_Stats AS (
    SELECT Category,
           AVG(Proteins) as Avg_Pro,
           AVG("Carbon Foodprint") as Avg_Carb
    FROM "nutrition_cf - Sheet5"
    GROUP BY Category
)
SELECT top 5 n.Food, n.Category, n.Proteins
FROM "nutrition_cf - Sheet5" n
JOIN Category_Stats s ON n.Category = s.Category
WHERE n.Proteins > s.Avg_Pro
  AND n."Carbon Foodprint" < s.Avg_Carb
ORDER BY n.Proteins DESC

