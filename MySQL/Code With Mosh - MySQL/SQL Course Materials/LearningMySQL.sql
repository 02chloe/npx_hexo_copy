-- https://www.bilibili.com/video/BV1UE41147KC?p=53&spm_id_from=pageDriver&vd_source=8c95a6f84c23d3715a394fdbd701bad4 
-- 视频链接
-- 设计模式： 🔧符号


USE sql_store;
-- 选中数据库

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Chapter 2
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- -- -- -- -- -- -- -- -- -- -- -- 
-- 2.1	SELECT
-- 顺序很重要
 SELECT * 
FROM customers 
WHERE customer_id < 8 
ORDER BY city
LIMIT 10;    
-- 从FROM某个表中选择SELECT全部或多个columns,满足where怎样的条件,按照哪一列进行排序Order by
-- 	逻辑：AND OR NOT（not用在条件之前）

-- -- -- -- -- -- -- -- -- -- -- -- 
-- 2.5	IN 运算符
-- 记得括号
SELECT *
FROM Customers
WHERE State IN ('VA','FL','GA');

SELECT *
FROM PRODUCTS
WHERE QUANTITY_IN_STOCK IN (49,38,72);

-- -- -- -- -- -- -- -- -- -- -- -- 
-- 2.6	BETWEEN 运算符
-- 包含临界值
SELECT *
FROM CUSTOMERS
WHERE POINTS BETWEEN 1000 AND 3000;

SELECT * 
FROM CUSTOMERS
WHERE BIRTH_DATE BETWEEN '1990-01-01' AND '2000-01-01';
-- BETWEEN AND 用于日期时记得加引号 

-- -- -- -- -- -- -- -- -- -- -- -- 
-- 2.7	LIKE 运算符
-- LIKE选取具有某种特定格式的字符串，不区分大小写

SELECT * 
FROM customers 
WHERE birth_date LIKE '%9%8%0%' ;
-- '%'表示任何值(0个或者多个)
-- '_'表示一个任意字符

SELECT * 
FROM customers 
WHERE address LIKE '%traiL%' OR ADDRESS LIKE '%AVENUE%';

SELECT * 
FROM customers 
WHERE PHONE NOT LIKE '%9' ;
-- 注意not用在like之前

-- -- -- -- -- -- -- -- -- -- -- -- 
-- 2.8	REGEXP 正则表达式（regular expression）

SELECT * 
FROM customers 
-- WHERE address LIKE '%traiL%' 
WHERE address REGEXP 'TRAIL'; -- 和上面语句效果一样
-- ^a 表示以a为开头
-- a$ 表示以a为结尾
-- a|b|c 表示包含a或者b或者c
-- [abcde][a-e] 中的内容表示选项，是或的关系；[abc]d:ad或bd或cd

SELECT *
FROM CUSTOMERS
-- WHERE FIRST_NAME REGEXP 'ELKA|AMBUR';
-- WHERE LAST_NAME REGEXP 'EY$|ON$';
-- WHERE  LAST_NAME REGEXP '^MY|SE';
-- WHERE LAST_NAME REGEXP 'B[RU]';
WHERE LAST_NAME REGEXP 'BR|BU';  -- 与上一句同结果

-- -- -- -- -- -- -- -- -- -- -- -- 
-- 2.9	Null空值

SELECT *
FROM CUSTOMERS
-- WHERE PHONE IS NULL;
WHERE PHONE IS NOT NULL;

-- 查找orders that are not shipped
SELECT *
FROM ORDERS
WHERE SHIPPED_DATE IS NULL;

-- -- -- -- -- -- -- -- -- -- -- -- 
-- 2.10	ORDER BY 排序

SELECT * 
FROM CUSTOMERS
ORDER BY state,phone DESC;
-- 可以对多个列排序，优先级按照顺序
-- DESC是倒序排列，每个需要排列的列必须单独声明

SELECT FIRST_NAME,LAST_NAME,10 AS POINTS
FROM CUSTOMERS
ORDER BY POINTS DESC;
-- 即使不在select范围内的column也可以用来排序（只针对MySQL）order_itemsorder_itemsorder_items
-- 可以指定排序列的序号，但是非常不推荐使用

SELECT *, UNIT_PRICE*QUANTITY AS TOTAL_PRICE
FROM ORDER_ITEMS
WHERE ORDER_ID = 2
ORDER BY total_price DESC;

-- -- -- -- -- -- -- -- -- -- -- -- 
-- 2.11	LIMIT clause子句
-- 永远放最后

SELECT * 
FROM CUSTOMERS
LIMIT 3; -- 选前三行
-- LIMIT 6,3; -- 偏移量6，选三行，排除前6行，选出第7-9行   

SELECT * 
FROM CUSTOMERS
ORDER BY POINTS DESC
LIMIT 3;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Chapter 3
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- -- -- -- -- -- -- -- -- -- -- -- 
-- 3.1	INNER JOIN 内连接	在多张表格中检索数据
-- INNER可省略写成：JOIN

SELECT order_id, o.customer_id, first_name, last_name
FROM orders o		-- 给表格重命名以方便引用
JOIN customers c	-- 给表格重命名以方便引用
	ON o.customer_id = c.customer_id;   
    
SELECT  order_id, oi.product_id,quantity,name,oi.unit_price
FROM order_items oi
JOIN products p
	ON oi.product_id = p.product_id;
    
-- -- -- -- -- -- -- -- -- -- -- -- 
-- 3.2	跨数据库连接

-- 尝试连接sql_inventory的products表和sql_store的order_items表
-- 记得给不在当前数据库的表加上前缀，或者两者都加上前缀以防更改数据库
SELECT * 
FROM sql_store.order_items oi
JOIN sql_inventory.products p
	ON oi.product_id = p.product_id;
    
-- -- -- -- -- -- -- -- -- -- -- -- 
-- 3.3	自连接

USE sql_hr;
SELECT 
	e.employee_id, 
	e.first_name AS employee_name, 
	m.first_name AS manager
FROM employees e
JOIN employees m 	-- 自连接同一表格起不同的名字
	ON e.reports_to = m.employee_id;
    
-- -- -- -- -- -- -- -- -- -- -- -- 
-- 3.4	多表连接

USE sql_store;
SELECT 
	o.order_id,
    c.first_name,
	os.name AS status
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
JOIN order_statuses os
ON o.status = os.order_status_id;

USE sql_invoicing;
SELECT p.client_id, c.name,pm.name AS payment
FROM payments p
JOIN clients c  
	ON p.client_id = c.client_id
JOIN payment_methods pm
	ON pm.payment_method_id = p.payment_method ;
    
-- -- -- -- -- -- -- -- -- -- -- -- 
-- 3.5	复合连接条件 （连接复合主键表格）
-- 有时无法用单一列来进行唯一识别（即每一列都有重复），需要两列或以上相结合来唯一识别 
-- 打开设计模式，黄色🔑符号表示主键：primary key PK，连个以上PK表示复合主键。    

