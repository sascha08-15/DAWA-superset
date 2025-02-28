# Datawarehousing Queries using PostgreSQL

## Creating a simple schema for sales of products

```sql
-- Delete existing table sales
DROP TABLE IF EXISTS public.sales;

-- Create sales Table
CREATE TABLE public.sales (
    id SERIAL PRIMARY KEY,
    region TEXT,
    category TEXT,
    product TEXT,
    sales_amount NUMERIC,
    sales_date DATE
);
```

## Loading sample data

```sql
-- Load sample data
INSERT INTO public.sales (region, category, product, sales_amount, sales_date) VALUES
('North', 'Electronics', 'Laptop', 500, '2024-01-01'),
('North', 'Electronics', 'Laptop', 700, '2024-01-02'),
('North', 'Electronics', 'Mobile', 300, '2024-01-03'),
('North', 'Furniture', 'Chair', 150, '2024-01-04'),
('South', 'Electronics', 'Laptop', 600, '2024-01-05'),
('South', 'Furniture', 'Table', 250, '2024-01-06'),
('South', 'Furniture', 'Chair', 200, '2024-01-07'),
('East', 'Electronics', 'Mobile', 400, '2024-01-08'),
('East', 'Furniture', 'Table', 300, '2024-01-09'),
('West', 'Electronics', 'Laptop', 800, '2024-01-10'),
('West', 'Electronics', 'Mobile', 350, '2024-01-11'),
('West', 'Furniture', 'Chair', 100, '2024-01-12');
```
Sample data automatically inserted with a new ID as it is a serial primary key.

## Group By (Cube) Extension:
```sql
-- Using Group By Extension
SELECT region, category, product, SUM(sales_amount) AS total_sales
FROM sales
GROUP BY CUBE(region, category, product)
ORDER BY region NULLS LAST, category NULLS LAST, product NULLS LAST;
```

**Explanation**
* CUBE generates subtotals for all possible combinations of region, category, and product. It includes:
    * Grand total (no grouping columns)
    * Region-level totals
    * Category-level totals
    * Product-level totals
    * Region + Category totals
    * Region + Product totals
    * Category + Product totals
    * Fully detailed breakdown

## Roll-up Extension
        

```sql
-- Using Roll-up Extension 
SELECT region, category, product, SUM(sales_amount) AS total_sales
FROM sales
GROUP BY ROLLUP(region, category, product)
ORDER BY region NULLS LAST, category NULLS LAST, product NULLS LAST;
```

**Explanation**
* ROLLUP aggregates in a hierarchical fashion:
    * Full breakdown (region → category → product)
	* Region + Category totals
	* Region totals
	* Grand total
	* No category + product combinations (unlike CUBE).

```sql
SELECT region, category, SUM(sales_amount) AS total_sales
FROM sales
GROUP BY GROUPING SETS ((region, category), (category), ())
ORDER BY region NULLS LAST, category NULLS LAST;
```

**Explanation**
* GROUPING SETS allows custom aggregations:
    * `(region, category)`: Total sales per region-category pair
	* `(category)`: Total sales per category
	* `()`: Grand total
* No unnecessary combinations (more efficient than CUBE).

```sql
SELECT 
    region, category, product,
    SUM(sales_amount) AS total_sales,
    GROUPING(region) AS is_region_grouped,
    GROUPING(category) AS is_category_grouped,
    GROUPING(product) AS is_product_grouped
FROM sales
GROUP BY CUBE(region, category, product)
ORDER BY region NULLS LAST, category NULLS LAST, product NULLS LAST;
```

**Explanation**
* GROUPING() helps identify which columns are aggregated:
    * 0 → Value is present (not aggregated).
    * 1 → Value is aggregated (NULL in output).