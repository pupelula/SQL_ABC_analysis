# 🔍Что такое ABC анализ?
Это метод, используемый в управлении запасами для классификации товаров или клиентов в зависимости от их важности и степени вклада в результат компании.

**Группа А:** важные товары, которые вносят значительный вклад в доход или составляют большую часть стоимости запасов. Обычно они требуют тщательного мониторинга и жесткого контроля. 

**Группа B:** это товары средней важности. Они требуют регулярного мониторинга и управления.

**Группа С:** эти товары оказывают минимальное влияние на доход или стоимость запасов. Обычно они имеют более низкий приоритет для управления. Часто это претенденты на исключение из ассортимента или новые товары.

Оптимизируя управление запасами и распределение ресурсов, анализ ABC помогает компаниям повысить эффективность и принимать более обоснованные решения при ограниченных ресурсах. 

# 💾Исходные данные
<img width="65%" align="right" alt="Bootcamp" src="https://github.com/pupelula/SQL_ABC_analysis/blob/main/tables.png"/>

<p align="left">
  <samp>
   
Таблица **list_of_orders**
 - order_id
 - order_date
 - customer_name
 - state
    
Таблица **order_details**
 - order_id
 - amount
 - profit
 - quantity
 - category
 - sub_category
  </samp>
</p>

# ✏Анализ данных
```javascript
//Для начала соединим две таблицы и создадим набор данных с информацией об общей прибыли для каждой подкатегории.

WITH profit_by_sub_category AS
(SELECT sub_category, SUM(profit) AS sub_category_profit
FROM 
list_of_orders
INNER JOIN order_details 
USING (order_id)
GROUP BY sub_category),

//Создадим новые столбцы. Доля прибыли показывает, какой вклад вносит подкатегория в формирование прибыли.

profit_share_by_category AS
(SELECT sub_category, sub_category_profit,
ROUND((sub_category_profit / SUM(sub_category_profit) OVER () * 100)::DECIMAL, 2) AS profit_share
FROM profit_by_sub_category
WHERE sub_category_profit > 0)

//И наконец подсчитаем общий итог и присвоим каждой подкатегории свой балл с помощью функции CASE

SELECT sub_category, profit_share, 
CASE
WHEN cumulative_share < 80 THEN 'A'
WHEN cumulative_share < 95 THEN 'B'
ELSE 'C'
END AS ABC
FROM 
(SELECT sub_category, profit_share,
SUM(profit_share) OVER (ORDER BY profit_share DESC) AS cumulative_share
FROM profit_share_by_category) AS cum_by_sub_category
```

# 📊Результат
В ходе ABС анализа каждой подкатегории был присвоен балл важности.
<img width="45%" src="https://github.com/pupelula/SQL_ABC_analysis/blob/main/result_table.png?raw=true"/>

А теперь посмотрим на результаты распределения в виде бар-чарта.

<img width="75%" src="https://github.com/pupelula/SQL_ABC_analysis/blob/main/profit_chart.png?raw=true"/>