USE sql_store;
SELECT *
FROM order_items oi
JOIN order_item_notes oin
	ON oi.order_id = oin.order_id
    AND oi.product_id = oin.product_id;

-- -- -- -- -- -- -- -- -- -- -- -- 
-- 3.6	隐式连接语法

SELECT *
FROM ORDERS O, customers C 
WHERE O.customer_id = C.customer_id;

-- -- -- -- -- -- -- -- -- -- -- -- 
-- 3.7/8	外连接/多表外连接

-- LEFT JOHN 	以左侧表格条件为主（from后），右侧即使没有值也会返回
-- RIGHT JOHN	以右侧表格条件为主（john后），左侧即使没有值也会返回
-- 多个表格进行外连接时，最好使用left join，更容易理解，同时参考多表连接
SELECT O.order_id,C.customer_id
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id;

SELECT O.order_id,C.customer_id
FROM orders o
RIGHT JOIN customers c
ON o.customer_id = c.customer_id;

SELECT P.PRODUCT_ID, P.NAME, OI.QUANTITY,OIN.NOTE
FROM ORDER_ITEMS OI
LEFT JOIN products P
	ON P.product_id = OI.product_id
LEFT JOIN ORDER_ITEM_NOTES OIN
	ON OI.product_id = OIN.product_id
    AND OI.ORDER_ID = OIN.ORDER_ID;

-- -- -- -- -- -- -- -- -- -- -- -- 
-- 3.9	自外连接
-- 在自连接的基础上变成Left join
USE sql_hr;
SELECT 
	e.employee_id, 
	e.first_name AS employee_name, 
	m.first_name AS manager
FROM employees e
LEFT JOIN employees m 	-- 自连接同一表格起不同的名字
	ON e.reports_to = m.employee_id;
    
-- -- -- -- -- -- -- -- -- -- -- -- 
-- 3.10	USING 子句 clause
-- 用于被连接的表中主键名称（被连接的列）完全一致的情况,简化代码，增加可读性
-- 还可用于多个主键连接/复合主键连接，只需把所有PK都放在括号中并用逗号连接
-- 名称不一致时不能使用 
USE sql_store;
SELECT *
FROM orders o
JOIN customers c
	USING (customer_id)
LEFT JOIN shippers sh
	USING (shipper_id);

-- -- -- -- -- -- -- -- -- -- -- -- 
-- 3.11  自然连接 NATURAL JOIN
-- 让系统自动选择相同的列进行连接，不推荐使用,因为无法控制

SELECT *
FROM ORDERS O
NATURAL JOIN customers C ;

-- -- -- -- -- -- -- -- -- -- -- -- 
-- 3.12 交叉连接 cross join
-- 将1表的每条记录和2表的每条记录连接，即笛卡尔积
-- 用到交叉连接案例：一个型号表（大，中，小），一个颜色表（红，黄，蓝），想将所有型号和颜色组合

-- 显示语法：
SELECT *
FROM ORDERS O
CROSS JOIN customers C;

-- 隐示语法：
SELECT *
FROM ORDERS O,customers C;

-- -- -- -- -- -- -- -- -- -- -- -- 
-- 3.13 联合 UNION

-- 结合多张表的行
-- 第一个select定义的列名会作为结果显示的列名

-- 注意：该示例中包含增加列并赋值的方法
SELECT *, 'ACTIVE' AS STATUS
FROM orders
WHERE order_date >= '2019-01-01';

SELECT *, 'Archived' AS STATUS
FROM orders
WHERE order_date < '2019-01-01';

-- 用UNION合并上面两段筛选并赋值的语句，实现行的连接
SELECT *, 'ACTIVE' AS STATUS
FROM orders
WHERE order_date >= '2019-01-01'
UNION
SELECT *, 'Archived' AS STATUS
FROM orders
WHERE order_date < '2019-01-01';

-- 还可以连接来自不同表格的查询结果，只要保证列的数量一致
SELECT order_id,status,'orders' as form
FROM orders
UNION
SELECT first_name,last_name, 'customers' as form
FROM customers
ORDER BY STATUS;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Chapter 4
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 4.1 	列属性

-- 设计模式：
	-- PK：主键
    -- NN：可否为NULL（选中表示不可为NULL）
    -- AI：自动递增（通常为主键）
    -- default：默认值

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 4.2	插入单行 INSERT INTO
-- 主键PK，且AI选中时，会自动按照递增的顺序给PK赋予序号，可以不用赋值，或者default，
-- 插入又删除之后系统会保留删除的序号

-- INSERT INTO customers
-- VALUES (
-- 	DEFAULT,
--     'Benjamin',
--     'Hon',
--     '1988-04-01',
--     Null,
-- 	'address',
--     'city',
--     'tn',
-- 	default);

-- INSERT INTO customers (
-- 	first_name,last_name,birth_date,
--     address,city,state
-- )
-- VALUES (
--     'Benjamin',
--     'Hon',
--     '1988-04-01',
-- 	'address',
--     'city',
--     'tn'
-- 	);   
  

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 4.3	插入多行 INSERT INTO

-- INSERT INTO shippers (name)
-- VALUES 	('BEN1'),
-- 		('BEN2'),
--         ('BEN3');

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 4.4	插入分层行（向多表中插入行）

-- Fuction：Last_insert_id	返回插入新行时自动生成的id

-- INSERT INTO orders (customer_id,order_date,status)
-- VALUES (1,'1988-04-01',1);

-- INSERT INTO order_items
-- VALUES (last_insert_id(),2,2,2.95),
-- 		(last_insert_id(),3,3,2.95),
--         (last_insert_id(),4,4,2.95);


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 4.5	创建表复制
-- CREATE TABLE AS	+	SELECT子查询
-- INSERT INTO	+	SELECT子查询

-- 复制orders表所有内容，创建新表格
-- 但是系统不会自动定义主键PK，也不会设置AI

-- CREATE TABLE orders_archive AS
-- SELECT * 
-- FROM orders;	-- 子查询语句

-- 子查询和 insert 相结合：

-- INSERT INTO orders_archive
-- SELECT *
-- FROM orders
-- WHERE order_id < 5;

-- USE sql_invoicing;
-- CREATE TABLE invoices_archive AS
-- SELECT 
-- 	i.invoice_id,
--     i.number,
--     c.name AS client,
--     i.invoice_total,
--     i.payment_total,
--     i.invoice_date,
--     i.due_date,
--     i.payment_date
-- FROM INVOICES i	
-- JOIN clients c
-- 	ON i.client_id = c.client_id
-- WHERE payment_date IS NOT NULL;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 4.6	更新单行
-- UPDATE + SET(指定一列/多列的新值)
-- 还可以用计算公式来赋值
-- USE sql_invoicing;
-- UPDATE INVOICES
-- SET 
-- 	payment_total = invoice_total * 0.5,
--     payment_date = '3000-01-01'
-- WHERE invoice_id = 3;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 4.7	更新多行

