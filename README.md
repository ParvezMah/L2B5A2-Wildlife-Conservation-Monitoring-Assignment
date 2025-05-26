## 3. Primary Key and Foreign Key in PostgreSQL

In PostgreSQL, a **Primary Key** uniquely identifies each record in a table. It must be unique and not null. For example, in a `users` table, the `id` column is typically the primary key.

A `Forein Key` is a column that links to the primary key of another table, establishing a relationship between the two tables For Example, `orders.user_id` might reference `users.id`.

These keys enforce **referencial integrity:**
- Prevent duplicate or orphaned records.
- Keep relationships accurate and consistent.

Primary Key and Foreign Key are fundamental to designing relational databases.


## 4. Difference Between VARCHAR and CHAR in PostgreSQL

Both `VARCHAR()` and `CHAR()` store text, but behave differently:
- VARCHAR() : Stores variable-length strings up to that number inside brackets. Efficient Data of unpredictable length.
- CHAR() : Always stores fixed-length strings. If the input is shorter, it's padded with spaces.

Example:
```
VARCHAR(10): 'cat' -> stored as 'cat'
CHAR(10): 'cat' -> stored as 'cat_______"
```
User `VARCHAR` for most text fields. **Use** `CHAR` when all entries have the same length (like fixed-length codes).



## 5. Purpose of WHERE Clause in SELECT

The **WHERE** clause filters records in a query based on specific conditions.

Example:
```
SELECT * FROM products WHERE price > 100;
```

This returns only products that cost more than 100.

You can use: 
- `=`, `>`, `<`, `!=`, `IN`, `LIKE`, `BETWEEN`.
- Logical Operators: `AND`, `OR`, `NOT`,

**WHERE** helps you extract meaningful data without fethcing the entire table. It's essential for performance and accuracy in SQL queries.

## 6. LIMIT and OFFSET in PostgreSQL

The `LIMIT` and `OFFSET` clauses control how many rows are returned and where to start.
- `LIMIT` : Restricts the numbers of rows returned.
- `OFFSET` : Skips a number of rows before returning results.

Example:
```
SELECT * FROM products ORDER BY id LIMIT 10 OFFSET 20;
```

This returns 10 pruducts starting from the 21st.
Commonly used in **pagination** (e.g, displaying 10 ites per page)


## 8. Significance of JOIN and How it Works

A **JOIN** combines rows from two or more tables basen on a related column.

Example:
```
SELECT orders.id, users.name
FROM orders
JOIN users ON orders.user_id = users.id;
```

Types of JOINs:
- **INNER JOIN** : Only matching rows.
- **LEFT JOIN** : All from left table + matching right rows.
- **RIGHT JOIN** : All from right table + matchign left rows
- **FULL JOIN** : All rows from both, matched or not.