-- UPDATE INVOICES
-- SET 
-- 	payment_total = invoice_total * 0.5,
--     payment_date = '3000-01-01'
-- WHERE client_id IN (3,4);

-- USE sql_store;
-- UPDATE customers
-- SET points = points+50
-- WHERE birth_date <'1990-01-01';

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 4.8 在UPDATE中使用子查询

-- 将select作为where的条件，当select结果为一条时使用‘=’，如果结果为多条，要使用“invoice_id IN 。。。”
-- 在执行UPDATE语句前，最好先用select from+where检查结果是否为希望更新的数据，防止错误更新。
-- 更新多行时需要取消reference中SQL editor中的safe模式，才不会报错

-- USE sql_invoicing;
-- UPDATE INVOICES
-- SET 
-- 	payment_total = invoice_total * 0.5,
--     payment_date = due_date
-- WHERE invoice_id = 
-- 		(SELECT client_id
-- 		FROM clients
-- 		WHERE name = "Myworks");
--         

-- UPDATE INVOICES
-- SET 
-- 	payment_total = invoice_total * 0.5,
--     payment_date = due_date
-- WHERE invoice_id IN 
-- 		(SELECT client_id
-- 		FROM clients
-- 		WHERE state IN ('CA','NY'));

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 4.9 删除行
-- DELETE FROM 执行该语句要非常小心，不加where语句的话会删掉表内所有数据

-- DELETE FROM invoices
-- WHERE client_id =
-- 	(SELECT CLIENT_ID
--     FROM CLIENTS
--     WHERE NAME='MYWORK');
    
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 4.10	恢复数据库
-- SQL菜单file选项-Open SQL script-到达储存脚本的位置-打开create-databases.sql文件，重新创建database


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Chapter 5
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 5.1	聚合函数	Aggregate Function

-- 取系列值并聚合，导出一个单一值，注意⚠️只运行非空值
-- MIN(), MAX(), AVG(), SUM(), COUNT()
-- 聚合函数括号内也可以使用计算公式
-- 默认聚合函数会取到所有重复值，如果不想取重复值，要加上 DISTINCT

SELECT 
	MAX(payment_date) AS highest,	-- 对日期取最大值的到最后的日期
    MIN(invoice_total) AS lowest,
    AVG(invoice_total * 2.5) AS average,
    COUNT(payment_date) AS count_of_payments,	-- null不计入总数
    COUNT(*) AS total_records,					-- 想要计算总数时使用*
    COUNT(CLIENT_ID) AS CLIENT_records,							-- 取重复值
    COUNT(DISTINCT CLIENT_ID) AS DIFFERENT_CLIENT_records		-- 只取不重复的值
FROM invoices
WHERE INVOICE_DATE > '2019-07-01';

SELECT
	'FIRST HALF OF 2019' AS 'DATA_RANGE',
    SUM(invoice_total) AS 'TOTAL_SALES',
    SUM(PAYMENT_TOTAL) AS 'TOTAL_PAYMENTS',
    SUM(INVOICE_TOTAL - PAYMENT_TOTAL) AS 'EXPECT'
FROM invoices
WHERE invoice_date BETWEEN '2019-01-01' AND '2019-06-30'
UNION
SELECT
	'SECOND HALF OF 2019' AS 'DATA_RANGE',
    SUM(invoice_total) AS 'TOTAL_SALES',
    SUM(PAYMENT_TOTAL) AS 'TOTAL_PAYMENTS',
    SUM(INVOICE_TOTAL - PAYMENT_TOTAL) AS 'EXPECT'
FROM invoices
WHERE invoice_date BETWEEN '2019-07-01' AND '2019-12-31'
UNION
SELECT
	'2019' AS 'DATA_RANGE',
    SUM(invoice_total) AS 'TOTAL_SALES',
    SUM(PAYMENT_TOTAL) AS 'TOTAL_PAYMENTS',
    SUM(INVOICE_TOTAL - PAYMENT_TOTAL) AS 'EXPECT'
FROM invoices
WHERE invoice_date BETWEEN '2019-01-01' AND '2019-12-31';

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 5.2 GROUP BY CLAUSE 子句
-- 分组并使用聚合函数，可以计算每组的sum，max等值
-- 注意排序，GROUP BY永远在from，where之后，在order by之前

SELECT 
	client_id AS CLIENT,
	sum(INVOICE_TOTAL) AS TOTAL_SALES,
    COUNT(INVOICE_TOTAL) AS INVOICE_NUM
FROM invoices
WHERE 'INVOICE_DATE' > '2018-01-01'
GROUP BY client_id
ORDER BY TOTAL_SALES DESC;

-- 多个分组：
SELECT 
    STATE,
    CITY,
	sum(INVOICE_TOTAL) AS TOTAL_SALES,
    COUNT(INVOICE_TOTAL) AS INVOICE_NUM
FROM invoices i
JOIN CLIENTS c
	ON I.client_id = C.client_id
GROUP BY STATE, CITY;

SELECT 
	p.date AS date,
    pm.name AS payment_method,
    SUM(p.amount) AS TOTAL_PAYMENT
FROM payments p
JOIN payment_methods pm
ON p.payment_method = pm.payment_method_id
GROUP BY date,payment_method
ORDER BY date;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 5.3	HAVING CLAUSE 子句
-- 用于在分组之后对结果进行筛选，因为在group by之前加where搜索不到分组后聚合函数的结果。
-- 即 WHERE 用于 group by 之前筛选，HACVING 用于 group by 之后筛选
-- HAVING 所接的条件必须包含在select中，即使包含在from表中也不行

SELECT 
	client_id AS CLIENT,
	sum(INVOICE_TOTAL) AS TOTAL_SALES,
    COUNT(INVOICE_TOTAL) AS INVOICE_NUM
FROM invoices
GROUP BY client_id
HAVING TOTAL_SALES > 500 AND INVOICE_NUM > 5;

SELECT 	
	c.customer_id,
    c.first_name,
    c.state,
    SUM(oi.quantity * oi.unit_price) AS amount
FROM customers c
JOIN orders o USING (customer_id)
JOIN order_items oi USING (order_id)
WHERE c.state IN ('VA','MA')
GROUP BY c.customer_id
HAVING amount > 100;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 5.4	ROLLUP 运算符
-- GROUP BY 之后加上 WITH ROLLUP，得到额外的一行，是聚合函数列的和/MAX/MIN

-- 单列分组：
SELECT 	
	order_id,
    COUNT(*) AS COUNT,
	MAX(unit_price) AS MAX,
	MIN(unit_price) AS MIN,
    SUM(quantity * unit_price) AS amount
FROM order_items
GROUP BY order_id WITH ROLLUP;

-- 多列分组：会返回整体结果和各个分支组的结果
SELECT 	
	order_id,
    product_id,
    COUNT(*) AS COUNT,
	MAX(unit_price) AS MAX,
	MIN(unit_price) AS MIN,
    SUM(quantity * unit_price) AS amount
FROM order_items
GROUP BY order_id,product_id WITH ROLLUP;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Chapter 6 复杂查询
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 6.2	子查询

SELECT *
FROM products
WHERE unit_price > (
	SELECT unit_price
    FROM products
    WHERE product_id = 3
);

SELECT *
FROM employees
WHERE salary > (
	SELECT AVG(salary) 
	FROM employees
);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 6.3	IN 运算符
-- 6.4 	子查询 & 连接
   
SELECT *
FROM product
WHERE product_id NOT IN (
	SELECT DISTINCT product_id
    FROM order_items
);
-- DISTINCT 函数对取值取唯一一个

-- 可以用 LEFT JOIN 实现完全一样的效果：
-- 在两种方式的选择时要注意可读性

SELECT *
FROM products P
LEFT JOIN order_items OI
USING (product_id)
WHERE order_id IS NULL;

SELECT DISTINCT customer_id,first_name,last_name
FROM customers
LEFT JOIN orders USING (customer_id)
LEFT JOIN order_items USING (order_id)
WHERE product_id = 3;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 6.5	ALL 关键字
-- ALL 表示后面（）内每一个
SELECT *
FROM invoices
WHERE invoice_total > ALL(
	SELECT invoice_total
    FROM invoices
    WHERE client_id = 3
);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 6.6	ANY 关键字
-- = ANY() 等价于 IN()

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 6.7	相关子查询
-- 子查询和外查询有相关性，引用外查询使用的别名
-- 相关子查询通常执行很慢，会占用很多存储
-- 类似于筛选条件中包含分组聚合函数相关的条件

-- 选择出超过部门平均工资的员工
SELECT *
FROM employees e
WHERE salary > (
	SELECT AVG(salary)
    FROM employees
    WHERE office_id = e.office_id
);
-- 选择每个客户超过他本人平均发票额的发票
SELECT *
FROM invoices i
WHERE invoice_total > (
	SELECT AVG(invoice_total)
    FROM invoices
    WHERE client_id = i.client_id
);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 6.8 EXISTS 运算符

-- 选出有发票的客户，可以使用先JOIN+筛选/IN+子查询
-- 可以用 EXISTS() 实现，只返回一个指令，确认是否有符合（）中条件的行，大大节省存储空间，加快速度

SELECT *
FROM clients c
WHERE EXISTS (
	SELECT client_id
    FROM invoices
    WHERE client_id = c.client_id
);

SELECT *
FROM clients c
WHERE NOT EXISTS (
	SELECT client_id
    FROM invoices
    WHERE client_id = c.client_id
);
 
SELECT *
FROM products p
WHERE NOT EXISTS (
	SELECT product_id
    FROM order_items
    WHERE product_id = p.product_id
);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 6.9 	SELECT 子句中的子查询

-- clients表格中选择每个客户的总金额-整体均值，得到差别
SELECT 
	client_id,
    name,
    (SELECT SUM(invoice_total)  -- 参考 6.7 相关子查询
		FROM invoices i
        WHERE i.client_id = c.client_id
	) AS total_sales,
    (SELECT AVG(invoice_total) FROM invoices i) AS average,
    (SELECT total_sales - average) AS Difference	-- 注意此处select无from
FROM clients c;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 6.9 	FROM 子句中的子查询
-- FROM之后不接具体的表格，而是一段查询结果

-- 直接引用上一节中结果：

SELECT *
FROM (
	SELECT 
		client_id,
		name,
		(SELECT SUM(invoice_total)  -- 参考 6.7 相关子查询
			FROM invoices i
			WHERE i.client_id = c.client_id
		) AS total_sales,
		(SELECT AVG(invoice_total) FROM invoices i) AS average,
		(SELECT total_sales - average) AS Difference	-- 注意此处select无from
	FROM clients c
) AS sales_summary;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Chapter 7 内置函数 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 7.1	数值函数 MySQL numeric functions
-- https://dev.mysql.com/doc/refman/8.0/en/numeric-functions.html

-- ROUND()四舍五入,括号后第二位可指定保留的小数位数
SELECT ROUND(3.64356, 1),ROUND(3.4573, 2),ROUND(3.5);

-- TRUNCATE()截断函数
SELECT TRUNCATE(3.64356, 1),TRUNCATE(3.4573, 2),TRUNCATE(3.5,2);

-- CEILING()返回不小于目标的最小整数，向上取整
-- FLOOR()向下取整

-- RAND()随机生成(0,1)小数


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 7.2	字符串函数	string function
-- https://dev.mysql.com/doc/refman/8.0/en/string-functions.html

-- LENGTH()得到字符串中的字符数
-- UPPER()字符串转大写
-- LOWER()字符串转小写
-- LTRIM()删除左侧空格/预定义字符
-- RTRIM()删除右侧空格/预定义字符
-- TRIM()删除两侧空格/预定义字符

SELECT TRIM('  SFG. F  DFG   ');

-- LEFT(,)返回左侧指定个数字符
-- RIGHT(,)
-- SUBSTRING(,,)指定位置(包含)，指定长度字符
-- LOCATE(‘p’,‘kindergarden’)返回指定字符/字符串在目标字符中第一次出现的位置，如果没有则返回0
-- REPLACE(目标字符,被替换字符,替代字符)

-- CONCAT()连接字符
USE SQL_STORE;
SELECT CONCAT(first_name,' ',last_name) AS full_name
FROM customers;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 7.3	日期函数
-- 7.4	格式化日期和时间	DATE_FORMATE(),TIME_FORMATE()
-- 7.5	计算日期和时间

-- DATE_FORMATE()
-- TIME_FORMATE()
-- https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html

-- NOW(), YEAR(NOW()), MONTH(NOW()), SECOND(NOW()),DAYNAME(), MONTHNAME()...
-- SELECT EXTRACT(YEAR FROM NOW())
-- CURDATE()
-- CURTIME()

SELECT *
FROM ORDERS
WHERE YEAR(order_date) = YEAR(NOW()) - 4;

-- DATE_ADD()增加日期,负数表示倒退-等同于DATE_SUB()
-- DATE_SUB()倒退
SELECT  
	DATE_ADD(NOW(), INTERVAL 1 MONTH),
    DATE_ADD(NOW(), INTERVAL 2 YEAR),
    DATE_ADD(NOW(), INTERVAL -3 DAY),
    DATE_SUB(NOW(), INTERVAL 3 DAY);

-- DATEDIFF()时间差
-- TIME TO SEC()	-- 把时间转化成秒数


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 7.6	IFNULL 和 COALESCE 函数
-- IFFULL(a,b) 用于给空值赋值,如果a是空值，则赋值b
-- COALESCE(A,B,C,D) 按顺序检查，返回第一个非空值

USE sql_store;
SELECT 
	order_id,
    IFNULL(shipper_id, 'not assinged') AS shipper
FROM orders
ORDER BY order_id;

SELECT 
    order_id,
    COALESCE(shipper_id,
            comments,
            SHIPPED_DATE,
            'not assinged') AS shipper
FROM
    orders
ORDER BY order_id;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 7.7	IF函数
-- IF(A,B,C)	二元判断，如果满足a则返回b否则返回c

SELECT
	order_id,
	IF(
    YEAR(ORDER_DATE)=YEAR(NOW())-4, 
    'ACTIVE', 
    'ARCHIVED') AS STATUS
FROM orders;

SELECT
	product_id,
    name,
    count(*) AS ORDERS_NUM,
    IF(count(*)>1,'MANY','ONCE') AS CATOGORY
FROM order_items oi
JOIN products
USING (product_id)
GROUP BY product_id;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 7.8	CASE运算符
-- CASE	+ WHEN + ELSE + END 多元判断

SELECT
	order_id,
	CASE
		WHEN YEAR(order_date) = YEAR(NOW())-4 THEN 'THIS YEAR'
        WHEN YEAR(order_date) = YEAR(NOW())-5 THEN 'LAST YEAR'
        ELSE 'BEFORE'
	END AS YEAR
FROM orders;



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Chapter 8 视图 VIEW
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 将查询或子查询存在视图中，来简化选择语句

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 8.1	创建视图VIEW

CREATE VIEW sales_by_client AS
SELECT
	c.client_id,
    c.name,
    SUM(INVOICE_TOTAL) AS TOTAL
FROM clients c
JOIN invoices i USING (client_id)
GROUP BY client_id;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 8.2	更改/删除视图
-- DROP VIEW 删除视图
-- CREATE OR REPLACE VIEW sales_by_client AS	替代视图

DROP VIEW sales_by_client;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 8.3	更新视图 UPDATE 用DELETE FROM/UPDATE SET
-- 只适用于select不涉及distinct，聚合函数，group by，having，union语句的情况


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 8.4 WITH CHECK OPTION
-- WITH CHECK OPTION,加上这句在创建视图的结尾，防止更改数据

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 8.5 视图其他优点
-- 减小改动带来的影响

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- Chapter 9 储存过程 stored procedures
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 用于储存和管理SQL代码，运行更快，
-- 加强数据安全性（取消所有表得访问权限，各种操作都由储存过程完成，指定操作权限，防止用户更改数据）


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 9.2	创建储存过程
-- CREATE PROCEDURE
-- 在stored procedures右键创建，输入代码后apply会自动生成，确认并保存。
DELIMITER $$	-- 默认分隔符改为 $$
DELIMITER ;		-- 默认分隔符改回 ;
-- 其他平台不需要更改默认分隔符

-- 调用stored procedures,直接执行语句
CALL get_clients();

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 9.4	删除储存过程

DROP PROCEDURE get_clients;
DROP PROCEDURE IF EXISTS get_clients();

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 9.5	参数parameters

USE `sql_store`;
DROP procedure IF EXISTS `get_client_by_state`;

DELIMITER $$
USE `sql_store`$$
CREATE PROCEDURE `get_client_by_state` (state CHAR(2))
BEGIN
	SELECT * FROM clients C
    WHERE C.STATE = STATE;
END$$

DELIMITER ;

CALL get_client_by_state('ca');


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 9.6	带默认值的参数

USE `sql_store`;
DROP procedure IF EXISTS `get_client_by_state`;

DELIMITER $$
USE `sql_store`$$
CREATE PROCEDURE `get_client_by_state` (state CHAR(2))
BEGIN
	IF state IS NULL THEN
		SET STATE = 'CA';
	END IF;
    
	SELECT * FROM clients C
    WHERE C.STATE = STATE;
END$$

DELIMITER;

CALL get_client_by_state(NULL);

DELIMITER $$
USE `sql_store`$$
CREATE PROCEDURE `get_client_by_state` (state CHAR(2))
BEGIN
	SELECT * FROM clients C
    WHERE C.STATE = IFNULL(STATE,C.STATE);
END$$

DELIMITER;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 9.7	参数验证 parameters validation
-- 用过程procedures还可以实现插入，更新，删除数据
-- 参数验证确保procedures不会意外的向数据库存储错误数据
-- 为了防止输入的数值是不合理的量，比如负数，需要用到参数验证 parameters validation
-- SIGNAL SQLSTATE+'ERROR CODE'用于标记或引发错误
-- 搜索sqlstate errors，获得error code

-- DECIMAL(9,2)小数，9表示总位数，2表示小数位数
CREATE DEFINER=`root`@`localhost` PROCEDURE `make_payment`(
	invoice_id INT,
    payment_amount DECIMAL(9,2),
    payment_date DATE
)
BEGIN
	IF PAYMENT_AMOUNT<=0 THEN
		SIGNAL SQLSTATE '22003'
		SET MESSAGE_TEXT =  'invalide payment amount';
	END IF; -- 以上是参数验证过程
	UPDATE invoices i 
    SET
		i.payment_total = payment_amount,
        i.payment_date = payment_date
	WHERE i.invoice_id = invoice_id;
END;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 9.8 输出参数
-- 以下两procedures会输出相同的值，第二种加上out表示是输出变量
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_unpaid_invoices_for_client`(
	client_id INT
)
BEGIN
	SELECT 
		CLIENT_ID,
		COUNT(*),
        SUM(invoice_total)
    FROM invoices i
    WHERE i.client_id = client_id AND payment_total = 0;
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_unpaid_invoices_for_client`(
	client_id INT,
    OUT invoices_count INT,
    OUT invoices_total DECIMAL(9,2)
)
BEGIN
	SELECT 
		COUNT(*),
        SUM(invoice_total)
	INTO invoices_count, invoices_total
    FROM invoices i
    WHERE i.client_id = client_id AND payment_total = 0;
END;
-- 不同的是调用的过程，第二种调用有输出参数的procedures时需要使用set+@变量
set @invoices_count = 0;
set @invoices_total = 0;
call sql_invoicing.get_unpaid_invoices_for_client(3, @invoices_count, @invoices_total);
select @invoices_count, @invoices_total;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 9.9	变量variables
-- 传递输出变量，获取输出参数值
-- user/session variables：
set @invoices_count = 0;

-- local variables：
-- DECLARE语句用于声明变量,在计算结束后会被释放不会储存
-- 计算风险因素risk_fector:
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_risk_factor`()
BEGIN
	DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
    DECLARE invoices_total DECIMAL(9,2);
    DECLARE invoices_count INT;
    
    SELECT 
		COUNT(*),
        SUM(INVOICE_TOTAL)
	INTO invoices_count, invoices_total
    FROM invoices i;
    
    SET risk_factor = invoices_total/invoices_count*5;
    SELECT risk_factor;
END;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 9.10	函数function		创建自己的函数
-- 但是function只能返回单一值，无法像procedure一样返回多行或多列的结果值

-- return明确了返回值的类型，return后要设置函数属性
-- DETERMINISTIC意味着输入相同时永远返回相同的输出值
-- READS SQL DATA意味着函数中会配置选择语句，用来读取数据
-- MODIFIES SQL DATA函数中有插入，更新或删除函数
-- 可以同时有多种属性
CREATE DEFINER=`root`@`localhost` FUNCTION `get_risk_factor_for_client`(
	client_id INT
) RETURNS int
    READS SQL DATA
BEGIN
	DECLARE risk_factor DECIMAL(9,2) DEFAULT 0;
    DECLARE invoices_total DECIMAL(9,2);
    DECLARE invoices_count INT;
    
    SELECT 
		COUNT(*),
        SUM(INVOICE_TOTAL)
	INTO invoices_count, invoices_total
    FROM invoices i
    WHERE i.client_id = client_id;
    
    SET risk_factor = invoices_total/invoices_count*5;
	RETURN IFNULL(risk_factor,0);
END;

-- 调用函数：
SELECT
	client_id,
    name,
    get_risk_factor_for_client(client_id) AS RISK_FACTOR
FROM clients;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 10.1	触发器 Triggers
-- triggers是在插入删除更新语句前后自动执行的一段sql代码，增强数据的一致性

-- 例如，每次添加一笔payment，要同时确保payment——total也相应的进行更新

-- 显示triggers：可以加 LIKE 子句筛选trigger
SHOW TRIGGERS
DROP TRIGGERS IF EXISTS +TRIGGER_NAME;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 10.5	EVENTS 事件
-- 自动化数据库维护任务或把数据从一张表复制到存档表或汇总数据生成报告

SHOW VARIABLES LIKE 'EVENT%';

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 11.1	transaction 事务
-- 代表工作单元的一组sql语句
-- 只有所有语句都被成功执行之后事务才成功执行，否则会撤回所有操作


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 12.1	数据类型 （本章细节见notebook）

-- 数据类型： 
-- 1.string 	2.numeric	3.date and time	4.blod（二进制）	5.spatial（几何/地区值的空间类型）

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 12.2	string字符串 


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 12.9 JSON数据类型
-- 好处是可以直接从JSON对象中提取键值对
-- 注意：键值名称是区分大小写的

-- 几种创建方式：
UPDATE products
SET properties = '
{
	"dimentions":[1,2,3],
    "weight":10,
    "manufacture":{"name":"sony"}
}
'
WHERE product_id = 1;

UPDATE products
SET properties = JSON_OBJECT(
	'WEIGHT',10,
    'DIMENTION',JSON_ARRAY(1,2,3),
    'MANUFACTURE', JSON_OBJECT('NAME','SONY')
)
WHERE product_id = 1;

-- 直接提取键值对：
-- JSON_EXTRACT()	第一个参数是json对象,第二个参数是路径'$.'$表示当前JSON文档，+.+单独的属性/键
-- '->'列路径运算符,	'->>'可以去掉“”进而用于判断语句
SELECT 
	product_id,
    JSON_EXTRACT(properties,'$.WEIGHT') AS WEIGHT,
    properties -> '$.WEIGHT' AS weight,	-- 上一句简化写法
    JSON_EXTRACT(properties,'$.DIMENTION') AS DIM,
    JSON_EXTRACT(properties,'$.DIMENTION[0]') AS DIM_0,
    JSON_EXTRACT(properties,'$.MANUFACTURE') AS MANUFACTURE,
    JSON_EXTRACT(properties,'$.MANUFACTURE.NAME') AS MANUFACTURE_name,
    properties -> '$.MANUFACTURE.NAME' AS NAME,
    properties ->> '$.MANUFACTURE.NAME' AS name
FROM PRODUCTS
WHERE PRODUCT_ID=1;

-- 更新某些属性，不重置整个JSON对象：
-- JSON_SET(),增加/改变某些属性,先传递JASON对象，然后是想要设置的属性和对应值； 
-- JSON_REMOVE()，删除键，先传递JSON对象，然后列出要删除的键

UPDATE products
SET properties = JSON_SET(
	properties,
    '$.chloe','name',
    '$.wenqi',3,
    '$.WEIGHT',20
)
WHERE product_id = 1;
SELECT properties,product_id
FROM PRODUCTS
WHERE product_id = 1;

UPDATE products
SET properties = JSON_REMOVE(
	properties,
    '$.chloe'
)
WHERE product_id = 1;
SELECT properties,product_id
FROM PRODUCTS
WHERE product_id = 1;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 13	设计数据库 Design database

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 13.2	Data modelling
-- 1.概念模型Conceptual models；逻辑模型logical models；物理模型physical models
-- 2.见备忘录


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 13.3 conceptual Models 概念模型
-- 表示业务中的实体（人事物位置eg，学生，课程），事物或概念及其关系。
-- 可视化概念：实体关系图ER Entity Relationship（常用于数据建模）
-- 			/UML图标准建模语言图 Unified modeling languages

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 13.5 Pysical model 实体模型
-- 是逻辑模型通过特定数据库技术的实现
-- >file >new model >add diagram >add tables

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 13.6 primary key 主键
-- 可以使用一个主键，可以用多个联合主键composite primary key，联合主键可以防止不良数据被添加，比如为同一学生注册相同课程多次
-- 同时可以设置自动递增防止重复，
-- 13.7 foreign key 外键
-- 选择关系表格时，先选外键表，后选主键表，即先选子后选父
-- 要为外键设置约束，保护数据不受损坏

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 13.9 标准化 Normalization
-- Redundant or duplicated date 审查数据库的设计确保遵循防止数据重复的预定义规则Seven normal forms
-- 第一范式：一行中每个单元格都有单一值，且不能有重复列--tags列违反规则，将表单独表建模，并和课程建立多对多的关系。
-- 第二范式：每张表都应该单一目的。只能代表一种实体类型，而且每一列都应该用来描述实体
-- 第三范式：表中列不应派生自其他列或由其他列计算可得

-- 实体entities，属性attributes，值values

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 13.16 模型的正向工程 forward engineer
-- database > forward engineer 没有数据时，用模型生成数据库
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 13.17 数据库同步模型 Synchronize model
-- 有数据库，将数据库与模型同步

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 13.18 模型逆向工程 Reverse engineer
-- 根据数据库生成模型和图


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 13.25 创建和删除数据库 data administrator数据管理员

CREATE DATABASE IF NOT EXISTS sql_store2;
DROP DATABASE IF EXISTS sql_store2;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 13.26 创建表 CREATE TABLE/DROP TABLE

USE sql_store2;
DROP TABLE IF EXISTS customers;
CREATE TABLE IF NOT EXISTS customers
(
	customer_id INT PRIMARY KEY AUTO_INCREMENT,	-- 列名，类型，其他属性。。。
    first_name VARCHAR(50) NOT NULL,
    points INT NOT NULL DEFAULT 0,
    email VARCHAR(255) NOT NULL UNIQUE
);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 13.27 更改表
-- 更改表格(不能在生产环境下更改表格) ALTER TABLE
-- 如果列名中包含空格，则必须使用反引号`first name`

-- 创建表格之后添加，修改，删除列：
ALTER TABLE customers
	ADD last_name 	VARCHAR(50) NOT NULL AFTER first_name,
    ADD city 		VARCHAR(50) NOT NULL,
    MODIFY COLUMN first_name VARCHAR(55) DEFAULT '',
    DROP points;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 13.28 创建关系 FOREIGN KEY ... REFERENCES

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE IF NOT EXISTS orders
(
	order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    -- 定义外键：常用命名：fk_子表名-父列
    FOREIGN KEY fk_orders_customers(customer_id)
		-- 引用父
		REFERENCES customers(customer_id)
        -- 指定specify更新和删除行为：
		ON UPDATE CASCADE -- 或者SET NULL/NO ACTION
        ON DELETE NO ACTION
);
-- 父表无法被删除，因为包含关系，需要先删除子表orders然后才能删除customers

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 13.29 更改主键和外键约束
-- 删除或创建已存在的表的关系   
ALTER TABLE orders 	
	DROP FOREIGN KEY orders_ibfk_1;
    
-- 显示表格各列属性和关系：可用于删除关系时查看foreign key名称：
SHOW CREATE TABLE ORDERS; 


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 13.30 字符集和排序规则 Character set and colations

-- 查看当前支持的所有字符集：
SHOW CHARSET;

-- 用鼠标visually更改列和表格level的字符集（鼠标无法更改数据库层级的字符集）：
-- 数据库右键 > schema inspector模式检查 > 查看default characterset
-- open table design mode 下拉菜单

-- 在database level更改字符集character set：

-- 创建数据集时设置和更改：
CREATE DATABASE DB_NAME
	CHARACTER SET LATIN1;
    
ALTER DATABASE DB_NAME
	CHARACTER SET UTF8;
    
-- 创建表格时设置和更改：   
CREATE TABLE PEOPLE
(
	ID INT,
    PEOPLE VARCHAR(50)
)
CHARACTER SET UTF8;

ALTER TABLE PEOPLE
CHARACTER SET LATIN1;

-- 创建表格时设置和更改列column的字符集 在设置数据类型之后，其他限制之前：
CREATE TABLE PEOPLE
(
	ID INT NOT NULL,
    PEOPLE VARCHAR(50) CHARACTER SET LATIN1 NOT NULL
);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 13.31 STORAGE ENGINES储存引擎
-- 数据引擎决定了数据如何被储存，以及哪些功能可以使用
SHOW ENGINES;
-- 最常用的引擎是MyISAM（老版本）和InnoDB（新流行）
-- 可以在table 设计模式下拉菜单更改引擎：
ALTER TABLE CUSTOMERS
ENGINE = InnoDB;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 14.1 INDEXING FOR HIGN PERFORMANCE 高效的索引
-- 在大型数据库和高流量网站中，索引非常重要，可显著提高查询性能indexes speed up our queries

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 14.2 Index
-- index加速查询，但是增加数据库大小，必须永久存储在表旁边，增加更新删除数据时会更新相应的索引，会影响性能
-- 因此，必须为性能关键的查询performance critical queries 保留索引。比应该基于table创建索引，应基于查询创建索引。
-- 索引常被储存为二进制树binary tree

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 14.3 创建索引 create index
-- 查询加州顾客：

-- 查看查询是如何被执行的：
EXPLAIN
SELECT CUSTOMER_ID 
FROM customers
WHERE STATE = 'CA';
-- Type：ALL		将要做全表扫描		Rows：扫描的记录条数

-- 创建Index
CREATE INDEX idx_state ON CUSTOMERS (STATE);

SELECT COUNT(CUSTOMER_ID) 
FROM customers
WHERE STATE = 'CA';

CREATE INDEX idx_points ON customers(points);
EXPLAIN
SELECT CUSTOMER_ID
FROM CUSTOMERS
WHERE POINTS>1000;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 14.4 查看索引 viewing index

-- 在控制面板可以找到index
-- 显示表格中存在的index：
SHOW INDEXES IN CUSTOMERS;
-- PRIMARY:clustered index聚集索引，创建主键时自动创建，Collation：A-升序ascending；D-降序descending
-- Secondary index:其他index
-- 显示表格统计信息：
ANALYZE TABLE CUSTOMERS;
SHOW INDEXES IN orders;
-- 创建外键时也会自动创建相应的index

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 14.5 前缀索引 Prefix index

-- 字符串类型的列： CHAR,VARCHAR,TEXT,BLOB
-- 为了缩小index，可以只包含列的前几个字符或者列前缀
CREATE INDEX idx_lastname on customers(last_name(10));

-- 判断多少字符更好
SELECT 
	COUNT(DISTINCT left(LAST_NAME,1)),
    COUNT(DISTINCT left(LAST_NAME,5)),
    COUNT(DISTINCT left(LAST_NAME,10)) 
FROM CUSTOMERS;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 14.6 全文索引 Full-text index
-- 功能强大，可用于在应用程序中搭建搜索引擎，尤其是在篇幅很长的字符串列中搜索，如报纸文章或博客文章或产品描述。
-- 对于名称，地址等较短的字符串列，可用前缀索引

USE SQL_BLOG;
-- REACT是常用的JavaScript库，用来搭建前端应用程序。常搭配redux库使用。
-- 如何在博客中搜索和‘react redux’相关的文章

-- 速度慢，功能差：
SELECT * 
FROM POSTS
WHERE title LIKE '%react redux%' OR 
		body LIKE '%react redux%';

-- 全文索引可在应用程序中打造快速强大的搜索引擎，包括整个字符串列而不只是存储前缀，忽略任何停止词in，on，the。。。

-- 全文搜索有两种模式，一种是默认的自然语言模式：
CREATE FULLTEXT INDEX idx_title_body ON POSTS(title,body);

SELECT *, MATCH(title,body) AGAINST('react redux') as relevant_score
FROM POSTS
WHERE MATCH(title,body) AGAINST('react redux');
-- 全文搜索的优点，包含了“相关性得分”，会基于若干因素，为包含短语的每行计算相关性得分[0,1]relevance score。0分表示不相关

-- 另一种模式是布尔模式：可以包括或排除某些单词：用正负号表示必须包含和不包含：
SELECT *, MATCH(title,body) AGAINST('react redux') as relevant_score
FROM POSTS
WHERE MATCH(title,body) AGAINST('react -redux +form' IN BOOLEAN MODE);

-- 单引号中单词不分先后顺序，用双引号表示搜索某固定短语：
SELECT *, MATCH(title,body) AGAINST('react redux') as relevant_score
FROM POSTS
WHERE MATCH(title,body) AGAINST('“handling a form”' IN BOOLEAN MODE);

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 14.7 复合索引 composite index

USE sql_store;
SHOW INDEX IN CUSTOMERS;
-- 直接使用两个搜索时，只能起到加速一半的作用（state），对于后面的条件仍然是逐条搜索
EXPLAIN SELECT customer_ID
FROM CUSTOMERS
WHERE STATE = 'CA' AND POINTS>1000;

-- 使用复合索引：	一个索引最多可包含16列，一般4-6列会达到最好的性能

CREATE INDEX idx_state_points ON customers(state,points);
EXPLAIN SELECT customer_ID
FROM CUSTOMERS
WHERE STATE = 'CA' AND POINTS>1000;

SHOW INDEX IN customers;
DROP INDEX idx_lastname ON customers;
DROP INDEX idx_state ON customers;
DROP INDEX idx_points ON customers;
   
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 14.8 复合索引中的列顺序 order of column in composite index
-- 两条规则：1.应该对列进行排列，把使用最频繁的列排在前面。2 把基数cardinality更高的列排在前面，即the number of unique values in the column，比如gender的基数值是2.

CREATE INDEX idx_lastname ON customers(last_name);

CREATE INDEX idx_lastname_state ON customers(last_name,state);
EXPLAIN 
SELECT customer_id
FROM CUSTOMERS
WHERE STATE = 'CA' AND last_name like 'A%';
-- 以上代码rows=80

CREATE INDEX idx_state_lastname ON customers(state,last_name);
EXPLAIN 
SELECT customer_id
FROM CUSTOMERS
WHERE STATE = 'CA' AND last_name like 'A%';
-- 以上代码rows=14，该顺序显然更好，因此未必一定要遵循第二条规则。

-- 可以指定使用某个index进行查询：在from和where之间使用use index（）
EXPLAIN 
SELECT customer_id
FROM CUSTOMERS
USE INDEX (IDX_LASTNAME_STATE)
WHERE STATE = 'CA' AND last_name like 'A%';
-- state列用等号=约束，约束力更强，last_name使用筛选器使得更自由。因此对于这个特定查询来说state排在前面效率更高。快速定位到state，再筛选顾客。

EXPLAIN 
SELECT customer_id
FROM CUSTOMERS
USE INDEX (IDX_LASTNAME_STATE)
WHERE STATE LIKE 'A%' AND last_name like 'A%';

EXPLAIN 
SELECT customer_id
FROM CUSTOMERS
USE INDEX (IDX_STATE_LASTNAME)
WHERE STATE LIKE 'A%' AND last_name like 'A%';

DROP INDEX idx_lastname_state ON customers;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 14.9 index被忽略时

EXPLAIN 
SELECT customer_id
FROM CUSTOMERS
WHERE STATE = 'CA' OR POINTS>1000;

-- 为了增强效率，将其分成两个小的查询：
EXPLAIN 
	SELECT customer_id,STATE,POINTS
	FROM CUSTOMERS
	WHERE STATE = 'CA' 
    UNION
    SELECT customer_id,STATE,POINTS
    FROM CUSTOMERS
    WHERE POINTS>1000;
    
-- 使用含列的表达式会降低效率，因为会变成全索引搜素：
EXPLAIN SELECT customer_id FROM customers
WHERE points+10 > 1000;
-- 解决方法：把列单独放在一边：
EXPLAIN SELECT customer_id FROM customers
WHERE points> 1000-10;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 14.10 用索引进行排序

SHOW INDEXES IN customers;
-- 在extra部分可看到：using index
EXPLAIN 
SELECT customer_id FROM customers
ORDER BY state;
-- 在extra部分：using filesort很耗时
EXPLAIN 
SELECT customer_id FROM customers
ORDER BY first_name;

-- 用 SHOW STATUS 语句查看服务器变量：
SHOW STATUS;
-- 其中，last query cost记录了上次查询的成本：
SHOW STATUS LIKE 'LAST_QUERY_COST';

-- 按照多个列排列会更复杂。只要有不含index的列就会使用filesort排序。
-- 包含升降序（DESC）时也会导致成本增加。全部列都降序或者升序排列时不会增加成本，升降序混合会变成filesort。

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 14.11 覆盖索引
-- 一个包含所有满足查询需要的数据的索引。使用该索引可以在不读表的情况下执行查询。

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 14.12 维护索引

-- 注意重复索引 duplicate indexes 和 多余索引 redundant indexes

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 15 保护数据库

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 15.2 创建用户 create users

-- 之前的教程都是在使用根用户连接到数据库服务器，在工作环境使用数据库时需要创建其他用户账户并赋予权限。
-- 例如，desk application/web 赋予阅读和写入 database server
-- 可以选择限制用户的链接位置@+IP address/hostname/指定域名
-- 在云环境中特别实用 web server<->database server

CREATE USER john@127.0.0.1  -- 自己计算机的IP address 说明该用户只能从同一台安装了MySQL的计算机连接。
CREATE USER john@localhost  -- hostname(当前计算机)
CREATE USER john@codewithmosh.com	-- 表示用户可从该域中任何计算机连接，但无法从codewithmosh.com子网域连接。
CREATE USER john@'%.codewithmosh.com'	-- 加上通配符%.和引号,包含域中任何计算机和子网域
CREATE USER john 	-- 不加任何限制，用户可从任何位置连接
;

CREATE USER john IDENTIFIED BY '9876543210Abc@';	-- IDENTIFIED BY:设置密码为‘7654’

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 15.3 查看用户 viewing users

-- 方法一：
use mysql;
select * from mysql.user;
-- 可以运行以下查询来检查用户表是否存在。
SELECT * FROM information_schema.TABLES
WHERE TABLE_NAME LIKE '%user%'

-- 方法二：打开左侧管理选项卡 administration > Users and Privileges

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
-- 15.4 删除用户
CREATE USER Ben@codewithmosh.com IDENTIFIED BY '9876543210Abc@';
DROP USER Ben@codewithmosh.com;